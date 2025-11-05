from datetime import datetime, timedelta
from typing import List

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.database import SessionLocal
from app.models.appointment import Appointment as AppointmentModel
from app.schemas.appointment import Appointment as AppointmentSchema
from app.schemas.appointment import CreateMeetingRequest
from app.services.google_meet_service import GoogleMeetService

router = APIRouter()


# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/appointments", response_model=List[AppointmentSchema])
def get_appointments(db: Session = Depends(get_db)):
    appointments = db.query(AppointmentModel).all()
    return appointments


@router.post("/create-meeting")
def create_meeting(
    request: CreateMeetingRequest, meet_service: GoogleMeetService = Depends()
):
    try:
        meet_link = meet_service.create_meeting(
            request.summary, request.start_time, request.end_time, request.attendees
        )
        return {"meet_link": meet_link}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to create Google Meet meeting: {e}",
        )
