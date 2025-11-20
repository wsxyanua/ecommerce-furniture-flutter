from sqlalchemy import Column, String, Float, Integer, Text, DateTime
from sqlalchemy import JSON as SA_JSON
from app.db import Base
import datetime


class Product(Base):
    __tablename__ = "products"

    id = Column(String(128), primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    title = Column(String(255), nullable=True)
    img = Column(Text, nullable=True)
    description = Column(Text, nullable=True)
    root_price = Column(Float, nullable=False, default=0)
    current_price = Column(Float, nullable=False, default=0)
    category_id = Column(String(128), nullable=True)
    status = Column(String(64), nullable=True)
    material = Column(SA_JSON, nullable=True)
    size = Column(SA_JSON, nullable=True)
    review_avg = Column(Float, default=0)
    sell_count = Column(Integer, default=0)
    timestamp = Column(DateTime, default=datetime.datetime.utcnow)

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "title": self.title,
            "img": self.img,
            "description": self.description,
            "root_price": self.root_price,
            "current_price": self.current_price,
            "category_id": self.category_id,
            "status": self.status,
            "material": self.material,
            "size": self.size,
            "review_avg": self.review_avg,
            "sell_count": self.sell_count,
            "timestamp": self.timestamp.isoformat() if self.timestamp else None,
        }
