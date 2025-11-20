from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.user import User
from app.schemas.user import UserCreate, Token
from app.core.security import get_password_hash, verify_password, create_access_token
import uuid

router = APIRouter()


@router.post('/register', response_model=Token)
def register(payload: UserCreate, db: Session = Depends(get_db)):
    # Check existing email or phone
    if payload.email:
        existing = db.query(User).filter(User.email == payload.email).first()
        if existing:
            raise HTTPException(status_code=400, detail='Email already registered')
    if payload.phone:
        existing2 = db.query(User).filter(User.phone == payload.phone).first()
        if existing2:
            raise HTTPException(status_code=400, detail='Phone already registered')

    user = User(
        id=str(uuid.uuid4()),
        email=payload.email,
        phone=payload.phone,
        full_name=payload.full_name,
        password_hash=get_password_hash(payload.password),
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    token = create_access_token({'sub': user.id})
    return {'access_token': token, 'token_type': 'bearer'}


@router.post('/login', response_model=Token)
def login(payload: UserCreate, db: Session = Depends(get_db)):
    # allow login by email or phone
    user = None
    if payload.email:
        user = db.query(User).filter(User.email == payload.email).first()
    elif payload.phone:
        user = db.query(User).filter(User.phone == payload.phone).first()
    if not user:
        raise HTTPException(status_code=401, detail='Invalid credentials')
    if not verify_password(payload.password, user.password_hash or ''):
        raise HTTPException(status_code=401, detail='Invalid credentials')

    token = create_access_token({'sub': user.id})
    return {'access_token': token, 'token_type': 'bearer'}
