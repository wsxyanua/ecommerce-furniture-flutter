"""
Import dữ liệu từ JSON files vào MySQL
Dùng khi đã export Firestore ra JSON hoặc có data custom
"""
import os
import sys
import json
from datetime import datetime

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.user import User
from app.models.product import Product
from app.models.banner import Banner
from app.models.category import Category, CategoryItem
from app.models.filter import FilterConfig
from app.models.country import Country

DATABASE_URL = os.getenv("DATABASE_URL", "mysql+pymysql://furniture:furniture_pass@127.0.0.1:3306/furniture_db")

def init_mysql():
    """Khởi tạo kết nối MySQL"""
    engine = create_engine(DATABASE_URL, pool_pre_ping=True)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    return SessionLocal()

def load_json(filepath):
    """Load data từ JSON file"""
    if not os.path.exists(filepath):
        print(f"⚠️  File không tồn tại: {filepath}")
        return []
    
    with open(filepath, 'r', encoding='utf-8') as f:
        return json.load(f)

def import_users_from_json(db, data_dir):
    """Import users từ JSON"""
    filepath = os.path.join(data_dir, 'users.json')
    users_data = load_json(filepath)
    
    if not users_data:
        print(f"⚠️  Không có dữ liệu users")
        return 0
    
    count = 0
    for user_data in users_data:
        user = User(
            id=user_data.get('id'),
            email=user_data.get('email'),
            phone=user_data.get('phone'),
            full_name=user_data.get('fullName') or user_data.get('full_name'),
            address=user_data.get('address'),
            img=user_data.get('img'),
            birth_date=user_data.get('birthDate') or user_data.get('birth_date'),
            date_enter=user_data.get('dateEnter') or user_data.get('date_enter'),
            status=user_data.get('status', 'VALID'),
            gender=user_data.get('gender'),
            password_hash=user_data.get('password_hash'),
            created_at=datetime.utcnow()
        )
        db.add(user)
        count += 1
    
    db.commit()
    print(f"✅ Imported {count} users")
    return count

def import_products_from_json(db, data_dir):
    """Import products từ JSON"""
    filepath = os.path.join(data_dir, 'products.json')
    products_data = load_json(filepath)
    
    if not products_data:
        print(f"⚠️  Không có dữ liệu products")
        return 0
    
    count = 0
    for prod_data in products_data:
        product = Product(
            id=prod_data.get('id'),
            name=prod_data.get('name'),
            title=prod_data.get('title'),
            img=prod_data.get('img'),
            description=prod_data.get('description'),
            root_price=float(prod_data.get('rootPrice') or prod_data.get('root_price', 0)),
            current_price=float(prod_data.get('currentPrice') or prod_data.get('current_price', 0)),
            category_id=prod_data.get('categoryId') or prod_data.get('category_id'),
            status=prod_data.get('status', 'ACTIVE'),
            material=prod_data.get('material'),
            size=prod_data.get('size'),
            review_avg=float(prod_data.get('reviewAvg') or prod_data.get('review_avg', 0)),
            sell_count=int(prod_data.get('sellCount') or prod_data.get('sell_count', 0)),
            timestamp=datetime.utcnow()
        )
        db.add(product)
        count += 1
    
    db.commit()
    print(f"✅ Imported {count} products")
    return count

def import_categories_from_json(db, data_dir):
    """Import categories từ JSON"""
    filepath = os.path.join(data_dir, 'categories.json')
    categories_data = load_json(filepath)
    
    if not categories_data:
        print(f"⚠️  Không có dữ liệu categories")
        return 0
    
    count = 0
    for cat_data in categories_data:
        category = Category(
            id=cat_data.get('id'),
            name=cat_data.get('name'),
            img=cat_data.get('img'),
            status=cat_data.get('status', 'ACTIVE')
        )
        db.add(category)
        db.flush()
        
        # Import category items nếu có
        items = cat_data.get('items', [])
        for item_data in items:
            if isinstance(item_data, dict):
                item = CategoryItem(
                    id=item_data.get('id'),
                    category_id=cat_data.get('id'),
                    name=item_data.get('name'),
                    img=item_data.get('img'),
                    status=item_data.get('status', 'ACTIVE')
                )
                db.add(item)
        
        count += 1
    
    db.commit()
    print(f"✅ Imported {count} categories")
    return count

