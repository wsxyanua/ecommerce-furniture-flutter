from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.category import Category

router = APIRouter()

@router.get('/')
def list_categories(db: Session = Depends(get_db)):
    items = db.query(Category).all()
    return [c.to_dict() for c in items]
