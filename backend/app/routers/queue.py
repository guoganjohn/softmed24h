from typing import List

from fastapi import APIRouter, Depends, HTTPException, status

from app.services.queue_service import QueueService

router = APIRouter()


@router.post("/{patient_id}")
def add_to_queue(patient_id: int, queue_service: QueueService = Depends()):
    try:
        queue_service.add_to_queue(patient_id)
        return {"message": f"Patient {patient_id} added to the queue."}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to add patient to queue: {e}",
        )


@router.delete("/{patient_id}")
def remove_from_queue(patient_id: int, queue_service: QueueService = Depends()):
    try:
        queue_service.remove_from_queue(patient_id)
        return {"message": f"Patient {patient_id} removed from the queue."}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to remove patient from queue: {e}",
        )


@router.get("/", response_model=List[int])
def get_queue(queue_service: QueueService = Depends()):
    try:
        return queue_service.get_queue()
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to retrieve queue: {e}",
        )


@router.post("/call_next/{doctor_id}", status_code=status.HTTP_200_OK)
def call_next_patient(doctor_id: int, queue_service: QueueService = Depends()):
    try:
        # The call_next_patient method in QueueService handles updating DB and Redis, creating Appointment, and generating meet link.
        result = queue_service.call_next_patient(doctor_id=doctor_id)
        return result
    except HTTPException as e:
        # Re-raise HTTPException to preserve status code and detail
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to call next patient: {e}",
        )


@router.get("/stats")
def get_queue_stats(queue_service: QueueService = Depends()):
    try:
        return queue_service.get_queue_stats()
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to retrieve queue stats: {e}",
        )
