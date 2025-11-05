import os
from datetime import datetime
from typing import List

from dotenv import load_dotenv
from google.auth.transport.requests import \
    Request as GoogleAuthRequest  # Needed for token refresh
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build

load_dotenv()


class GoogleMeetService:
    def __init__(self):
        google_oauth_token = os.getenv("GOOGLE_OAUTH_TOKEN")
        google_refresh_token = os.getenv("GOOGLE_REFRESH_TOKEN")
        google_client_id = os.getenv("GOOGLE_CLIENT_ID")
        google_client_secret = os.getenv("GOOGLE_CLIENT_SECRET")

        # --- Check Credentials ---
        if not all(
            [
                google_oauth_token,
                google_refresh_token,
                google_client_id,
                google_client_secret,
            ]
        ):
            raise Exception("Missing Google API credentials in environment variables.")

        # --- Corrected Scope ---
        # The broader Calendar scope is more reliable for Meet creation
        SCOPES = ["https://www.googleapis.com/auth/calendar"]

        # --- Initialize Credentials ---
        # The from_authorized_user_info method is for credentials received after a full OAuth flow
        self.creds = Credentials(
            token=google_oauth_token,
            refresh_token=google_refresh_token,
            token_uri="https://oauth2.googleapis.com/token",
            client_id=google_client_id,
            client_secret=google_client_secret,
            scopes=SCOPES,
            # Set a high expiry time, as the token refresh logic below will handle it
            expiry=datetime.now(),  # Start with an expired token to force immediate refresh
        )

        # --- Force Token Refresh and Build Service ---
        # Crucial: This attempts to refresh the token using the refresh_token
        # if the access token is near expiration or invalid.
        if self.creds.expired and self.creds.refresh_token:
            self.creds.refresh(GoogleAuthRequest())

        # Build the Google Calendar service object
        self.service = build("calendar", "v3", credentials=self.creds)

    def create_meeting(
        self,
        summary: str,
        start_time: datetime,
        end_time: datetime,
        attendees: List[str],
    ):
        # This function attempts to refresh the token again just before the call,
        # providing an extra layer of protection against expiration.
        if self.creds.expired and self.creds.refresh_token:
            self.creds.refresh(GoogleAuthRequest())

        event = {
            "summary": summary,
            "start": {
                "dateTime": start_time.isoformat(),
                "timeZone": "America/Sao_Paulo",
            },
            "end": {
                "dateTime": end_time.isoformat(),
                "timeZone": "America/Sao_Paulo",
            },
            "attendees": [{"email": email} for email in attendees],
            "conferenceData": {
                # This key is required to instruct Google to create a Meet conference
                "createRequest": {
                    "requestId": "fastapi-meet-request-"
                    + str(int(datetime.now().timestamp())),
                    "conferenceSolutionKey": {"type": "hangoutsMeet"},
                }
            },
        }

        try:
            # conferenceDataVersion=1 is MANDATORY for 'conferenceData' to be processed
            event = (
                self.service.events()
                .insert(
                    calendarId="primary",
                    body=event,
                    conferenceDataVersion=1,
                    sendNotifications=True,
                )
                .execute()
            )

            # The meeting link is returned in the 'hangoutLink' field
            return event.get("hangoutLink")

        except Exception as e:
            # This is the proper place to raise an exception for the calling function
            raise Exception(f"Failed to create Google Meet event: {e}")


# Example usage (assuming you define your datetime objects and run this in a main block)
# from datetime import timedelta
# meet_service = GoogleMeetService()
# now = datetime.now()
# link = meet_service.create_meeting("Test FastAPI Meeting", now, now + timedelta(hours=1), ["user@example.com"])
# print(link)
