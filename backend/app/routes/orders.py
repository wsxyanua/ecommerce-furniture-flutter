from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db import get_db
from app.dependencies import get_current_user
from app.models.order import Order, OrderItem
import uuid

router = APIRouter()


@router.post('/')
def create_order(payload: dict, db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    order_id = str(uuid.uuid4())
    order = Order(
        id=order_id,
        id_user=current_user.id,
        full_name=payload.get('full_name'),
        address=payload.get('address'),
        city=payload.get('city'),
        country=payload.get('country'),
        phone=payload.get('phone'),
        payment_method=payload.get('payment_method'),
        status_order='CHECKING',
        status_payment=payload.get('status_payment', 'PENDING'),
        sub_total=payload.get('sub_total', 0.0),
        total_order=payload.get('total_order', 0.0),
        vat=payload.get('vat', 0.0),
        delivery_fee=payload.get('delivery_fee', 0.0),
        note=payload.get('note'),
    )
    db.add(order)
    items = payload.get('items', [])
    for it in items:
        oi = OrderItem(
            order_id=order_id,
            product_id=it.get('product_id'),
            name=it.get('name'),
            img=it.get('img'),
            quantity=it.get('quantity', 1),
            price=it.get('price', 0.0),
        )
        db.add(oi)
    db.commit()
    return {'order_id': order_id}


@router.get('/')
def list_orders(db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    list_o = db.query(Order).filter(Order.id_user == current_user.id).all()
    out = []
    for o in list_o:
        items = db.query(OrderItem).filter(OrderItem.order_id == o.id).all()
        out.append({
            'order': {
                'id': o.id,
                'status_order': o.status_order,
                'date_order': o.date_order.isoformat() if o.date_order else None,
                'total_order': o.total_order,
            },
            'items': [ { 'id': it.id, 'product_id': it.product_id, 'name': it.name, 'quantity': it.quantity, 'price': it.price } for it in items]
        })
    return out
