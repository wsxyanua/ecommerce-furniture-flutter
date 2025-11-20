from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db import get_db
from app.dependencies import get_current_user
from app.models.favorite import Favorite

router = APIRouter()


@router.get('/')
def list_fav(db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    items = db.query(Favorite).filter(Favorite.user_id == current_user.id).all()
    return [i.to_dict() for i in items]


@router.post('/')
def add_fav(payload: dict, db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    fav = Favorite(
        user_id=current_user.id,
        product_id=payload.get('product_id'),
        name=payload.get('name'),
        img=payload.get('img'),
        price=payload.get('price'),
    )
    db.add(fav)
    db.commit()
    db.refresh(fav)
    return fav.to_dict()


@router.delete('/{fav_id}')
def delete_fav(fav_id: int, db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    f = db.query(Favorite).filter(Favorite.id == fav_id, Favorite.user_id == current_user.id).first()
    if not f:
        raise HTTPException(status_code=404, detail='Favorite not found')
    db.delete(f)
    db.commit()
    return {'deleted': True}
