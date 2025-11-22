# Alembic Database Migrations

## Thiết Lập Ban Đầu

### 1. Khởi động MySQL Database
```bash
cd backend
docker-compose up -d mysql
```

### 2. Cài Đặt Dependencies
```bash
pip install -r requirements.txt
```

### 3. Cấu Hình Database URL
Chỉnh sửa `alembic.ini` hoặc set biến môi trường:
```bash
export DATABASE_URL="mysql+pymysql://furniture:furniture_pass@127.0.0.1:3306/furniture_db"
```

## Chạy Migrations

### Tạo tất cả bảng (lần đầu)
```bash
alembic upgrade head
```

### Kiểm tra trạng thái migration hiện tại
```bash
alembic current
```

### Xem lịch sử migrations
```bash
alembic history
```

### Rollback về phiên bản trước
```bash
alembic downgrade -1
```

### Rollback về phiên bản cụ thể
```bash
alembic downgrade 001_initial
```

### Xóa toàn bộ database (rollback tất cả)
```bash
alembic downgrade base
```

## Tạo Migration Mới

### Auto-generate từ model changes
```bash
alembic revision --autogenerate -m "Add new column to users"
```

### Tạo migration rỗng (manual)
```bash
alembic revision -m "Custom migration"
```

## Cấu Trúc

```
backend/
├── alembic/
│   ├── versions/
│   │   └── 001_initial.py      # Migration đầu tiên
│   ├── env.py                   # Cấu hình Alembic
│   └── script.py.mako           # Template cho migrations mới
├── alembic.ini                  # Config file
└── app/
    ├── db.py                    # Database setup
    └── models/                  # SQLAlchemy models
        ├── user.py
        ├── product.py
        ├── order.py
        ├── cart.py
        ├── favorite.py
        ├── banner.py
        ├── category.py
        ├── filter.py
        └── country.py
```

## Migration Hiện Có

### `001_initial` - Tạo Tất Cả Bảng
- **users**: Thông tin người dùng, authentication
- **products**: Sản phẩm nội thất
- **orders**: Đơn hàng
- **order_items**: Chi tiết sản phẩm trong đơn
- **cart_items**: Giỏ hàng
- **favorites**: Danh sách yêu thích
- **banners**: Banner quảng cáo
- **categories**: Danh mục sản phẩm
- **category_items**: Danh mục con
- **filter_configs**: Cấu hình bộ lọc
- **countries**: Quốc gia và thành phố

## Troubleshooting

### Lỗi "Can't connect to MySQL"
Kiểm tra MySQL đang chạy:
```bash
docker-compose ps
```

### Lỗi "Table already exists"
Nếu đã tạo bảng bằng `init_db()`, xóa database và chạy lại:
```bash
docker-compose down -v
docker-compose up -d mysql
alembic upgrade head
```

### Xem SQL sẽ được execute (không chạy thực tế)
```bash
alembic upgrade head --sql
```

## Best Practices

1. **Luôn review migration trước khi chạy production**
2. **Backup database trước khi upgrade**
3. **Test migrations trên staging trước**
4. **Commit migrations vào git**
5. **Không sửa migrations đã deploy**
