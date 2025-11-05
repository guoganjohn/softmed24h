# PIX Payment System Development - Phase 1: Backend Foundation & PIX Provider Selection

This phase focuses on setting up the backend infrastructure for PIX payments and selecting a suitable PIX API provider.

## Steps:

1.  **Research PIX API Providers:**
    *   **Decision:** Pagar.me has been selected as the PIX API provider.
    *   Identify potential PIX API providers (e.g., PagSeguro, Mercado Pago, Stone, or direct bank APIs).
    *   Evaluate providers based on cost, ease of integration (SDKs, documentation), features (webhooks, refunds), and reliability.

2.  **Database Schema Updates (Backend): (Completed)**
    *   Modified the `Payment` or `Order` model in the backend (Python/FastAPI) to include fields for PIX-specific information:
        *   `pix_transaction_id` (string)
        *   `pix_qr_code_data` (string - for the raw QR code payload)
        *   `pix_status` (string - e.g., "pending", "paid", "expired")

3.  **Basic PIX Service Implementation (Backend): (Completed)**
    *   Created a new service layer (e.g., `pix_service.py`) to encapsulate interactions with the chosen PIX API.
    *   Implemented a function to create a PIX charge, which will call the external PIX API and return the QR code data and transaction ID. (Initially, this can be a mock implementation if the API provider is not fully integrated yet).