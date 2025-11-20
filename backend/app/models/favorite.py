from sqlalchemy import Column, Integer, String, Text, ForeignKey
from app.db import Base

class Favorite(Base):
    __tablename__ = 'favorites'

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(128), ForeignKey('users.id'), nullable=False)
    product_id = Column(String(128), nullable=False)
    name = Column(String(255), nullable=True)
    img = Column(Text, nullable=True)
    price = Column(String(64), nullable=True)

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'product_id': self.product_id,
            'name': self.name,
            'img': self.img,
            'price': self.price,
        }
