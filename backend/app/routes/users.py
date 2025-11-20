from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db import get_db
from app.dependencies import get_current_user
from app.schemas.user import UserRead, UserUpdate

router = APIRouter()


@router.get('/me', response_model=UserRead)
def me(current_user = Depends(get_current_user)):
    return current_user.to_dict()


@router.put('/me', response_model=UserRead)
def update_me(payload: UserUpdate, db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    user = db.query(current_user.__class__).filter(current_user.__class__.id == current_user.id).first()
    if not user:
        raise HTTPException(status_code=404, detail='User not found')
    for k, v in payload.model_dump(exclude_unset=True).items():
        setattr(user, k, v)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user.to_dict()
