from fastapi import APIRouter

router = APIRouter()


@router.get("/")
def get_medical_records():
    return {"message": "This is the medical_records router."}
