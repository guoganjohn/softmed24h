import os
from datetime import datetime
from typing import Optional
import shutil
import uuid

from fastapi import APIRouter, Depends, HTTPException, status, File, UploadFile
from passlib.context import CryptContext
from sqlalchemy.orm import Session

from app.database import SessionLocal
from app.models.payment import Payment as PaymentModel
from app.models.user import User as UserModel
from app.routers.auth import get_current_user, verify_password
from app.schemas import password as password_schema
from app.schemas import user as user_schema

router = APIRouter()

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def get_password_hash(password: str) -> str:
    """
    Hashes the password after ensuring it does not exceed the 72-character limit for bcrypt.
    """
    # Truncate the string to 72 characters if it's longer
    if len(password) > 72:
        password = password[:72]
    return pwd_context.hash(password)


# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/me", response_model=user_schema.UserMeResponse)
def read_users_me(
    current_user: UserModel = Depends(get_current_user), db: Session = Depends(get_db)
):
    """
    Get the current logged-in user's information, including active payment status and phone number.
    """
    active_payment = (
        db.query(PaymentModel)
        .filter(
            PaymentModel.user_id == current_user.id,
            PaymentModel.end_date > datetime.utcnow(),
        )
        .first()
    )
    has_active_payment = active_payment is not None

    return {
        "name": current_user.name,
        "email": current_user.email,
        "id": current_user.id,
        "is_active": current_user.is_active,
        "phone": current_user.phone,
        "cpf": current_user.cpf,
        "birthday": current_user.birthday,
        "gender": current_user.gender,
        "has_active_payment": has_active_payment,
        "role": current_user.role,
        "referral_code": current_user.referral_code,
        "professional_card_document": current_user.professional_card_document,
        "selfie_document": current_user.selfie_document,
        "proof_of_residence_document": current_user.proof_of_residence_document,
    }


@router.post("/", response_model=user_schema.User)
def create_user(user: user_schema.UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(UserModel).filter(UserModel.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed_password = get_password_hash(user.password)
    db_user = UserModel(
        email=user.email,
        hashed_password=hashed_password,
        name=user.name,
        gender=user.gender,
        cpf=user.cpf,
        phone=user.phone,
        birthday=user.birthday,
        cep=user.cep,
        logradouro=user.logradouro,
        numero=user.numero,
        complemento=user.complemento,
        bairro=user.bairro,
        estado=user.estado,
        cidade=user.cidade,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


@router.put("/me", response_model=user_schema.User)
def update_user_me(
    user_update: user_schema.UserUpdate,
    current_user: UserModel = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    user_in_db = db.query(UserModel).filter(UserModel.id == current_user.id).first()
    if not user_in_db:
        raise HTTPException(status_code=404, detail="User not found")

    update_data = user_update.model_dump(exclude_unset=True)

    # Ensure referral_code is not updated
    if "referral_code" in update_data:
        del update_data["referral_code"]

    for key, value in update_data.items():
        if value is not None:
            setattr(user_in_db, key, value)

    db.commit()
    db.refresh(user_in_db)
    return user_in_db


@router.put("/me/documents", status_code=status.HTTP_200_OK)
def update_user_documents(
    current_user: UserModel = Depends(get_current_user),
    db: Session = Depends(get_db),
    professional_card_document: Optional[UploadFile] = File(None),
    selfie_document: Optional[UploadFile] = File(None),
    proof_of_residence_document: Optional[UploadFile] = File(None),
):
    user_in_db = db.query(UserModel).filter(UserModel.id == current_user.id).first()
    if not user_in_db:
        raise HTTPException(status_code=404, detail="User not found")

    uploaded_paths = {}

    if professional_card_document:
        file_location = f"uploads/{uuid.uuid4()}_{professional_card_document.filename}"
        with open(file_location, "wb+") as file_object:
            shutil.copyfileobj(professional_card_document.file, file_object)
        user_in_db.professional_card_document = file_location
        uploaded_paths["professional_card_document"] = file_location

    if selfie_document:
        file_location = f"uploads/{uuid.uuid4()}_{selfie_document.filename}"
        with open(file_location, "wb+") as file_object:
            shutil.copyfileobj(selfie_document.file, file_object)
        user_in_db.selfie_document = file_location
        uploaded_paths["selfie_document"] = file_location

    if proof_of_residence_document:
        file_location = f"uploads/{uuid.uuid4()}_{proof_of_residence_document.filename}"
        with open(file_location, "wb+") as file_object:
            shutil.copyfileobj(proof_of_residence_document.file, file_object)
        user_in_db.proof_of_residence_document = file_location
        uploaded_paths["proof_of_residence_document"] = file_location

    db.commit()
    db.refresh(user_in_db)

    return {"message": "Documents updated successfully.", "uploaded_paths": uploaded_paths}

@router.delete("/me/documents", status_code=status.HTTP_200_OK)
def delete_user_document(
    document_type: str,
    current_user: UserModel = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    user_in_db = db.query(UserModel).filter(UserModel.id == current_user.id).first()
    if not user_in_db:
        raise HTTPException(status_code=404, detail="User not found")

    allowed_document_types = [
        "professional_card_document",
        "selfie_document",
        "proof_of_residence_document",
    ]

    if document_type not in allowed_document_types:
        raise HTTPException(status_code=400, detail="Invalid document type specified")

    # Get the current file path from the database
    file_path_to_delete = getattr(user_in_db, document_type)

    if file_path_to_delete:
        try:
            # Construct the full path to the file
            full_file_path = os.path.join(os.getcwd(), file_path_to_delete)
            if os.path.exists(full_file_path):
                os.remove(full_file_path)
            else:
                print(f"Warning: File not found at {full_file_path} for deletion.")
        except OSError as e:
            print(f"Error deleting file {full_file_path}: {e}")
            # Optionally, raise an HTTPException if file deletion is critical
            # raise HTTPException(status_code=500, detail=f"Failed to delete file: {e}")

    # Set the specified document field to None in the database
    setattr(user_in_db, document_type, None)

    db.commit()
    db.refresh(user_in_db)

    return {"message": f"{document_type.replace('_', ' ').title()} deleted successfully."}

@router.put("/me/password", status_code=status.HTTP_200_OK)
def update_password(
    password_update: password_schema.PasswordUpdate,
    current_user: UserModel = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if not verify_password(
        password_update.current_password, current_user.hashed_password
    ):
        raise HTTPException(status_code=400, detail="Incorrect current password")

    current_user.hashed_password = get_password_hash(password_update.new_password)
    db.merge(current_user)
    db.commit()
    return {"message": "Password updated successfully."}
