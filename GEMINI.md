# Gemini Project Notes for softmed24h

## Project Overview

This document outlines key information and modifications made to the `softmed24h` Flutter project, particularly focusing on the backend API integration and the newly introduced API service layer.

## API Service Layer Implementation

### Purpose:

The API service layer was introduced to centralize and standardize communication with the backend REST API, adhering to best practices for separation of concerns, maintainability, and testability.

### Key Components:

*   **`lib/src/data/network/api_client.dart`**: This is the core HTTP client responsible for:
    *   Managing the base URL (`http://localhost:8000`).
    *   Adding common headers (e.g., `Content-Type`, `Authorization`).
    *   Handling generic HTTP request methods (`GET`, `POST`, `PUT`, `DELETE`).
    *   Implementing centralized error handling by mapping HTTP status codes to custom `AppException` types.
    *   Includes a placeholder for secure token retrieval (`_getToken()`).

*   **`lib/src/data/network/app_exceptions.dart`**: Defines custom exception classes (e.g., `FetchDataException`, `UnauthorizedException`) for structured error reporting from the API layer.

*   **`lib/src/data/models/`**: This directory contains all data models used for API requests and responses. Each model is a Dart class annotated with `@JsonSerializable` to enable automatic JSON serialization and deserialization using `json_serializable` and `build_runner`.
    *   **Implemented Models:**
        *   `user.dart` (User, UserCreate, UserMeResponse)
        *   `appointment.dart` (AppointmentBase, AppointmentCreate, Appointment, CreateMeetingRequest)
        *   `medical_record.dart` (MedicalRecordBase, MedicalRecordCreate, MedicalRecord)
        *   `payment.dart` (CreatePaymentIntentRequest, PaymentIntentResponse, CreatePixPaymentRequest, PixPaymentResponse)
        *   `prescription.dart` (PrescriptionBase, PrescriptionCreate, Prescription, CreatePrescriptionRequest)
        *   `queue.dart` (QueueStats)
        *   `report.dart` (ReportResponse)
        *   `transaction.dart` (TransactionBase, TransactionCreate, Transaction, FinancialSummary)

*   **`lib/src/data/services/`**: This directory contains feature-specific API service classes. Each class encapsulates API calls for a particular backend domain (tag).
    *   **Implemented Services:**
        *   `user_api_service.dart` (for user-related operations)
        *   `appointments_api_service.dart` (for appointment-related operations)
        *   `medical_records_api_service.dart` (for medical record-related operations)
        *   `payment_api_service.dart` (for payment-related operations)
        *   `prescriptions_api_service.dart` (for prescription-related operations)
        *   `queue_api_service.dart` (for queue-related operations)
        *   `reports_api_service.dart` (for report-related operations)
        *   `transactions_api_service.dart` (for transaction-related operations)

### Backend API Modifications:

*   **`backend/app/main.py`**: Refactored to include `CORSMiddleware` and to mount routers with appropriate prefixes (e.g., `/users`, `/appointments`).
*   **Backend Routers**: Modified various router files (e.g., `users.py`, `appointments.py`, `medical_records.py`, `queue.py`, `reports.py`, `transactions.py`) to align with RESTful principles by adjusting endpoint paths to be relative to their router prefixes.
*   **SQLAlchemy Circular Dependency Resolution**: Addressed circular import issues between SQLAlchemy models by ensuring all models are imported via `backend/app/models/__init__.py` and using string references in `relationship` definitions.

## Future Considerations:

*   **Token Retrieval**: Implement secure token storage and retrieval in `ApiClient._getToken()`.
*   **AuthApiService**: Create a dedicated API service for authentication-related endpoints (login, forgot password, reset password).
*   **Deprecated UI Elements**: Address deprecated `Radio` widget properties and dead null-aware expressions noted during static analysis.
