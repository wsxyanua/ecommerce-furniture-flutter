from sqlalchemy import Column, Integer, String, Float, Text, ForeignKey
from app.db import Base

class CartItem(Base):
    __tablename__ = 'cart_items'

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(128), ForeignKey('users.id'), nullable=False)
    product_id = Column(String(128), nullable=False)
    name = Column(String(255), nullable=True)
    img = Column(Text, nullable=True)
    color = Column(String(100), nullable=True)
    quantity = Column(Integer, nullable=False, default=1)
    price = Column(Float, nullable=False, default=0.0)

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'product_id': self.product_id,
            'name': self.name,
            'img': self.img,
            'color': self.color,
            'quantity': self.quantity,
            'price': self.price,
        }
