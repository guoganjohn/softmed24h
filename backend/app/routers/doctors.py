from typing import List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.user import Role, User as UserModel
from app.schemas import user as user_schema
from app.routers.users import get_password_hash

router = APIRouter()


@router.post("/", response_model=user_schema.User)
def create_doctor(
    user: user_schema.UserCreate, db: Session = Depends(get_db)
):
    db_user = db.query(UserModel).filter(UserModel.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed_password = get_password_hash(user.password)
    db_user = UserModel(
        **user.dict(),
        hashed_password=hashed_password,
        role=Role.DOCTOR,
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
    user: user_schema.UserCreate,
    db: Session = Depends(get_db),
):
    db_user = (
        db.query(UserModel)
        .filter(UserModel.id == doctor_id, UserModel.role == Role.DOCTOR)
        .first()
    )
    if db_user is None:
        raise HTTPException(status_code=404, detail="Doctor not found")
    user_data = user.dict(exclude_unset=True)
    for key, value in user_data.items():
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
