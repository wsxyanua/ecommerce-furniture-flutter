from sqlalchemy import Column, String, Float, Text, DateTime, ForeignKey
from app.db import Base
import datetime


class Review(Base):
    __tablename__ = "reviews"

    id = Column(String(128), primary_key=True, index=True)
    product_id = Column(String(128), ForeignKey('products.id', ondelete='CASCADE'), nullable=False, index=True)
    user_id = Column(String(128), ForeignKey('users.id', ondelete='CASCADE'), nullable=False, index=True)
    order_id = Column(String(128), nullable=True)
    star = Column(Float, nullable=False)
    message = Column(Text, nullable=True)
    img = Column(Text, nullable=True)  # JSON array as string
    service = Column(Text, nullable=True)  # JSON object as string
    created_at = Column(DateTime, default=datetime.datetime.utcnow, nullable=False)

    def to_dict(self):
        return {
            "id": self.id,
            "product_id": self.product_id,
            "user_id": self.user_id,
            "idUser": self.user_id,  # Flutter compatibility
            "order_id": self.order_id,
            "idOrder": self.order_id,  # Flutter compatibility
            "star": self.star,
            "message": self.message,
            "img": self.img,
            "service": self.service,
            "timestamp": self.created_at.isoformat() if self.created_at else None,
            "date": self.created_at.isoformat() if self.created_at else None,
        }
