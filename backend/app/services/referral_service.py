import secrets
import string

from sqlalchemy.orm import Session

from app.models.user import User as UserModel

def generate_unique_referral_code(db: Session) -> str:
    while True:
        referral_code = ''.join(secrets.choice(string.ascii_uppercase + string.digits) for i in range(8))
        if not db.query(UserModel).filter(UserModel.referral_code == referral_code).first():
            return referral_code