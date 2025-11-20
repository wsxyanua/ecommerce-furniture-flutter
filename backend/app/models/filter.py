from sqlalchemy import Column, String, Text
from app.db import Base

class FilterConfig(Base):
    __tablename__ = 'filter_configs'

    id = Column(String(128), primary_key=True, index=True)
    price = Column(Text, nullable=True)            # JSON list
    color = Column(Text, nullable=True)            # JSON map
    material = Column(Text, nullable=True)         # JSON list
    feature = Column(Text, nullable=True)          # JSON list
    popular_search = Column(Text, nullable=True)   # JSON list
    price_range = Column(Text, nullable=True)      # JSON map
    series = Column(Text, nullable=True)           # JSON list
    sort_by = Column(Text, nullable=True)          # JSON list
    category = Column(String(255), nullable=True)

    def to_dict(self):
        import json
        def parse(v):
            if not v: return []
            try: return json.loads(v)
            except: return []
        def parse_map(v):
            if not v: return {}
            try: return json.loads(v)
            except: return {}
        return {
            'id': self.id,
            'price': parse(self.price),
            'color': parse_map(self.color),
            'material': parse(self.material),
            'feature': parse(self.feature),
            'popular_search': parse(self.popular_search),
            'price_range': parse_map(self.price_range),
            'series': parse(self.series),
            'sort_by': parse(self.sort_by),
            'category': self.category or ''
        }
