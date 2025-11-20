from pydantic import BaseModel, EmailStr
from typing import Optional

class UserCreate(BaseModel):
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    full_name: Optional[str] = None
    password: str

class UserRead(BaseModel):
    id: str
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    full_name: Optional[str] = None
    address: Optional[str] = None
    img: Optional[str] = None
    birth_date: Optional[str] = None
    date_enter: Optional[str] = None
    status: Optional[str] = None
    gender: Optional[str] = None

    model_config = {
        'from_attributes': True
    }

class UserUpdate(BaseModel):
    full_name: Optional[str] = None
    address: Optional[str] = None
    img: Optional[str] = None
    birth_date: Optional[str] = None
    gender: Optional[str] = None

class Token(BaseModel):
    access_token: str
    token_type: str = 'bearer'

class TokenData(BaseModel):
    id: Optional[str] = None
