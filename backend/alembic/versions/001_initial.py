"""Initial migration - create all tables

Revision ID: 001_initial
Revises: 
Create Date: 2025-11-21 02:40:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision = '001_initial'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Create users table
    op.create_table(
        'users',
        sa.Column('id', sa.String(128), primary_key=True),
        sa.Column('email', sa.String(255), unique=True, nullable=True, index=True),
        sa.Column('phone', sa.String(50), unique=True, nullable=True),
        sa.Column('full_name', sa.String(255), nullable=True),
        sa.Column('address', sa.Text, nullable=True),
        sa.Column('img', sa.Text, nullable=True),
        sa.Column('birth_date', sa.String(50), nullable=True),
        sa.Column('date_enter', sa.String(50), nullable=True),
        sa.Column('status', sa.String(50), nullable=True),
        sa.Column('gender', sa.String(20), nullable=True),
        sa.Column('password_hash', sa.Text, nullable=True),
        sa.Column('created_at', sa.DateTime, nullable=True),
    )
    
    # Create products table
    op.create_table(
        'products',
        sa.Column('id', sa.String(128), primary_key=True, index=True),
        sa.Column('name', sa.String(255), nullable=False),
        sa.Column('title', sa.String(255), nullable=True),
        sa.Column('img', sa.Text, nullable=True),
        sa.Column('description', sa.Text, nullable=True),
        sa.Column('root_price', sa.Float, nullable=False, default=0),
        sa.Column('current_price', sa.Float, nullable=False, default=0),
        sa.Column('category_id', sa.String(128), nullable=True),
        sa.Column('status', sa.String(64), nullable=True),
        sa.Column('material', mysql.JSON, nullable=True),
        sa.Column('size', mysql.JSON, nullable=True),
        sa.Column('review_avg', sa.Float, default=0),
        sa.Column('sell_count', sa.Integer, default=0),
        sa.Column('timestamp', sa.DateTime, nullable=True),
    )
    
    # Create orders table
    op.create_table(
        'orders',
        sa.Column('id', sa.String(128), primary_key=True, index=True),
        sa.Column('id_user', sa.String(128), sa.ForeignKey('users.id'), nullable=False),
        sa.Column('full_name', sa.String(255), nullable=True),
        sa.Column('address', sa.Text, nullable=True),
        sa.Column('city', sa.String(128), nullable=True),
        sa.Column('country', sa.String(128), nullable=True),
        sa.Column('phone', sa.String(50), nullable=True),
        sa.Column('payment_method', sa.String(64), nullable=True),
        sa.Column('status_order', sa.String(64), nullable=True),
        sa.Column('status_payment', sa.String(64), nullable=True),
        sa.Column('sub_total', sa.Float, nullable=True),
        sa.Column('total_order', sa.Float, nullable=True),
        sa.Column('vat', sa.Float, nullable=True),
        sa.Column('delivery_fee', sa.Float, nullable=True),
        sa.Column('note', sa.Text, nullable=True),
        sa.Column('date_order', sa.DateTime, nullable=True),
    )
    
    # Create order_items table
    op.create_table(
        'order_items',
        sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
        sa.Column('order_id', sa.String(128), sa.ForeignKey('orders.id'), nullable=False),
        sa.Column('product_id', sa.String(128), nullable=False),
        sa.Column('name', sa.String(255), nullable=True),
        sa.Column('img', sa.Text, nullable=True),
        sa.Column('quantity', sa.Integer, nullable=False, default=1),
        sa.Column('price', sa.Float, nullable=False, default=0.0),
    )
    
    # Create cart_items table
    op.create_table(
        'cart_items',
        sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
        sa.Column('user_id', sa.String(128), sa.ForeignKey('users.id'), nullable=False),
        sa.Column('product_id', sa.String(128), nullable=False),
        sa.Column('name', sa.String(255), nullable=True),
        sa.Column('img', sa.Text, nullable=True),
        sa.Column('color', sa.String(100), nullable=True),
        sa.Column('quantity', sa.Integer, nullable=False, default=1),
        sa.Column('price', sa.Float, nullable=False, default=0.0),
    )
    
    # Create favorites table
    op.create_table(
        'favorites',
        sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
        sa.Column('user_id', sa.String(128), sa.ForeignKey('users.id'), nullable=False),
        sa.Column('product_id', sa.String(128), nullable=False),
        sa.Column('name', sa.String(255), nullable=True),
        sa.Column('img', sa.Text, nullable=True),
        sa.Column('price', sa.String(64), nullable=True),
    )
    
    # Create banners table
    op.create_table(
        'banners',
        sa.Column('id', sa.String(128), primary_key=True, index=True),
        sa.Column('img', sa.Text, nullable=True),
        sa.Column('date_start', sa.String(50), nullable=True),
        sa.Column('date_end', sa.String(50), nullable=True),
        sa.Column('status', sa.String(50), nullable=True),
        sa.Column('product', sa.Text, nullable=True),
        sa.Column('created_at', sa.DateTime, nullable=True),
    )
    
    # Create categories table
    op.create_table(
        'categories',
        sa.Column('id', sa.String(128), primary_key=True, index=True),
        sa.Column('name', sa.String(255), nullable=False),
        sa.Column('img', sa.Text, nullable=True),
        sa.Column('status', sa.String(50), nullable=True),
    )
    
    # Create category_items table
    op.create_table(
        'category_items',
        sa.Column('id', sa.String(128), primary_key=True, index=True),
        sa.Column('category_id', sa.String(128), sa.ForeignKey('categories.id'), nullable=False),
        sa.Column('name', sa.String(255), nullable=False),
        sa.Column('img', sa.Text, nullable=True),
        sa.Column('status', sa.String(50), nullable=True),
    )
    
    # Create filter_configs table
    op.create_table(
        'filter_configs',
        sa.Column('id', sa.String(128), primary_key=True, index=True),
        sa.Column('price', sa.Text, nullable=True),
        sa.Column('color', sa.Text, nullable=True),
        sa.Column('material', sa.Text, nullable=True),
        sa.Column('feature', sa.Text, nullable=True),
        sa.Column('popular_search', sa.Text, nullable=True),
        sa.Column('price_range', sa.Text, nullable=True),
        sa.Column('series', sa.Text, nullable=True),
        sa.Column('sort_by', sa.Text, nullable=True),
        sa.Column('category', sa.String(255), nullable=True),
    )
    
    # Create countries table
    op.create_table(
        'countries',
        sa.Column('id', sa.String(128), primary_key=True, index=True),
        sa.Column('name', sa.String(255), nullable=False),
        sa.Column('city', sa.Text, nullable=True),
    )
    
    # Create indexes
    op.create_index('ix_users_id', 'users', ['id'])
    op.create_index('ix_products_id', 'products', ['id'])
    op.create_index('ix_orders_id', 'orders', ['id'])
    op.create_index('ix_banners_id', 'banners', ['id'])
    op.create_index('ix_categories_id', 'categories', ['id'])
    op.create_index('ix_category_items_id', 'category_items', ['id'])
    op.create_index('ix_filter_configs_id', 'filter_configs', ['id'])
    op.create_index('ix_countries_id', 'countries', ['id'])


def downgrade() -> None:
    # Drop tables in reverse order to respect foreign keys
    op.drop_table('countries')
    op.drop_table('filter_configs')
    op.drop_table('category_items')
    op.drop_table('categories')
    op.drop_table('banners')
    op.drop_table('favorites')
    op.drop_table('cart_items')
    op.drop_table('order_items')
    op.drop_table('orders')
    op.drop_table('products')
    op.drop_table('users')
