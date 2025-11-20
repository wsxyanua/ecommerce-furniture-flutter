from sqlalchemy import Column, String, Text, ForeignKey
from sqlalchemy.orm import relationship
from app.db import Base

class Category(Base):
    __tablename__ = 'categories'

    id = Column(String(128), primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    img = Column(Text, nullable=True)
    status = Column(String(50), nullable=True)
    items = relationship('CategoryItem', backref='category', cascade='all, delete-orphan')

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'img': self.img,
            'status': self.status,
            'items': [i.to_dict() for i in self.items]
        }

class CategoryItem(Base):
    __tablename__ = 'category_items'

    id = Column(String(128), primary_key=True, index=True)
    category_id = Column(String(128), ForeignKey('categories.id'), nullable=False)
    name = Column(String(255), nullable=False)
    img = Column(Text, nullable=True)
    status = Column(String(50), nullable=True)

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'img': self.img,
            'status': self.status,
        }
