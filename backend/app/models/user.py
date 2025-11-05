from datetime import date, datetime

from sqlalchemy import Boolean, Column, Date, DateTime, Integer, String
from sqlalchemy.orm import relationship

from app.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    is_active = Column(Boolean, default=True)

    # New fields
    name = Column(String, index=True)
    gender = Column(String)
    cpf = Column(String, unique=True, index=True)
    phone = Column(String)
    birthday = Column(Date)
    cep = Column(String)
    logradouro = Column(String)
    numero = Column(String)
    complemento = Column(String, nullable=True)
    bairro = Column(String)
    estado = Column(String)
    cidade = Column(String)

    # Password reset fields
    password_reset_token = Column(String, nullable=True)
    password_reset_expires_at = Column(DateTime, nullable=True)

    medical_records = relationship("MedicalRecord", back_populates="patient")
    prescriptions = relationship(
        "Prescription",
        foreign_keys="[Prescription.patient_id]",
        back_populates="patient",
    )
    appointments_as_patient = relationship(
        "Appointment", foreign_keys="[Appointment.patient_id]", back_populates="patient"
    )
    appointments_as_doctor = relationship(
        "Appointment", foreign_keys="[Appointment.doctor_id]", back_populates="doctor"
    )
    prescriptions_as_prescriber = relationship(
        "Prescription",
        foreign_keys="[Prescription.prescriber_id]",
        back_populates="prescriber",
    )
    payments = relationship("Payment", back_populates="user")

    # Queue management fields
    queue_status = Column(
        String, index=True, default="waiting"
    )  # e.g., 'waiting', 'in_service', 'completed', 'no_wait'
    queue_entry_time = Column(DateTime, nullable=True)
