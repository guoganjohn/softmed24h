from typing import List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.user import Role, User as UserModel
from app.schemas import user as user_schema
from app.routers.users import get_password_hash, get_current_user
from app.services.referral_service import generate_unique_referral_code
from fastapi.security import OAuth2PasswordBearer
from fastapi import File, UploadFile
import base64
from app.models.payment import Payment as PaymentModel
from datetime import datetime

router = APIRouter()


@router.post("/", response_model=user_schema.User)
def create_doctor(
    user: user_schema.UserCreate, db: Session = Depends(get_db)
):
    db_user = db.query(UserModel).filter(UserModel.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed_password = get_password_hash(user.password)
    referral_code = generate_unique_referral_code(db)
    db_user = UserModel(
        **user.dict(exclude={"password", "role", "referral_code"}),
        hashed_password=hashed_password,
        role=Role.DOCTOR,
        is_active=False,
        referral_code=referral_code,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


@router.get("/", response_model=List[user_schema.User])
def read_doctors(
    skip: int = 0, limit: int = 100, db: Session = Depends(get_db)
):
    users = (
        db.query(UserModel)
        .filter(UserModel.role == Role.DOCTOR)
        .offset(skip)
        .limit(limit)
        .all()
    )
    return users


@router.get("/{doctor_id}", response_model=user_schema.User)
def read_doctor(doctor_id: int, db: Session = Depends(get_db)):
    db_user = (
        db.query(UserModel)
        .filter(UserModel.id == doctor_id, UserModel.role == Role.DOCTOR)
        .first()
    )
    if db_user is None:
        raise HTTPException(status_code=404, detail="Doctor not found")
    return db_user


@router.put("/{doctor_id}", response_model=user_schema.User)
def update_doctor(
    doctor_id: int,
    user: user_schema.UserUpdate,
    db: Session = Depends(get_db),
):
    db_user = (
        db.query(UserModel)
        .filter(UserModel.id == doctor_id, UserModel.role == Role.DOCTOR)
        .first()
    )
    if db_user is None:
        raise HTTPException(status_code=404, detail="Doctor not found")

    user_data = user.model_dump(exclude_unset=True)

    # Ensure referral_code is not updated
    if "referral_code" in user_data:
        del user_data["referral_code"]

    for key, value in user_data.items():
        if value is not None:
            setattr(db_user, key, value)

    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


@router.delete("/{doctor_id}", response_model=user_schema.User)
def delete_doctor(doctor_id: int, db: Session = Depends(get_db)):
    db_user = (
        db.query(UserModel)
        .filter(UserModel.id == doctor_id, UserModel.role == Role.DOCTOR)
        .first()
    )
    if db_user is None:
        raise HTTPException(status_code=404, detail="Doctor not found")
    db.delete(db_user)
    db.commit()
    return db_user


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="users/token")


@router.get("/referral-code", response_model=user_schema.ReferralCodeResponse)
def get_doctor_referral_code(
    current_user: user_schema.User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if current_user.role != Role.DOCTOR:
        raise HTTPException(status_code=403, detail="Only doctors can access this resource")
    
    if not current_user.referral_code:
        raise HTTPException(status_code=404, detail="Referral code not found for this doctor")
    
    return user_schema.ReferralCodeResponse(referral_code=current_user.referral_code)


async def _upload_document(file: UploadFile, current_user: UserModel, db: Session, document_field: str):
    if current_user.role != Role.DOCTOR:
        raise HTTPException(status_code=403, detail="Only doctors can upload documents")

    file_content = await file.read()
    encoded_content = base64.b64encode(file_content).decode("utf-8")

    setattr(current_user, document_field, encoded_content)
    db.add(current_user)
    db.commit()
    db.refresh(current_user)

    active_payment = (
        db.query(PaymentModel)
        .filter(
            PaymentModel.user_id == current_user.id,
            PaymentModel.end_date > datetime.utcnow(),
        )
        .first()
    )
    has_active_payment = active_payment is not None

    return user_schema.UserMeResponse(
        id=current_user.id,
        email=current_user.email,
        name=current_user.name,
        is_active=current_user.is_active,
        phone=current_user.phone,
        cpf=current_user.cpf,
        birthday=current_user.birthday,
        gender=current_user.gender,
        has_active_payment=has_active_payment,
        role=current_user.role,
        crm=current_user.crm,
        uf_crm=current_user.uf_crm,
        bank_information=current_user.bank_information,
        professional_card_document=current_user.professional_card_document,
        selfie_document=current_user.selfie_document,
        proof_of_residence_document=current_user.proof_of_residence_document,
        referral_code=current_user.referral_code,
    )

@router.post("/me/professional-card", response_model=user_schema.UserMeResponse)
async def upload_professional_card(
    file: UploadFile = File(...),
    current_user: UserModel = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return await _upload_document(file, current_user, db, "professional_card_document")

@router.post("/me/selfie", response_model=user_schema.UserMeResponse)
async def upload_selfie(
    file: UploadFile = File(...),
    current_user: UserModel = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return await _upload_document(file, current_user, db, "selfie_document")

@router.post("/me/proof-of-residence", response_model=user_schema.UserMeResponse)
async def upload_proof_of_residence(
    file: UploadFile = File(...),
    current_user: UserModel = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return await _upload_document(file, current_user, db, "proof_of_residence_document")
