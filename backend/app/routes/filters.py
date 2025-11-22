from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.filter import FilterConfig

router = APIRouter()

@router.get('/')
def list_filters(skip: int = 0, limit: int = 10, category: str = None, db: Session = Depends(get_db)):
    query = db.query(FilterConfig)
    
    if category:
        query = query.filter(FilterConfig.category == category)
    
    items = query.offset(skip).limit(limit).all()
    
    # Return first if exists for backward compatibility
    if items:
        return items[0].to_dict()
    return {}


@router.get('/all')
def list_all_filters(skip: int = 0, limit: int = 10, category: str = None, db: Session = Depends(get_db)):
    query = db.query(FilterConfig)
    
    if category:
        query = query.filter(FilterConfig.category == category)
    
    items = query.offset(skip).limit(limit).all()
    return [f.to_dict() for f in items]
