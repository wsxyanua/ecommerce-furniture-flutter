from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.banner import Banner

router = APIRouter()

@router.get('/')
def list_banners(skip: int = 0, limit: int = 50, status: str = None, db: Session = Depends(get_db)):
    query = db.query(Banner)
    
    if status:
        query = query.filter(Banner.status == status)
    
    items = query.offset(skip).limit(limit).all()
    return [b.to_dict() for b in items]


@router.get('/{banner_id}')
def get_banner(banner_id: str, db: Session = Depends(get_db)):
    banner = db.query(Banner).filter(Banner.id == banner_id).first()
    if not banner:
        return {'error': 'Banner not found'}
    return banner.to_dict()
