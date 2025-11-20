from sqlalchemy import Column, String, Text
from app.db import Base

class Country(Base):
    __tablename__ = 'countries'

    id = Column(String(128), primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    city = Column(Text, nullable=True)  # JSON list

    def to_dict(self):
        import json
        cities = []
        if self.city:
            try:
                cities = json.loads(self.city)
            except:
                cities = []
        return {
            'id': self.id,
            'name': self.name,
            'city': cities,
        }
