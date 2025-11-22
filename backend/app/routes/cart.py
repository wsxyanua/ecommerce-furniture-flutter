from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db import get_db
from app.dependencies import get_current_user
from app.models.cart import CartItem

router = APIRouter()


@router.get('/')
def list_cart(db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    items = db.query(CartItem).filter(CartItem.user_id == current_user.id).all()
    return [i.to_dict() for i in items]


@router.post('/')
def add_cart(item: dict, db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    ci = CartItem(
        user_id=current_user.id,
        product_id=item.get('product_id'),
        name=item.get('name'),
        img=item.get('img'),
        color=item.get('color'),
        quantity=item.get('quantity', 1),
        price=item.get('price', 0.0),
    )
    db.add(ci)
    db.commit()
    db.refresh(ci)
    return ci.to_dict()


@router.delete('/{item_id}')
def delete_cart(item_id: int, db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    ci = db.query(CartItem).filter(CartItem.id == item_id, CartItem.user_id == current_user.id).first()
    if not ci:
        raise HTTPException(status_code=404, detail='Cart item not found')
    db.delete(ci)
    db.commit()
    return {'deleted': True}


@router.patch('/{item_id}')
def update_cart(item_id: int, update_data: dict, db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    ci = db.query(CartItem).filter(CartItem.id == item_id, CartItem.user_id == current_user.id).first()
    if not ci:
        raise HTTPException(status_code=404, detail='Cart item not found')
    
    if 'quantity' in update_data:
        ci.quantity = update_data['quantity']
    if 'color' in update_data:
        ci.color = update_data['color']
    
    db.commit()
    db.refresh(ci)
    return ci.to_dict()
