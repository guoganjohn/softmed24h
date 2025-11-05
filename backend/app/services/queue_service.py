import os
from datetime import datetime
from typing import List, Optional

import redis
from dotenv import load_dotenv
from sqlalchemy.orm import Session

from app.database import SessionLocal
from app.models.appointment import Appointment
from app.models.user import User

load_dotenv()


class QueueService:
    def __init__(self):
        self.redis_url = os.getenv("REDIS_URL")
        if self.redis_url is None:
            raise Exception("REDIS_URL environment variable is not set.")
        self.redis = redis.from_url(self.redis_url)
        self.queue_name = (
            "patient_queue"  # This is for the Redis queue itself (order of entry)
        )

    @staticmethod
    def get_db() -> Session:  # Helper to get DB session
        db = SessionLocal()
        try:
            yield db
        finally:
            db.close()

    def add_to_queue(self, patient_id: int):
        try:
            # Check if patient is already in Redis queue to avoid duplicates in Redis
            # Note: This doesn't prevent adding to DB if already in DB status 'waiting'
            if not self.redis.lpos(self.queue_name, patient_id):
                self.redis.rpush(self.queue_name, patient_id)

                # Update user status in DB
                db_session = next(self.get_db())
                user = db_session.query(User).filter(User.id == patient_id).first()
                if user:
                    user.queue_status = "waiting"
                    user.queue_entry_time = datetime.now()
                    db_session.commit()
                    db_session.refresh(user)
                else:
                    # If patient_id does not exist in DB, we might want to raise an error or log it.
                    # For now, we'll assume valid patient_ids are passed.
                    pass
            # else: Patient already in Redis queue, do nothing or return a specific message.
        except redis.exceptions.ConnectionError as e:
            raise Exception(f"Failed to connect to Redis: {e}") from e
        except Exception as e:
            raise Exception(f"Failed to add patient to queue: {e}") from e

    def remove_from_queue(
        self, patient_id: int, status: str = "completed"
    ):  # Added status parameter
        try:
            # Remove from Redis queue
            removed_count = self.redis.lrem(self.queue_name, 0, patient_id)

            # Update user status in DB regardless of Redis removal success,
            # as the status might have already been updated by another process.
            db_session = next(self.get_db())
            user = db_session.query(User).filter(User.id == patient_id).first()
            if user:
                user.queue_status = (
                    status  # e.g., 'completed', 'no_wait', 'cancelled', 'in_service'
                )
                # Clear queue_entry_time if status is not 'waiting'
                if status != "waiting":
                    user.queue_entry_time = None
                db_session.commit()
                db_session.refresh(user)
            # else: patient_id not found in DB, handle as error if necessary.

        except redis.exceptions.ConnectionError as e:
            raise Exception(f"Failed to connect to Redis: {e}") from e
        except Exception as e:
            raise Exception(f"Failed to remove patient from queue: {e}") from e

    def get_queue(self) -> List[int]:
        """
        Returns the list of patient IDs currently in the Redis queue.
        Note: For a more robust implementation, this should query the DB for users with status 'waiting'
        and order them by queue_entry_time to ensure consistency with DB state.
        The current implementation relies on Redis for the order.
        """
        try:
            return [
                int(patient_id)
                for patient_id in self.redis.lrange(self.queue_name, 0, -1)
            ]
        except redis.exceptions.ConnectionError as e:
            raise Exception(f"Failed to connect to Redis: {e}") from e
        except Exception as e:
            raise Exception(f"Failed to retrieve queue: {e}") from e

    # --- New methods based on DOCTOR_BACKEND.md ---

    def get_queue_stats(self) -> dict:
        """Returns a dictionary with all queue-related counts."""
        stats = {
            "in_attendance_count": len(self.get_customers_in_attendance_with_doctor()),
            "waiting_count": self.get_waiting_customers_count(),
            "completed_count": self.get_completed_services_count(),
            "no_wait_count": self.get_no_wait_services_count(),
        }
        return stats

    def get_customers_in_attendance_with_doctor(self) -> List[dict]:
        """Shows the list of customers in attendance with the name of the professional who is currently assisting the customer."""
        db_session = next(self.get_db())

        # Query for appointments that are 'in_progress'
        # Join with User table for patient details (name)
        # Join with User table again for doctor details (name)

        appointments_in_progress = (
            db_session.query(
                Appointment.id,
                Appointment.patient_id,
                Appointment.doctor_id,
                Appointment.appointment_time,
                User.name.label("patient_name"),
                User.queue_status,  # Include patient's queue status
                User.queue_entry_time,  # Include patient's queue entry time
            )
            .join(User, Appointment.patient_id == User.id)
            .filter(Appointment.status == "in_progress")
            .all()
        )

        results = []
        for appt in appointments_in_progress:
            # Fetch doctor's name by doctor_id
            doctor = db_session.query(User).filter(User.id == appt.doctor_id).first()
            doctor_name = doctor.name if doctor else "Unknown Doctor"

            results.append(
                {
                    "appointment_id": appt.id,
                    "patient_id": appt.patient_id,
                    "patient_name": appt.patient_name,
                    "doctor_id": appt.doctor_id,
                    "doctor_name": doctor_name,
                    "queue_status": appt.queue_status,  # Patient's current queue status
                    "queue_entry_time": appt.queue_entry_time,  # Patient's queue entry time
                    "service_start_time": appt.appointment_time,  # When the service started
                }
            )

        return results

    def get_completed_services_count(self) -> int:
        """Shows the total number of services already carried out with completed status."""
        db_session = next(self.get_db())
        count = db_session.query(User).filter(User.queue_status == "completed").count()
        return count

    def get_no_wait_services_count(self) -> int:
        """Shows the total number of people who entered the service queue but did not wait to be served."""
        db_session = next(self.get_db())
        count = db_session.query(User).filter(User.queue_status == "no_wait").count()
        return count

    def get_no_wait_services_count(self) -> int:
        """Shows the total number of people who entered the service queue but did not wait to be served."""
        db_session = next(self.get_db())
        count = db_session.query(User).filter(User.queue_status == "no_wait").count()
        return count

    def get_waiting_customers_count(self) -> int:
        """Shows the total number of customers in the queue waiting for the appointment to begin."""
        db_session = next(self.get_db())
        count = db_session.query(User).filter(User.queue_status == "waiting").count()
        return count

    def get_next_patient(self) -> Optional[User]:
        """Gets the next patient from the 'waiting' queue, ordered by entry time."""
        db_session = next(self.get_db())
        # Query for users with 'waiting' status, ordered by their entry time
        next_patient = (
            db_session.query(User)
            .filter(User.queue_status == "waiting")
            .order_by(User.queue_entry_time)
            .first()
        )
        return next_patient

    def update_patient_status(
        self, patient_id: int, new_status: str, doctor_id: Optional[int] = None
    ):
        """Updates a patient's queue status and optionally assigns a doctor (indirectly via Appointment)."""
        db_session = next(self.get_db())
        user = db_session.query(User).filter(User.id == patient_id).first()
        if not user:
            raise HTTPException(status_code=404, detail="Patient not found")

        user.queue_status = new_status
        if new_status != "waiting":  # Clear entry time if status is not 'waiting'
            user.queue_entry_time = None

        # If moving to 'in_service', this method itself doesn't create the Appointment.
        # That's handled by call_next_patient. This method just updates the User status.

        db_session.commit()
        db_session.refresh(user)

    def call_next_patient(self, doctor_id: int) -> dict:
        """
        Doctor initiates call for the next client in line.
        Generates a new meet call and starts the call for the next patient.
        """
        db_session = next(self.get_db())

        # 1. Get the next patient from the waiting queue (ordered by DB entry time)
        next_patient = self.get_next_patient()

        if not next_patient:
            raise HTTPException(
                status_code=404, detail="No patients waiting in the queue."
            )

        # 2. Update patient's status to 'in_service' in the User table
        # This method also clears queue_entry_time and handles DB commit/refresh.
        self.update_patient_status(
            patient_id=next_patient.id, new_status="in_service", doctor_id=doctor_id
        )

        # 3. Remove patient from Redis queue to keep it in sync with DB status
        # The status update in DB is the primary source of truth for queue status.
        # This ensures Redis doesn't hold stale IDs.
        try:
            self.redis.lrem(self.queue_name, 0, next_patient.id)
        except redis.exceptions.ConnectionError as e:
            # Log this error, but don't fail the whole operation if Redis is temporarily down
            print(
                f"Warning: Failed to remove patient {next_patient.id} from Redis queue: {e}"
            )

        # 4. Create an Appointment record for this service session
        # This links the patient to the doctor for the current service.
        new_appointment = Appointment(
            patient_id=next_patient.id,
            doctor_id=doctor_id,
            appointment_time=datetime.now(),  # Start time of service
            status="in_progress",  # Mark as currently in progress
        )
        db_session.add(new_appointment)
        db_session.commit()
        db_session.refresh(new_appointment)

        # 5. Generate a placeholder meet call link
        # In a real application, this would involve integrating with a video conferencing service.
        meet_call_link = f"https://meet.example.com/{next_patient.id}_{doctor_id}_{new_appointment.id}"

        return {
            "message": f"Calling next patient: {next_patient.name} (ID: {next_patient.id}) for Doctor ID: {doctor_id}",
            "patient_id": next_patient.id,
            "patient_name": next_patient.name,
            "doctor_id": doctor_id,
            "meet_call_link": meet_call_link,
            "appointment_id": new_appointment.id,
        }

    def get_waiting_customers_details(self) -> List[dict]:
        """Shows the list of customers waiting for service with detailed information."""
        db_session = next(self.get_db())

        # Query for users with 'waiting' status, ordered by their entry time
        waiting_patients = (
            db_session.query(User)
            .filter(User.queue_status == "waiting")
            .order_by(User.queue_entry_time)
            .all()
        )

        results = []
        for patient in waiting_patients:
            # Determine online/offline status. This is a placeholder.
            # In a real app, this would come from a presence system or last seen timestamp.
            # For now, we'll assume 'online' if they are in the 'waiting' status.
            online_status = "online"  # Placeholder for online/offline status

            results.append(
                {
                    "patient_id": patient.id,
                    "patient_name": patient.name,
                    "queue_entry_time": patient.queue_entry_time,
                    "status": patient.queue_status,  # Should be 'waiting'
                    "online_status": online_status,
                }
            )
        return results
