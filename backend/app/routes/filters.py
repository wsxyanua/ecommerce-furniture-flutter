from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.filter import FilterConfig

router = APIRouter()

@router.get('/')
def get_filter(db: Session = Depends(get_db)):
    # return first config
    cfg = db.query(FilterConfig).first()
    return cfg.to_dict() if cfg else {}
