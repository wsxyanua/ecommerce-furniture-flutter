from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.product import Product

router = APIRouter()


@router.get("/")
def list_products(skip: int = 0, limit: int = 20, db: Session = Depends(get_db)):
    items = db.query(Product).offset(skip).limit(limit).all()
    return [p.to_dict() for p in items]


@router.get("/{product_id}")
def get_product(product_id: str, db: Session = Depends(get_db)):
    p = db.query(Product).filter(Product.id == product_id).first()
    if not p:
        raise HTTPException(status_code=404, detail="Product not found")
    return p.to_dict()
