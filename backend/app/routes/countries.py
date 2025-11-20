from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.country import Country

router = APIRouter()

@router.get('/')
def list_countries(db: Session = Depends(get_db)):
    items = db.query(Country).all()
    return [c.to_dict() for c in items]
