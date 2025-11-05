import os
from fastapi import FastAPI, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from app.routers import appointments, auth, queue, medical_records, prescriptions, reports, payments, users, transactions
from app.database import engine
from app.models import user, appointment, medical_record, prescription
from fastapi.responses import RedirectResponse, HTMLResponse
from google_auth_oauthlib.flow import Flow
from google.auth.transport.requests import Request as GoogleAuthRequest
from dotenv import load_dotenv
# user.Base.metadata.create_all(bind=engine) # NOTE: In a production environment, consider using Alembic for database migrations.

app = FastAPI()

# Configure CORS
origins = [
    "*"  # Allow all origins for development. Restrict this in production!
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(appointments.router)
app.include_router(queue.router)
app.include_router(medical_records.router)
app.include_router(prescriptions.router)
app.include_router(reports.router)
app.include_router(payments.router, prefix="/payments")
app.include_router(users.router)
app.include_router(transactions.router)

# Load environment variables from .env file
load_dotenv()

# --- Configuration ---
# You would use a database/cache in a real application to store state/tokens
STATE_STORE = {}
SCOPES = [
    'https://www.googleapis.com/auth/calendar',
    'openid', # Always good practice to include for basic ID
]

# Client Config for the flow object
CLIENT_CONFIG = {
    "web": {
        "client_id": os.getenv("GOOGLE_CLIENT_ID"),
        "client_secret": os.getenv("GOOGLE_CLIENT_SECRET"),
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token"
    }
}
REDIRECT_URI = os.getenv("GOOGLE_REDIRECT_URI")

@app.get("/")
def home():
    """Simple home page to start the OAuth flow."""
    return HTMLResponse(
        """
        <h1>Welcome to SoftMed24h Backend</h1>
        <p>Click the button below to see API documentation.</p>
        <a href="/docs">
            <button>Documentation</button>
        </a>
        """
    )

## 1. Initiation Endpoint: /login/google
@app.get("/login/google")
def google_login_init():
    """
    Step 1: Redirects the user to Google for consent.
    """
    flow = Flow.from_client_config(
        CLIENT_CONFIG,
        scopes=SCOPES,
        redirect_uri=REDIRECT_URI
    )

    # access_type='offline' ensures we get a Refresh Token
    # prompt='consent' ensures the consent screen is shown
    authorization_url, state = flow.authorization_url(
        access_type='offline',
        prompt='consent'
    )

    # In a real app, 'state' would be stored in a secure cookie or database
    # and tied to the user's session ID for CSRF protection.
    STATE_STORE[state] = True
    print(f"Stored state: {state}")

    return RedirectResponse(authorization_url)


## 2. Callback Endpoint: /api/google/callback
@app.get("/api/google/callback")
async def google_auth_callback(request: Request):
    """
    Step 2-5: Handles the redirect, exchanges the code for tokens, and stores them.
    """
    # Create the flow object from the redirect URI containing the 'code'
    flow = Flow.from_client_config(
        CLIENT_CONFIG,
        scopes=SCOPES,
        redirect_uri=REDIRECT_URI
    )

    # 1. State Validation (Security Check)
    state = request.query_params.get("state")
    if not state or state not in STATE_STORE:
        raise HTTPException(status_code=400, detail="Invalid or missing state parameter. CSRF attempt detected.")

    # Remove state after use
    del STATE_STORE[state]

    try:
        # 2. Exchange the authorization code for tokens (Server-to-Server request)
        authorization_response = str(request.url)
        flow.fetch_token(authorization_response=authorization_response)

        credentials = flow.credentials

        # --- TOKEN STORAGE AND USAGE ---
        # **This is where you get your tokens.**

        # Access Token (GOOGLE_OAUTH_TOKEN) - Use for API calls
        access_token = credentials.token

        # Refresh Token - Store securely and use for subsequent token refreshes
        refresh_token = credentials.refresh_token

        # Save both tokens securely associated with the user in your database
        # For demonstration, we'll just print and show them:

        return {
            "message": "Authentication Successful!",
            "access_token": access_token,
            "refresh_token": refresh_token,
            "expiry": credentials.expiry.isoformat()
        }

    except Exception as e:
        print(f"Token exchange error: {e}")
        raise HTTPException(status_code=500, detail="Failed to retrieve or exchange tokens.")
