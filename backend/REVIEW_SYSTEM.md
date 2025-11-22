# Review System - Complete Implementation Guide

## Tổng quan
Hệ thống review đã được triển khai đầy đủ với các tính năng:
- ✅ Database table (migration)
- ✅ Backend API endpoints (CRUD)
- ✅ Frontend provider integration
- ✅ Tự động tính review_avg cho sản phẩm

## 1. Database Schema

**Table: reviews**
```sql
CREATE TABLE reviews (
    id VARCHAR(128) PRIMARY KEY,
    product_id VARCHAR(128) NOT NULL,
    user_id VARCHAR(128) NOT NULL,
    order_id VARCHAR(128),
    star FLOAT NOT NULL,
    message TEXT,
    img TEXT,          -- JSON array as string
    service TEXT,      -- JSON object as string
    created_at DATETIME NOT NULL,
    
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    INDEX ix_reviews_product_id (product_id),
    INDEX ix_reviews_user_id (user_id),
    INDEX ix_reviews_created_at (created_at)
);
```

## 2. Migration

**File:** `backend/alembic/versions/002_add_reviews_table.py`

**Chạy migration:**
```bash
cd backend
alembic upgrade head
```

**Rollback (nếu cần):**
```bash
alembic downgrade -1
```

## 3. Backend API Endpoints

### POST `/products/{product_id}/reviews` - Tạo review mới
**Yêu cầu:** Authentication (Bearer token)
**Body:**
```json
{
  "product_id": "PRO01",
  "order_id": "ORDER123",  // optional
  "star": 4.5,             // 1.0 - 5.0
  "message": "Great product!",
  "img": ["url1", "url2"],
  "service": {"delivery": "fast"}
}
```
**Response:** 201 Created
- Tự động cập nhật `products.review_avg`
- Một user chỉ review một product một lần

### GET `/products/{product_id}/reviews` - Lấy danh sách review
**Query params:**
- `skip`: offset (default: 0)
- `limit`: số lượng (default: 20)
- `sort_by`: "created_at" hoặc "star"
- `order`: "asc" hoặc "desc"

**Response:** 200 OK
```json
[
  {
    "id": "uuid",
    "product_id": "PRO01",
    "user_id": "USER01",
    "star": 4.5,
    "message": "Great!",
    "img": "[\"url1\"]",
    "timestamp": "2025-11-22T07:40:00",
    ...
  }
]
```

### GET `/reviews/{review_id}` - Lấy chi tiết một review

### PATCH `/reviews/{review_id}` - Cập nhật review
**Yêu cầu:** Authentication, chỉ author có thể update
**Body:** (tất cả optional)
```json
{
  "star": 5.0,
  "message": "Updated message",
  "img": ["new_url"],
  "service": {"new": "value"}
}
```
- Tự động recalculate `products.review_avg` nếu star thay đổi

### DELETE `/reviews/{review_id}` - Xóa review
**Yêu cầu:** Authentication, chỉ author có thể xóa
**Response:** 204 No Content
- Tự động recalculate `products.review_avg`

### GET `/users/me/reviews` - Lấy tất cả reviews của user hiện tại
**Yêu cầu:** Authentication
**Query params:** skip, limit

## 4. Flutter Integration

### ApiService Methods

**File:** `lib/services/api_service.dart`

```dart
// Lấy reviews của product
Future<List<Review>> fetchProductReviews(
  String productId, 
  {int skip = 0, int limit = 20, String sortBy = 'created_at', String order = 'desc'}
)

// Tạo review mới
Future<Review?> createReview({
  required String productId,
  String? orderId,
  required double star,
  String? message,
  List<String>? img,
  Map<String, dynamic>? service,
})

// Cập nhật review
Future<Review?> updateReview({
  required String reviewId,
  double? star,
  String? message,
  List<String>? img,
  Map<String, dynamic>? service,
})

// Xóa review
Future<bool> deleteReview(String reviewId)

// Lấy reviews của user hiện tại
Future<List<Review>> fetchMyReviews({int skip = 0, int limit = 20})
```

