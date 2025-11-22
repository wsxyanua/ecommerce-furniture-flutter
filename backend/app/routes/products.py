from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.product import Product

router = APIRouter()


@router.get("/")
def list_products(
    skip: int = 0,
    limit: int = 20,
    name: str = None,
    category_id: str = None,
    min_price: float = None,
    max_price: float = None,
    sort_by: str = "timestamp",
    order: str = "desc",
    db: Session = Depends(get_db)
):
    query = db.query(Product)
    
    # Apply filters
    if name:
        query = query.filter(Product.name.ilike(f'%{name}%'))
    
    if category_id:
        query = query.filter(Product.category_id == category_id)
    
    if min_price is not None:
        query = query.filter(Product.current_price >= min_price)
    
    if max_price is not None:
        query = query.filter(Product.current_price <= max_price)
    
    # Apply sorting
    sort_column = Product.timestamp
    if sort_by == "price":
        sort_column = Product.current_price
    elif sort_by == "name":
        sort_column = Product.name
    elif sort_by == "review":
        sort_column = Product.review_avg
    elif sort_by == "sell_count":
        sort_column = Product.sell_count
    
    if order.lower() == "asc":
        query = query.order_by(sort_column.asc())
    else:
        query = query.order_by(sort_column.desc())
    
    # Pagination
    items = query.offset(skip).limit(limit).all()
    return [p.to_dict() for p in items]


@router.get("/{product_id}")
def get_product(product_id: str, db: Session = Depends(get_db)):
    p = db.query(Product).filter(Product.id == product_id).first()
    if not p:
        raise HTTPException(status_code=404, detail="Product not found")
    return p.to_dict()


@router.get("/special/new-arrivals")
def get_new_arrivals(limit: int = 10, db: Session = Depends(get_db)):
    items = db.query(Product).order_by(Product.timestamp.desc()).limit(limit).all()
    return [p.to_dict() for p in items]


@router.get("/special/top-seller")
def get_top_seller(limit: int = 10, db: Session = Depends(get_db)):
    items = db.query(Product).order_by(Product.sell_count.desc()).limit(limit).all()
    return [p.to_dict() for p in items]


@router.get("/special/best-review")
def get_best_review(limit: int = 10, db: Session = Depends(get_db)):
    items = db.query(Product).filter(Product.review_avg > 0).order_by(Product.review_avg.desc()).limit(limit).all()
    return [p.to_dict() for p in items]


@router.get("/special/discount")
def get_discount(limit: int = 20, db: Session = Depends(get_db)):
    items = db.query(Product).filter(
        Product.current_price < Product.root_price
    ).order_by((Product.root_price - Product.current_price).desc()).limit(limit).all()
    return [p.to_dict() for p in items]
