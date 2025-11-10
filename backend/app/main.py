from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app import models
from app.routers import (
    users,
    appointments,
    auth,
    medical_records,
    payments,
    prescriptions,
    queue,
    reports,
    transactions,
    doctors,
)

app = FastAPI()

# Configure CORS
origins = ["*"]  # Allow all origins for development. Restrict this in production!

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(users.router, prefix="/users", tags=["users"])
app.include_router(appointments.router, prefix="/appointments", tags=["appointments"])
app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(medical_records.router, prefix="/medical_records", tags=["medical_records"])
app.include_router(payments.router, prefix="/payments", tags=["payments"])
app.include_router(prescriptions.router, prefix="/prescriptions", tags=["prescriptions"])
app.include_router(queue.router, prefix="/queue", tags=["queue"])
app.include_router(reports.router, prefix="/reports", tags=["reports"])
app.include_router(transactions.router, prefix="/transactions", tags=["transactions"])
app.include_router(doctors.router, prefix="/doctors", tags=["doctors"])

@app.get("/")
async def root():
    return {"message": "Hello World"}