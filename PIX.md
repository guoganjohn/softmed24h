# PIX Payment System Development

This document outlines the plan to integrate a PIX payment system into the `softmed24h` application.

## Overview

PIX is an instant payment platform created by the Central Bank of Brazil. Integrating PIX will provide users with a fast and secure payment option.

## Requirements

- Generate PIX QR codes for payments.
- Handle PIX payment callbacks/webhooks to update order status.
- Display PIX payment status to the user.
- Integrate with a PIX API provider (e.g., a bank API or a payment gateway).

## Technical Design

### Backend (Python/FastAPI)

1.  **PIX API Integration:**
    -   Choose a PIX API provider (e.g., a bank's API or a payment gateway like PagSeguro, Mercado Pago, Stone).
    -   Implement a service layer to interact with the chosen PIX API.
    -   Endpoints for:
        -   Creating a PIX charge (generating QR code data).
        -   Querying PIX payment status.
        -   Receiving PIX webhooks (callbacks for payment confirmation).

2.  **Database Schema Updates:**
    -   Add fields to the `Payment` or `Order` model to store PIX-specific information (e.g., `pix_transaction_id`, `pix_qr_code_data`, `pix_status`).

3.  **Webhook Handling:**
    -   Create a dedicated endpoint to receive POST requests from the PIX provider's webhook.
    -   Validate webhook signatures/payloads for security.
    -   Update the corresponding order/payment status in the database based on the webhook data.

### Frontend (Flutter)

1.  **Payment Screen Updates:**
    -   Add a new payment method option for PIX.
    -   When PIX is selected:
        -   Display the generated PIX QR code (image or copy-pasteable string).
        -   Provide instructions for the user to complete the payment.
        -   Implement a mechanism to poll the backend for payment status updates or listen for real-time updates (e.g., WebSockets if implemented).

2.  **Order Status Display:**
    -   Update the order history/details screen to show the PIX payment status (e.g., "Pending", "Paid", "Expired").

## API Provider Selection: Pagar.me

Pagar.me has been selected as the PIX API provider.

Considerations for choosing a PIX API provider:

-   **Cost:** Transaction fees.
-   **Ease of Integration:** SDKs, clear documentation.
-   **Features:** Webhook support, refund capabilities.
-   **Reliability:** Uptime, support.

## Development Steps

1.  **Research PIX API Providers:** Identify and select the best provider for our needs.
2.  **Backend Implementation:**
    -   Implement PIX service. (Completed)
    -   Update database models. (Completed)
    -   Create PIX charge endpoint.
    -   Implement webhook handler.
3.  **Frontend Implementation:**
    -   Update payment screen UI.
    -   Integrate PIX QR code display.
    -   Implement payment status polling/real-time updates.
4.  **Testing:**
    -   Unit tests for backend services.
    -   Integration tests for end-to-end payment flow.
    -   Manual testing with sandbox environments.

## Open Questions

-   What is the exact flow for handling expired PIX payments?
-   Do we need to support refunds via PIX?
