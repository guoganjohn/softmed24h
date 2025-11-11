import os
import secrets
from datetime import datetime, timedelta
from typing import Optional

from dotenv import load_dotenv
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt
from passlib.context import CryptContext
from sqlalchemy.orm import Session

from app.database import SessionLocal
from app.models.user import User as UserModel
from app.models.payment import Payment as PaymentModel
from app.schemas.token import TokenResponse
from app.schemas.user import (ForgotPasswordRequest, ResetPasswordRequest,
                              UserLogin)
from app.services.email_service import send_reset_email

load_dotenv()

router = APIRouter()

# Security settings
SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "30"))
BASE_URL = os.getenv(
    "FRONTEND_BASE_URL", "http://localhost:3000"
)  # Default for development

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/token")


# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


@router.post("/token", response_model=TokenResponse)
async def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)
):
    user = db.query(UserModel).filter(UserModel.email == form_data.username).first()
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.email, "name": user.name, "role": user.role.value}, expires_delta=access_token_expires
    )

    active_payment = (
        db.query(PaymentModel)
        .filter(
            PaymentModel.user_id == user.id,
            PaymentModel.end_date > datetime.utcnow(),
        )
        .first()
    )
    has_active_payment = active_payment is not None

    user_response = {
        "id": user.id,
        "email": user.email,
        "name": user.name,
        "is_active": user.is_active,
        "phone": user.phone,
        "cpf": user.cpf,
        "birthday": user.birthday,
        "has_active_payment": has_active_payment,
        "role": user.role,
        "crm": user.crm,
        "uf_crm": user.uf_crm,
        "bank_information": user.bank_information,
        "attached_document": user.attached_document,
    }

    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": user_response,
    }


@router.post("/forgot-password", status_code=status.HTTP_200_OK)
async def forgot_password(
    request: ForgotPasswordRequest, db: Session = Depends(get_db)
):
    user = db.query(UserModel).filter(UserModel.email == request.email).first()
    if not user:
        # For security, don't reveal if the user doesn't exist
        return {
            "message": "If a user with that email exists, a password reset link will be sent."
        }

    token = secrets.token_urlsafe(32)
    hashed_token = pwd_context.hash(token)
    expires_at = datetime.utcnow() + timedelta(hours=1)  # Token valid for 1 hour

    user.password_reset_token = hashed_token
    user.password_reset_expires_at = expires_at
    db.add(user)
    db.commit()
    db.refresh(user)

    reset_link = f"{BASE_URL}/reset-password?token={token}"
    send_reset_email(user.email, reset_link)

    return {
        "message": "If a user with that email exists, a password reset link will be sent."
    }


@router.post("/reset-password", status_code=status.HTTP_200_OK)
async def reset_password(request: ResetPasswordRequest, db: Session = Depends(get_db)):
    if request.new_password != request.confirm_password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="Passwords do not match"
        )

    user = (
        db.query(UserModel)
        .filter(
            UserModel.password_reset_token != None,
            UserModel.password_reset_expires_at > datetime.utcnow(),
        )
        .first()
    )

    if not user or not pwd_context.verify(request.token, user.password_reset_token):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid or expired token"
        )

    # Hash the new password and update in DB
    user.hashed_password = pwd_context.hash(request.new_password)
    user.password_reset_token = None  # Invalidate token
    user.password_reset_expires_at = None  # Clear expiry
    db.add(user)
    db.commit()
    db.refresh(user)

    return {"message": "Password has been reset successfully."}


def get_user_by_email(db: Session, email: str):
    return db.query(UserModel).filter(UserModel.email == email).first()


# Dependency to get the current user from the JWT token
async def get_current_user(
    token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)
) -> UserModel:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    user = get_user_by_email(db, email=email)
    if user is None:
        raise credentials_exception
    return user
