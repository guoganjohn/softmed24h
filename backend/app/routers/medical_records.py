from fastapi import APIRouter

router = APIRouter()


@router.get("/medical_records")
def get_medical_records():
    return {"message": "This is the medical_records router."}
