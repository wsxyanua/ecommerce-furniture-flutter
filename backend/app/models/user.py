from sqlalchemy import Column, String, DateTime, Text
from sqlalchemy import Integer
from app.db import Base
import datetime

class User(Base):
    __tablename__ = 'users'

    id = Column(String(128), primary_key=True, index=True)
    email = Column(String(255), unique=True, nullable=True, index=True)
    phone = Column(String(50), unique=True, nullable=True)
    full_name = Column(String(255), nullable=True)
    address = Column(Text, nullable=True)
    img = Column(Text, nullable=True)
    birth_date = Column(String(50), nullable=True)
    date_enter = Column(String(50), nullable=True)
    status = Column(String(50), nullable=True)
    gender = Column(String(20), nullable=True)
    password_hash = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'email': self.email,
            'phone': self.phone,
            'full_name': self.full_name,
            'address': self.address,
            'img': self.img,
            'birth_date': self.birth_date,
            'date_enter': self.date_enter,
            'status': self.status,
            'gender': self.gender,
            'created_at': self.created_at.isoformat() if self.created_at else None,
        }