### ProductProvider Methods

**File:** `lib/provider/product_provider.dart`

```dart
// Lấy reviews
Future<void> fetchProductReviews(String productId, {int skip = 0, int limit = 20})

// Tạo review
Future<bool> addReview({
  required String productId,
  String? orderId,
  required double star,
  String? message,
  List<String>? img,
  Map<String, dynamic>? service,
})

// Cập nhật review
Future<bool> updateReview({
  required String reviewId,
  double? star,
  String? message,
  List<String>? img,
  Map<String, dynamic>? service,
})

// Xóa review
Future<bool> deleteReview(String reviewId, String productId)
```

## 5. Usage Example (Flutter)

```dart
// Trong ProductDetailScreen
final provider = Provider.of<ProductProvider>(context);

// Hiển thị reviews
FutureBuilder(
  future: provider.fetchProductReviews(productId),
  builder: (context, snapshot) {
    final reviews = provider.getListReviewProductItem;
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ListTile(
          title: Text('Rating: ${review.star}'),
          subtitle: Text(review.message),
        );
      },
    );
  },
)

// Thêm review
ElevatedButton(
  onPressed: () async {
    final success = await provider.addReview(
      productId: product.id,
      star: 5.0,
      message: 'Excellent product!',
      img: ['url1', 'url2'],
      service: {'delivery': 'fast'},
    );
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${provider.error}')),
      );
    }
  },
  child: Text('Add Review'),
)
```

## 6. Testing

**Chạy test script:**
```bash
cd backend
python test_reviews.py
```

**Script test các tính năng:**
1. Register user
2. Create review
3. Get product reviews
4. Update review
5. Get user reviews
6. Check product review_avg
7. Delete review

## 7. Features

### ✅ Implemented
- CRUD operations cho reviews
- Authentication & authorization
- Tự động tính review_avg cho products
- Pagination & sorting
- Cascade delete (xóa product/user → xóa reviews)
- Prevent duplicate reviews (1 user/product)

### 🔄 Business Logic
- Review avg tự động update khi:
  - Thêm review mới
  - Update star rating
  - Delete review
- User chỉ review một lần mỗi product
- Chỉ author có thể edit/delete review của mình

## 8. Database Query Examples

```sql
-- Xem tất cả reviews
SELECT * FROM reviews;

-- Xem reviews của một product
SELECT * FROM reviews WHERE product_id = 'PRO01' ORDER BY created_at DESC;

-- Xem review average của product
SELECT 
    p.id,
    p.name,
    p.review_avg,
    COUNT(r.id) as review_count
FROM products p
LEFT JOIN reviews r ON p.id = r.product_id
GROUP BY p.id;

-- Top rated products
SELECT 
    p.id,
    p.name,
    p.review_avg,
    COUNT(r.id) as review_count
FROM products p
LEFT JOIN reviews r ON p.id = r.product_id
GROUP BY p.id
HAVING review_count > 0
ORDER BY p.review_avg DESC
LIMIT 10;
```

## 9. Next Steps

Sau khi review system hoàn thành, có thể implement:
1. **Review images upload** - Upload ảnh review lên server
2. **Review replies** - Admin/seller trả lời reviews
3. **Review voting** - Users vote helpful reviews
4. **Review moderation** - Admin approve/reject reviews
5. **Verified purchase badge** - Chỉ hiển thị nếu đã mua

## 10. Notes

- `img` và `service` lưu dưới dạng JSON string trong MySQL TEXT field
- `created_at` sử dụng UTC timezone
- Frontend model `Review` đã compatible với backend response (có cả `idUser`, `idOrder`, `timestamp`, `date`)
- Provider tự động refresh product data sau khi add/delete review để update review_avg
