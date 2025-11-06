from datetime import datetime  # Import datetime

from fastapi import APIRouter, Depends, HTTPException, status
from jose import JWTError, jwt  # Import jwt and JWTError
from passlib.context import CryptContext
from sqlalchemy.orm import Session

from app.database import SessionLocal
from app.models.payment import Payment as PaymentModel  # Import Payment model
from app.models.user import \
    User as UserModel  # Explicitly import and alias User as UserModel
from app.routers.auth import SECRET_KEY  # Import verify_password
from app.routers.auth import ALGORITHM, oauth2_scheme, verify_password
from app.schemas import password as password_schema
from app.schemas import user as user_schema

router = APIRouter()

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def get_password_hash(password: str) -> str:
    """
    Hashes the password after ensuring it does not exceed the 72-character limit for bcrypt.
    """
    # Truncate the string to 72 characters if it's longer
    if len(password) > 72:
        password = password[:72]
    return pwd_context.hash(password)


# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_user_by_email(db: Session, email: str):
    return db.query(UserModel).filter(UserModel.email == email).first()


# Dependency to get the current user from the JWT token
async def get_current_user(
    token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)
) -> UserModel:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    user = get_user_by_email(db, email=email)
    if user is None:
        raise credentials_exception
    return user


@router.get("/me", response_model=user_schema.UserMeResponse)
def read_users_me(
    current_user: UserModel = Depends(get_current_user), db: Session = Depends(get_db)
):
    """
    Get the current logged-in user's information, including active payment status and phone number.
    """
    active_payment = (
        db.query(PaymentModel)
        .filter(
            PaymentModel.user_id == current_user.id,
            PaymentModel.end_date > datetime.utcnow(),
        )
        .first()
    )
    has_active_payment = active_payment is not None

    return {
        "name": current_user.name,
        "email": current_user.email,
        "id": current_user.id,
        "is_active": current_user.is_active,
        "phone": current_user.phone,
        "cpf": current_user.cpf,
        "has_active_payment": has_active_payment,
    }


@router.post("/", response_model=user_schema.User)
def create_user(user: user_schema.UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(UserModel).filter(UserModel.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed_password = get_password_hash(user.password)
    db_user = UserModel(
        email=user.email,
        hashed_password=hashed_password,
        name=user.name,
        gender=user.gender,
        cpf=user.cpf,
        phone=user.phone,
        birthday=user.birthday,
        cep=user.cep,
        logradouro=user.logradouro,
        numero=user.numero,
        complemento=user.complemento,
        bairro=user.bairro,
        estado=user.estado,
        cidade=user.cidade,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


@router.put("/me/password", status_code=status.HTTP_204_NO_CONTENT)
def update_password(
    password_update: password_schema.PasswordUpdate,
    current_user: UserModel = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if not verify_password(
        password_update.current_password, current_user.hashed_password
    ):
        raise HTTPException(status_code=400, detail="Incorrect current password")
    if password_update.new_password != password_update.confirm_password:
        raise HTTPException(status_code=400, detail="New passwords do not match")

    current_user.hashed_password = get_password_hash(password_update.new_password)
    db.add(current_user)
    db.commit()
