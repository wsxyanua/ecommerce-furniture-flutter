from sqlalchemy import Column, Integer, String, Float, DateTime, Text, ForeignKey
from sqlalchemy.orm import relationship
from app.db import Base
import datetime

class Order(Base):
    __tablename__ = 'orders'

    id = Column(String(128), primary_key=True, index=True)
    id_user = Column(String(128), ForeignKey('users.id'), nullable=False)
    full_name = Column(String(255), nullable=True)
    address = Column(Text, nullable=True)
    city = Column(String(128), nullable=True)
    country = Column(String(128), nullable=True)
    phone = Column(String(50), nullable=True)
    payment_method = Column(String(64), nullable=True)
    status_order = Column(String(64), nullable=True)
    status_payment = Column(String(64), nullable=True)
    sub_total = Column(Float, nullable=True)
    total_order = Column(Float, nullable=True)
    vat = Column(Float, nullable=True)
    delivery_fee = Column(Float, nullable=True)
    note = Column(Text, nullable=True)
    date_order = Column(DateTime, default=datetime.datetime.utcnow)

class OrderItem(Base):
    __tablename__ = 'order_items'

    id = Column(Integer, primary_key=True, index=True)
    order_id = Column(String(128), ForeignKey('orders.id'), nullable=False)
    product_id = Column(String(128), nullable=False)
    name = Column(String(255), nullable=True)
    img = Column(Text, nullable=True)
    quantity = Column(Integer, nullable=False, default=1)
    price = Column(Float, nullable=False, default=0.0)
