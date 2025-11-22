# Scripts Import & Migration

## Import Firestore → MySQL

### Chạy với sample data (không cần Firebase)
```bash
cd backend
python scripts/import_firestore_to_mysql.py
```

### Chạy với Firestore thực tế

1. **Cài Firebase Admin SDK:**
```bash
pip install firebase-admin
```

2. **Tải Service Account Key:**
- Vào Firebase Console → Project Settings → Service Accounts
- Click "Generate new private key"
- Lưu file JSON vào `backend/firebase-credentials.json`

3. **Uncomment code Firestore trong script:**
- Mở `scripts/import_firestore_to_mysql.py`
- Uncomment các dòng liên quan đến `firebase_admin` và `firestore`
- Uncomment logic import trong mỗi function

4. **Chạy import:**
```bash
cd backend
export DATABASE_URL="mysql+pymysql://furniture:furniture_pass@127.0.0.1:3306/furniture_db"
export FIREBASE_CREDENTIALS="firebase-credentials.json"
python scripts/import_firestore_to_mysql.py
```

## Sample Data

Script mặc định import sample data bao gồm:

### Users (2 users)
- admin@furniture.com
- customer@example.com

### Products (2 products)
- PRO001: Modern Sofa - 12,000,000 VND
- PRO002: Dining Table Set - 18,000,000 VND

### Categories (2 categories, 4 items)
- Living Room Furniture
  - Sofas
  - Coffee Tables
- Dining Room Furniture
  - Dining Tables
  - Dining Chairs

### Banners (1 banner)
- Active banner linking to sample products

### Countries (2 countries)
- Vietnam (5 cities)
- United States (5 cities)

### Filter Configs
- Price ranges
- Colors (RGB)
- Materials
- Features
- Popular searches
- Sort options

## Tùy Chỉnh Import

Để import data riêng của bạn, có 2 cách:

### Cách 1: Sửa sample data
Edit các list `sample_*` trong mỗi function của script.

### Cách 2: Import từ JSON files
```python
# Đọc từ file JSON
with open('data/products.json', 'r', encoding='utf-8') as f:
    products_data = json.load(f)

for prod in products_data:
    product = Product(**prod)
    db_mysql.add(product)
```

## Xác Minh Import

Sau khi import, kiểm tra database:

```bash
# Vào MySQL container
docker-compose exec mysql mysql -u furniture -pfurniture_pass furniture_db

# Check số lượng records
SELECT 'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'banners', COUNT(*) FROM banners
UNION ALL
SELECT 'countries', COUNT(*) FROM countries;
```

## Troubleshooting

### "No module named 'app'"
```bash
# Chạy từ thư mục backend
cd backend
python scripts/import_firestore_to_mysql.py
```

### "Can't connect to MySQL"
```bash
# Khởi động MySQL trước
docker-compose up -d mysql

# Đợi 10 giây để MySQL khởi động
sleep 10

# Chạy script
python scripts/import_firestore_to_mysql.py
```

### "Table doesn't exist"
```bash
# Chạy migrations trước
alembic upgrade head
```

## Mở Rộng

Để thêm import cho models khác (Reviews, Orders, Cart):

1. Tạo function mới trong script:
```python
def import_reviews(db_mysql, db_firestore):
    # Logic import reviews
    pass
```

2. Gọi trong `main()`:
```python
total += import_reviews(db_mysql, db_firestore)
```
