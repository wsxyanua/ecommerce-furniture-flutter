from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.banner import Banner

router = APIRouter()

@router.get('/')
def list_banners(db: Session = Depends(get_db)):
    items = db.query(Banner).all()
    return [b.to_dict() for b in items]
