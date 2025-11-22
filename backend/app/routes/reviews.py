from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import desc, func
from typing import List
import json
import uuid
from datetime import datetime

from app.db import get_db
from app.models.review import Review
from app.models.product import Product
from app.models.user import User
from app.schemas.review import ReviewCreate, ReviewUpdate, ReviewResponse
from app.core.security import get_current_user

router = APIRouter()


@router.post("/products/{product_id}/reviews", response_model=ReviewResponse, status_code=status.HTTP_201_CREATED)
def create_review(
    product_id: str,
    review_data: ReviewCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Create a new review for a product.
    Requires authentication.
    """
    # Verify product exists
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    
    # Check if user already reviewed this product
    existing_review = db.query(Review).filter(
        Review.product_id == product_id,
        Review.user_id == current_user.id
    ).first()
    
    if existing_review:
        raise HTTPException(
            status_code=400,
            detail="You have already reviewed this product. Use PATCH to update your review."
        )
    
    # Create review
    review = Review(
        id=str(uuid.uuid4()),
        product_id=product_id,
        user_id=current_user.id,
        order_id=review_data.order_id,
        star=review_data.star,
        message=review_data.message,
        img=json.dumps(review_data.img) if review_data.img else None,
        service=json.dumps(review_data.service) if review_data.service else None,
        created_at=datetime.utcnow()
    )
    
    db.add(review)
    
    # Update product review average
    avg_rating = db.query(func.avg(Review.star)).filter(
        Review.product_id == product_id
    ).scalar() or 0
    
    # Include the new review in average
    review_count = db.query(func.count(Review.id)).filter(
        Review.product_id == product_id
    ).scalar()
    
    product.review_avg = (avg_rating * review_count + review_data.star) / (review_count + 1)
    
    db.commit()
    db.refresh(review)
    
    return review.to_dict()


@router.get("/products/{product_id}/reviews", response_model=List[ReviewResponse])
def get_product_reviews(
    product_id: str,
    skip: int = 0,
    limit: int = 20,
    sort_by: str = "created_at",
    order: str = "desc",
    db: Session = Depends(get_db)
):
    """
    Get all reviews for a specific product with pagination.
    
    - **sort_by**: Field to sort by (created_at, star)
    - **order**: Sort order (asc, desc)
    - **skip**: Number of records to skip (pagination)
    - **limit**: Maximum number of records to return
    """
    # Verify product exists
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    
    # Build query
    query = db.query(Review).filter(Review.product_id == product_id)
    
    # Apply sorting
    if sort_by == "star":
        sort_column = Review.star
    else:
        sort_column = Review.created_at
    
    if order.lower() == "asc":
        query = query.order_by(sort_column.asc())
    else:
        query = query.order_by(sort_column.desc())
    
    # Apply pagination
    reviews = query.offset(skip).limit(limit).all()
    
    return [review.to_dict() for review in reviews]


@router.get("/reviews/{review_id}", response_model=ReviewResponse)
def get_review(review_id: str, db: Session = Depends(get_db)):
    """Get a specific review by ID."""
    review = db.query(Review).filter(Review.id == review_id).first()
    if not review:
        raise HTTPException(status_code=404, detail="Review not found")
    return review.to_dict()


@router.patch("/reviews/{review_id}", response_model=ReviewResponse)
def update_review(
    review_id: str,
    review_data: ReviewUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Update an existing review.
    Only the review author can update their review.
    """
    review = db.query(Review).filter(Review.id == review_id).first()
    if not review:
        raise HTTPException(status_code=404, detail="Review not found")
    
    # Check ownership
    if review.user_id != current_user.id:
        raise HTTPException(
            status_code=403,
            detail="You can only update your own reviews"
        )
    
    # Store old star rating for average calculation
    old_star = review.star
    
    # Update fields
    if review_data.star is not None:
        review.star = review_data.star
    if review_data.message is not None:
        review.message = review_data.message
    if review_data.img is not None:
        review.img = json.dumps(review_data.img)
    if review_data.service is not None:
        review.service = json.dumps(review_data.service)
    
    # Recalculate product review average if star changed
    if review_data.star is not None and old_star != review_data.star:
        product = db.query(Product).filter(Product.id == review.product_id).first()
        if product:
            avg_rating = db.query(func.avg(Review.star)).filter(
                Review.product_id == review.product_id
            ).scalar() or 0
            product.review_avg = float(avg_rating)
    
    db.commit()
    db.refresh(review)
    
    return review.to_dict()


@router.delete("/reviews/{review_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_review(
    review_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Delete a review.
    Only the review author can delete their review.
    """
    review = db.query(Review).filter(Review.id == review_id).first()
    if not review:
        raise HTTPException(status_code=404, detail="Review not found")
    
    # Check ownership
    if review.user_id != current_user.id:
        raise HTTPException(
            status_code=403,
            detail="You can only delete your own reviews"
        )
    
    product_id = review.product_id
    
    db.delete(review)
    
    # Recalculate product review average
    product = db.query(Product).filter(Product.id == product_id).first()
    if product:
        avg_rating = db.query(func.avg(Review.star)).filter(
            Review.product_id == product_id
        ).scalar() or 0
        product.review_avg = float(avg_rating)
    
    db.commit()
    
    return None


@router.get("/users/me/reviews", response_model=List[ReviewResponse])
def get_my_reviews(
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all reviews written by the current user."""
    reviews = db.query(Review).filter(
        Review.user_id == current_user.id
    ).order_by(desc(Review.created_at)).offset(skip).limit(limit).all()
    
    return [review.to_dict() for review in reviews]
