from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models.category import Category, CategoryItem

router = APIRouter()

@router.get('/')
def list_categories(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    cats = db.query(Category).offset(skip).limit(limit).all()
    result = []
    for c in cats:
        items = db.query(CategoryItem).filter(
            CategoryItem.category_id == c.id
        ).all()
        cat_dict = c.to_dict()
        cat_dict['items'] = [i.to_dict() for i in items]
        result.append(cat_dict)
    return result


@router.get('/{category_id}')
def get_category(category_id: str, db: Session = Depends(get_db)):
    cat = db.query(Category).filter(Category.id == category_id).first()
    if not cat:
        return {'error': 'Category not found'}
    
    items = db.query(CategoryItem).filter(
        CategoryItem.category_id == category_id
    ).all()
    
    cat_dict = cat.to_dict()
    cat_dict['items'] = [i.to_dict() for i in items]
    return cat_dict
