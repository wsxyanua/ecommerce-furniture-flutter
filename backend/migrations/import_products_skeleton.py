"""Skeleton import script: read JSON exported from Firestore and insert into MySQL.
This is a template — you must adapt field names to your exported JSON structure.
"""
import json
from sqlalchemy.orm import Session
from app.db import SessionLocal
from app.models.product import Product


def import_products(json_path: str):
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    db: Session = SessionLocal()
    try:
        for doc in data:
            # adapt keys according to export
            p = Product(
                id=doc.get('id'),
                name=doc.get('name'),
                title=doc.get('title'),
                img=doc.get('img'),
                description=doc.get('description'),
                root_price=float(doc.get('rootPrice', 0)),
                current_price=float(doc.get('currentPrice', 0)),
                category_id=doc.get('categoryItemId'),
                status=doc.get('status'),
                material=doc.get('material'),
                size=doc.get('size'),
                review_avg=float(doc.get('review', 0)),
                sell_count=int(doc.get('sellest', 0)),
            )
            db.merge(p)  # upsert-ish
        db.commit()
    finally:
        db.close()


if __name__ == '__main__':
    import_products('exported_products.json')
