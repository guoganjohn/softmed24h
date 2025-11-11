from pydantic import BaseModel
from app.schemas.user import UserMeResponse

class TokenResponse(BaseModel):
    access_token: str
    token_type: str
    user: UserMeResponse
