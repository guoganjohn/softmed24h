from typing import List, Optional
from pydantic import BaseModel, Field
from datetime import datetime, date

class UserBase(BaseModel):
    email: str
    name: Optional[str] = None
    gender: Optional[str] = None
    cpf: Optional[str] = None
    phone: Optional[str] = None
    birthday: Optional[date] = None
    cep: Optional[str] = None
    logradouro: Optional[str] = None
    numero: Optional[str] = None
    complemento: Optional[str] = None
    bairro: Optional[str] = None
    estado: Optional[str] = None
    cidade: Optional[str] = None

class UserCreate(UserBase):
    password: str = Field(..., max_length=72)

class UserLogin(BaseModel):
    email: str
    password: str

class ForgotPasswordRequest(BaseModel):
    email: str

class ResetPasswordRequest(BaseModel):
    token: str
    new_password: str = Field(..., max_length=72)
    confirm_password: str = Field(..., max_length=72)

class User(UserBase):
    id: int
    is_active: bool
    logradouro: Optional[str] = None
    numero: Optional[str] = None
    complemento: Optional[str] = None
    bairro: Optional[str] = None
    estado: Optional[str] = None
    cidade: Optional[str] = None
    medical_records: List["MedicalRecord"] = []
    prescriptions: List["Prescription"] = []

    class Config:
        from_attributes = True

class UserBaseInfo(BaseModel):
    id: int
    email: str
    name: Optional[str] = None
    is_active: bool

class UserMeResponse(BaseModel):
    id: int
    email: str
    name: Optional[str] = None
    is_active: bool
    phone: Optional[str] = None
    has_active_payment: bool

# Import after User is defined to avoid circular import
from app.schemas.medical_record import MedicalRecord
from app.schemas.prescription import Prescription

User.update_forward_refs()