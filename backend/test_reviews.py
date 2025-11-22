"""
Test script for review system functionality.
Run after: docker-compose up -d
"""
import requests
import json

BASE_URL = "http://localhost:8000"

def test_reviews():
    print("=== Testing Review System ===\n")
    
    # 1. Register a test user
    print("1. Registering test user...")
    register_data = {
        "email": "reviewer@test.com",
        "password": "test123",
        "full_name": "Test Reviewer"
    }
    response = requests.post(f"{BASE_URL}/auth/register", json=register_data)
    if response.status_code == 200:
        token = response.json()["access_token"]
        print(f"✓ User registered, token: {token[:20]}...\n")
    else:
        print(f"✗ Registration failed: {response.text}\n")
        return
    
    headers = {"Authorization": f"Bearer {token}"}
    
    # 2. Get products
    print("2. Fetching products...")
    response = requests.get(f"{BASE_URL}/products")
    products = response.json()
    if len(products) > 0:
        product_id = products[0]["id"]
        print(f"✓ Found {len(products)} products, using: {product_id}\n")
    else:
        print("✗ No products found\n")
        return
    
    # 3. Create a review
    print("3. Creating review...")
    review_data = {
        "product_id": product_id,
        "star": 4.5,
        "message": "Great product! Very comfortable and high quality.",
        "img": ["https://example.com/img1.jpg", "https://example.com/img2.jpg"],
        "service": {"delivery": "fast", "packaging": "excellent"}
    }
    response = requests.post(f"{BASE_URL}/products/{product_id}/reviews", 
                            json=review_data, headers=headers)
    if response.status_code == 201:
        review = response.json()
        review_id = review["id"]
        print(f"✓ Review created: {review_id}")
        print(f"  Star: {review['star']}, Message: {review['message']}\n")
    else:
        print(f"✗ Review creation failed: {response.text}\n")
        return
    
    # 4. Get product reviews
    print("4. Fetching product reviews...")
    response = requests.get(f"{BASE_URL}/products/{product_id}/reviews")
    if response.status_code == 200:
        reviews = response.json()
        print(f"✓ Found {len(reviews)} reviews for product\n")
    else:
        print(f"✗ Failed to fetch reviews: {response.text}\n")
    
    # 5. Update review
    print("5. Updating review...")
    update_data = {
        "star": 5.0,
        "message": "Updated: Even better than I thought!"
    }
    response = requests.patch(f"{BASE_URL}/reviews/{review_id}", 
                             json=update_data, headers=headers)
    if response.status_code == 200:
        updated = response.json()
        print(f"✓ Review updated: Star now {updated['star']}\n")
    else:
        print(f"✗ Update failed: {response.text}\n")
    
    # 6. Get user's reviews
    print("6. Fetching my reviews...")
    response = requests.get(f"{BASE_URL}/users/me/reviews", headers=headers)
    if response.status_code == 200:
        my_reviews = response.json()
        print(f"✓ User has {len(my_reviews)} reviews\n")
    else:
        print(f"✗ Failed: {response.text}\n")
    
    # 7. Check product review average
    print("7. Checking product review average...")
    response = requests.get(f"{BASE_URL}/products/{product_id}")
    if response.status_code == 200:
        product = response.json()
        print(f"✓ Product review_avg: {product.get('review_avg', 0)}\n")
    else:
        print(f"✗ Failed: {response.text}\n")
    
    # 8. Delete review
    print("8. Deleting review...")
    response = requests.delete(f"{BASE_URL}/reviews/{review_id}", headers=headers)
    if response.status_code == 204:
        print(f"✓ Review deleted successfully\n")
    else:
        print(f"✗ Deletion failed: {response.text}\n")
    
    print("=== All tests completed ===")

if __name__ == "__main__":
    try:
        test_reviews()
    except requests.exceptions.ConnectionError:
        print("✗ Cannot connect to backend. Make sure it's running:")
        print("  cd backend && docker-compose up -d")
    except Exception as e:
        print(f"✗ Error: {e}")