def import_banners_from_json(db, data_dir):
    """Import banners từ JSON"""
    filepath = os.path.join(data_dir, 'banners.json')
    banners_data = load_json(filepath)
    
    if not banners_data:
        print(f"⚠️  Không có dữ liệu banners")
        return 0
    
    count = 0
    for banner_data in banners_data:
        # Convert product list to comma-separated string nếu cần
        product_list = banner_data.get('product', [])
        if isinstance(product_list, list):
            product_str = ','.join(product_list)
        else:
            product_str = product_list
        
        banner = Banner(
            id=banner_data.get('id'),
            img=banner_data.get('img'),
            date_start=banner_data.get('dateStart') or banner_data.get('date_start'),
            date_end=banner_data.get('dateEnd') or banner_data.get('date_end'),
            status=banner_data.get('status', 'ACTIVE'),
            product=product_str,
            created_at=datetime.utcnow()
        )
        db.add(banner)
        count += 1
    
    db.commit()
    print(f"✅ Imported {count} banners")
    return count

def import_countries_from_json(db, data_dir):
    """Import countries từ JSON"""
    filepath = os.path.join(data_dir, 'countries.json')
    countries_data = load_json(filepath)
    
    if not countries_data:
        print(f"⚠️  Không có dữ liệu countries")
        return 0
    
    count = 0
    for country_data in countries_data:
        # Convert city list to JSON string nếu cần
        city_list = country_data.get('city', [])
        if isinstance(city_list, list):
            city_str = json.dumps(city_list)
        else:
            city_str = city_list
        
        country = Country(
            id=country_data.get('id'),
            name=country_data.get('name'),
            city=city_str
        )
        db.add(country)
        count += 1
    
    db.commit()
    print(f"✅ Imported {count} countries")
    return count

def import_filters_from_json(db, data_dir):
    """Import filter configs từ JSON"""
    filepath = os.path.join(data_dir, 'filters.json')
    filters_data = load_json(filepath)
    
    if not filters_data:
        print(f"⚠️  Không có dữ liệu filters")
        return 0
    
    count = 0
    for filter_data in filters_data:
        # Helper function to convert to JSON string
        def to_json_str(value):
            if isinstance(value, (list, dict)):
                return json.dumps(value)
            return value
        
        filter_config = FilterConfig(
            id=filter_data.get('id', 'default'),
            price=to_json_str(filter_data.get('price')),
            color=to_json_str(filter_data.get('color')),
            material=to_json_str(filter_data.get('material')),
            feature=to_json_str(filter_data.get('feature')),
            popular_search=to_json_str(filter_data.get('popularSearch') or filter_data.get('popular_search')),
            price_range=to_json_str(filter_data.get('priceRange') or filter_data.get('price_range')),
            series=to_json_str(filter_data.get('series')),
            sort_by=to_json_str(filter_data.get('sortBy') or filter_data.get('sort_by')),
            category=filter_data.get('category', 'all')
        )
        db.add(filter_config)
        count += 1
    
    db.commit()
    print(f"✅ Imported {count} filter configs")
    return count

def main():
    """Main import process"""
    print("=" * 60)
    print("📥 JSON TO MYSQL IMPORT TOOL")
    print("=" * 60)
    
    # Cấu hình
    data_dir = os.getenv('DATA_DIR', 'data/firestore_export')
    
    if not os.path.exists(data_dir):
        print(f"\n❌ Thư mục dữ liệu không tồn tại: {data_dir}")
        print("   Tạo thư mục và thêm JSON files, hoặc:")
        print(f"   export DATA_DIR=/path/to/json/files")
        return
    
    print(f"\n📁 Data directory: {data_dir}")
    
    # Khởi tạo MySQL
    print("\n🔌 Connecting to MySQL...")
    db = init_mysql()
    print("✅ MySQL connected\n")
    
    # Import các collections
    try:
        total = 0
        total += import_users_from_json(db, data_dir)
        total += import_products_from_json(db, data_dir)
        total += import_categories_from_json(db, data_dir)
        total += import_banners_from_json(db, data_dir)
        total += import_countries_from_json(db, data_dir)
        total += import_filters_from_json(db, data_dir)
        
        print("\n" + "=" * 60)
        print(f"✅ HOÀN TẤT! Đã import {total} collections")
        print("=" * 60)
        
    except Exception as e:
        print(f"\n❌ Lỗi: {e}")
        db.rollback()
        raise
    finally:
        db.close()

if __name__ == "__main__":
    main()
