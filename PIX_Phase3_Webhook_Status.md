# PIX Payment System Development - Phase 3: Webhook & Status Handling

This phase focuses on implementing webhook handling for PIX payment status updates and displaying these updates to the user.

## Steps:

1.  **PIX Webhook Endpoint (Backend):**
    *   Create a dedicated FastAPI endpoint (e.g., `/api/pix/webhook`) to receive POST requests from the PIX provider's webhook.
    *   Implement basic validation for incoming webhook payloads (e.g., checking for expected fields).
    *   Log the incoming webhook data.

2.  **Update Payment Status from Webhook (Backend):**
    *   Within the webhook handler, parse the PIX provider's notification.
    *   Use the `pix_transaction_id` to find the corresponding payment/order in the database.
    *   Update the `pix_status` field (e.g., to "paid" or "failed").

3.  **Payment Status Polling (Frontend):**
    *   After displaying the PIX QR code, implement a mechanism on the frontend to periodically poll the backend for the payment status of the PIX transaction.
    *   Update the UI to reflect the current `pix_status` (e.g., "Aguardando Pagamento", "Pago", "Expirado").

4.  **Order Status Display (Frontend):**
    *   Update the order history/details screen to clearly show the PIX payment status for past transactions.

5.  **Error Handling & User Feedback (Frontend & Backend):**
    *   Implement robust error handling for all PIX-related API calls.
    *   Provide clear and informative error messages to the user.

6.  **Unit and Integration Tests:**
    *   Write unit tests for the backend PIX service and webhook handler.
    *   Write integration tests to cover the end-to-end PIX payment flow (frontend to backend to PIX provider mock/sandbox and back).
    *   Thoroughly test the PIX payment flow using the PIX provider's sandbox environment.

## Open Questions (to be addressed during development):

*   Confirm the exact flow for handling expired PIX payments (e.g., automatic cancellation, user notification).
*   Determine if refund capabilities via PIX are required for the initial release and plan for their implementation if so.