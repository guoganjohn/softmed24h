# PIX Payment System Development - Phase 2: Frontend Integration (Initial)

This phase focuses on integrating the PIX payment option into the frontend of the application.

## Steps:

1.  **Payment Screen UI Update (Frontend):**
    *   In `softmed24h/lib/src/screens/payment/payment_screen.dart`, add a new payment method option for PIX (e.g., a radio button or a tab).
    *   When PIX is selected, display a placeholder for the QR code and initial instructions.

2.  **Generate & Display PIX QR Code (Frontend):**
    *   When the user selects PIX and proceeds to payment, call the backend endpoint to create a PIX charge.
    *   Receive the `pix_qr_code_data` from the backend.
    *   Display the QR code to the user. This can be:
        *   An image generated from the `pix_qr_code_data` (requires a QR code generation library on the frontend or backend).
        *   A copy-pasteable string for manual entry.