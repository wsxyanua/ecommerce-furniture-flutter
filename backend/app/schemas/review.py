from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime


class ReviewCreate(BaseModel):
    product_id: str = Field(..., min_length=1, max_length=128)
    order_id: Optional[str] = Field(None, max_length=128)
    star: float = Field(..., ge=1.0, le=5.0)
    message: Optional[str] = None
    img: Optional[List[str]] = []
    service: Optional[dict] = {}


class ReviewUpdate(BaseModel):
    star: Optional[float] = Field(None, ge=1.0, le=5.0)
    message: Optional[str] = None
    img: Optional[List[str]] = None
    service: Optional[dict] = None


class ReviewResponse(BaseModel):
    id: str
    product_id: str
    user_id: str
    idUser: str  # Flutter compatibility
    order_id: Optional[str]
    idOrder: Optional[str]  # Flutter compatibility
    star: float
    message: Optional[str]
    img: Optional[str]  # JSON string
    service: Optional[str]  # JSON string
    timestamp: Optional[str]
    date: Optional[str]  # Flutter compatibility
    
    class Config:
        from_attributes = True
