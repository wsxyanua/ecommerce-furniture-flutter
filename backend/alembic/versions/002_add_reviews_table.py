"""Add reviews table

Revision ID: 002_add_reviews
Revises: 001_initial
Create Date: 2025-11-22 07:40:00.000000

"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = '002_add_reviews'
down_revision = '001_initial'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Create reviews table
    op.create_table(
        'reviews',
        sa.Column('id', sa.String(128), primary_key=True, index=True),
        sa.Column('product_id', sa.String(128), sa.ForeignKey('products.id', ondelete='CASCADE'), nullable=False, index=True),
        sa.Column('user_id', sa.String(128), sa.ForeignKey('users.id', ondelete='CASCADE'), nullable=False, index=True),
        sa.Column('order_id', sa.String(128), nullable=True),
        sa.Column('star', sa.Float, nullable=False),
        sa.Column('message', sa.Text, nullable=True),
        sa.Column('img', sa.Text, nullable=True),  # JSON array as string
        sa.Column('service', sa.Text, nullable=True),  # JSON object as string
        sa.Column('created_at', sa.DateTime, nullable=False),
    )
    
    # Create indexes for faster queries
    op.create_index('ix_reviews_id', 'reviews', ['id'])
    op.create_index('ix_reviews_product_id', 'reviews', ['product_id'])
    op.create_index('ix_reviews_user_id', 'reviews', ['user_id'])
    op.create_index('ix_reviews_created_at', 'reviews', ['created_at'])


def downgrade() -> None:
    op.drop_table('reviews')
