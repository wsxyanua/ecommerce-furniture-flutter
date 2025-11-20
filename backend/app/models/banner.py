from sqlalchemy import Column, String, Text, DateTime
from app.db import Base
import datetime

class Banner(Base):
    __tablename__ = 'banners'

    id = Column(String(128), primary_key=True, index=True)
    img = Column(Text, nullable=True)
    date_start = Column(String(50), nullable=True)
    date_end = Column(String(50), nullable=True)
    status = Column(String(50), nullable=True)
    product = Column(Text, nullable=True)  # JSON list string
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'img': self.img,
            'date_start': self.date_start,
            'date_end': self.date_end,
            'status': self.status,
            'product': [] if not self.product else self.product.split(',')
        }
