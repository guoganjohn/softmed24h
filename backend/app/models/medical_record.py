from datetime import datetime

from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import relationship

from app.database import Base


class MedicalRecord(Base):
    __tablename__ = "medical_records"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("users.id"))
    record_date = Column(DateTime, default=datetime.utcnow)
    diagnosis = Column(Text)
    treatment = Column(Text)

    patient = relationship("User", back_populates="medical_records")
