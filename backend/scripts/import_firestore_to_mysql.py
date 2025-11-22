"""
Script import dữ liệu từ Firestore sang MySQL
Yêu cầu: Firebase Admin SDK credentials (service account JSON)
"""
import os
import sys
import json
from datetime import datetime

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.db import Base
from app.models.user import User
from app.models.product import Product
from app.models.order import Order, OrderItem
from app.models.banner import Banner
from app.models.category import Category, CategoryItem
from app.models.filter import FilterConfig
from app.models.country import Country

# Uncomment khi có Firebase credentials
# import firebase_admin
# from firebase_admin import credentials, firestore

DATABASE_URL = os.getenv("DATABASE_URL", "mysql+pymysql://furniture:furniture_pass@127.0.0.1:3306/furniture_db")

def init_mysql():
    """Khởi tạo kết nối MySQL"""
    engine = create_engine(DATABASE_URL, pool_pre_ping=True)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    return SessionLocal()

def init_firestore(credentials_path):
    """
    Khởi tạo Firestore client
    
    Args:
        credentials_path: Đường dẫn đến file service account JSON
    
    Uncomment khi có credentials:
    """
    # cred = credentials.Certificate(credentials_path)
    # firebase_admin.initialize_app(cred)
    # return firestore.client()
    print("⚠️  Firebase Admin SDK chưa được cấu hình")
    print("   Để sử dụng, cần:")
    print("   1. pip install firebase-admin")
    print("   2. Tải service account JSON từ Firebase Console")
    print("   3. Uncomment code trong init_firestore()")
    return None

def import_users(db_mysql, db_firestore):
    """Import users từ Firestore collection 'users'"""
    if not db_firestore:
        print("\n📋 Import users từ sample data...")
        sample_users = [
            {
                'id': 'user001',
                'email': 'admin@furniture.com',
                'phone': '+84912345678',
                'full_name': 'Admin User',
                'address': '123 Nguyen Hue, District 1, HCMC',
                'gender': 'Male',
                'status': 'VALID',
                'date_enter': '2024-01-01'
            },
            {
                'id': 'user002',
                'email': 'customer@example.com',
                'phone': '+84987654321',
                'full_name': 'Customer Test',
                'address': '456 Le Loi, District 3, HCMC',
                'gender': 'Female',
                'status': 'VALID',
                'date_enter': '2024-06-15'
            }
        ]
        
        count = 0
        for user_data in sample_users:
            user = User(
                id=user_data['id'],
                email=user_data.get('email'),
                phone=user_data.get('phone'),
                full_name=user_data.get('full_name'),
                address=user_data.get('address'),
                gender=user_data.get('gender'),
                status=user_data.get('status', 'VALID'),
                date_enter=user_data.get('date_enter'),
                created_at=datetime.utcnow()
            )
            db_mysql.add(user)
            count += 1
        
        db_mysql.commit()
        print(f"✅ Imported {count} sample users")
        return count
    
    # Với Firestore thực tế:
    # users_ref = db_firestore.collection('users')
    # docs = users_ref.stream()
    # count = 0
    # for doc in docs:
    #     user_data = doc.to_dict()
    #     user = User(
    #         id=doc.id,
    #         email=user_data.get('email'),
    #         phone=user_data.get('phone'),
    #         full_name=user_data.get('fullName'),
    #         address=user_data.get('address'),
    #         img=user_data.get('img'),
    #         birth_date=user_data.get('birthDate'),
    #         date_enter=user_data.get('dateEnter'),
    #         status=user_data.get('status'),
    #         gender=user_data.get('gender'),
    #         created_at=datetime.utcnow()
    #     )
    #     db_mysql.add(user)
    #     count += 1
    # db_mysql.commit()
    # return count

def import_products(db_mysql, db_firestore):
    """Import products từ Firestore"""
    if not db_firestore:
        print("\n📋 Import products từ sample data...")
        sample_products = [
            {
                'id': 'PRO001',
                'name': 'Modern Sofa',
                'title': 'Comfortable 3-Seater Sofa',
                'description': 'Premium quality modern sofa with soft cushions',
                'root_price': 15000000,
                'current_price': 12000000,
                'category_id': 'CAT001',
                'status': 'ACTIVE',
                'material': ['Fabric', 'Wood Frame'],
                'size': {'length': '200cm', 'width': '90cm', 'height': '85cm'},
                'review_avg': 4.5,
                'sell_count': 25
            },
            {
                'id': 'PRO002',
                'name': 'Dining Table Set',
                'title': '6-Person Dining Table',
                'description': 'Elegant wooden dining table with 6 chairs',
                'root_price': 20000000,
                'current_price': 18000000,
                'category_id': 'CAT002',
                'status': 'ACTIVE',
                'material': ['Solid Wood', 'Metal Legs'],
                'size': {'length': '180cm', 'width': '90cm', 'height': '75cm'},
                'review_avg': 4.8,
                'sell_count': 15
            }
        ]
        
        count = 0
        for prod_data in sample_products:
            product = Product(
                id=prod_data['id'],
                name=prod_data['name'],
                title=prod_data.get('title'),
                description=prod_data.get('description'),
                root_price=prod_data['root_price'],
                current_price=prod_data['current_price'],
                category_id=prod_data.get('category_id'),
                status=prod_data.get('status', 'ACTIVE'),
                material=prod_data.get('material'),
                size=prod_data.get('size'),
                review_avg=prod_data.get('review_avg', 0),
                sell_count=prod_data.get('sell_count', 0),
                timestamp=datetime.utcnow()
            )
            db_mysql.add(product)
            count += 1
        
        db_mysql.commit()
        print(f"✅ Imported {count} sample products")
        return count

def import_categories(db_mysql, db_firestore):
    """Import categories"""
    if not db_firestore:
        print("\n📋 Import categories từ sample data...")
        sample_categories = [
            {
                'id': 'CAT001',
                'name': 'Living Room Furniture',
                'status': 'ACTIVE',
                'items': [
                    {'id': 'CITEM001', 'name': 'Sofas', 'status': 'ACTIVE'},
                    {'id': 'CITEM002', 'name': 'Coffee Tables', 'status': 'ACTIVE'}
                ]
            },
            {
                'id': 'CAT002',
                'name': 'Dining Room Furniture',
                'status': 'ACTIVE',
                'items': [
                    {'id': 'CITEM003', 'name': 'Dining Tables', 'status': 'ACTIVE'},
                    {'id': 'CITEM004', 'name': 'Dining Chairs', 'status': 'ACTIVE'}
                ]
            }
        ]
        
        count = 0
        for cat_data in sample_categories:
            category = Category(
                id=cat_data['id'],
                name=cat_data['name'],
                status=cat_data.get('status', 'ACTIVE')
            )
            db_mysql.add(category)
            db_mysql.flush()
            
            for item_data in cat_data.get('items', []):
                item = CategoryItem(
                    id=item_data['id'],
                    category_id=cat_data['id'],
                    name=item_data['name'],
                    status=item_data.get('status', 'ACTIVE')
                )
                db_mysql.add(item)
            count += 1
        
        db_mysql.commit()
        print(f"✅ Imported {count} sample categories")
        return count

def import_banners(db_mysql, db_firestore):
    """Import banners"""
    if not db_firestore:
        print("\n📋 Import banners từ sample data...")
        sample_banners = [
            {
                'id': 'BAN001',
                'date_start': '2024-01-01',
                'date_end': '2024-12-31',
                'status': 'ACTIVE',
                'product': 'PRO001,PRO002'
            }
        ]
        
        count = 0
        for banner_data in sample_banners:
            banner = Banner(
                id=banner_data['id'],
                date_start=banner_data.get('date_start'),
                date_end=banner_data.get('date_end'),
                status=banner_data.get('status', 'ACTIVE'),
                product=banner_data.get('product'),
                created_at=datetime.utcnow()
            )
            db_mysql.add(banner)
            count += 1
        
        db_mysql.commit()
        print(f"✅ Imported {count} sample banners")
        return count

def import_countries(db_mysql, db_firestore):
    """Import countries và cities"""
    if not db_firestore:
        print("\n📋 Import countries từ sample data...")
        sample_countries = [
            {
                'id': 'VN',
                'name': 'Vietnam',
                'city': json.dumps(['Ho Chi Minh', 'Hanoi', 'Da Nang', 'Can Tho', 'Hai Phong'])
            },
            {
                'id': 'US',
                'name': 'United States',
                'city': json.dumps(['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'])
            }
        ]
        
        count = 0
        for country_data in sample_countries:
            country = Country(
                id=country_data['id'],
                name=country_data['name'],
                city=country_data.get('city')
            )
            db_mysql.add(country)
            count += 1
        
        db_mysql.commit()
        print(f"✅ Imported {count} sample countries")
        return count

def import_filter_configs(db_mysql, db_firestore):
    """Import filter configurations"""
    if not db_firestore:
        print("\n📋 Import filter configs từ sample data...")
        filter_config = FilterConfig(
            id='default',
            price=json.dumps(['0-5000000', '5000000-10000000', '10000000-20000000', '20000000+']),
            color=json.dumps({'Red': '#FF0000', 'Blue': '#0000FF', 'Green': '#00FF00'}),
            material=json.dumps(['Wood', 'Metal', 'Fabric', 'Leather']),
            feature=json.dumps(['Waterproof', 'UV Resistant', 'Eco-friendly']),
            popular_search=json.dumps(['Sofa', 'Dining Table', 'Bed', 'Chair']),
            price_range=json.dumps({'min': 0, 'max': 50000000}),
            series=json.dumps(['Modern', 'Classic', 'Minimalist']),
            sort_by=json.dumps(['Price: Low to High', 'Price: High to Low', 'Best Selling', 'Top Rated']),
            category='all'
        )
        db_mysql.add(filter_config)
        db_mysql.commit()
        print(f"✅ Imported filter config")
        return 1

def main():
    """Main import process"""
    print("=" * 60)
    print("🔄 FIRESTORE TO MYSQL IMPORT TOOL")
    print("=" * 60)
    
    # Khởi tạo MySQL
    print("\n🔌 Connecting to MySQL...")
    db_mysql = init_mysql()
    print("✅ MySQL connected")
    
    # Khởi tạo Firestore (optional)
    credentials_path = os.getenv('FIREBASE_CREDENTIALS', 'firebase-credentials.json')
    db_firestore = None
    
    if os.path.exists(credentials_path):
        print(f"\n🔌 Connecting to Firestore using {credentials_path}...")
        db_firestore = init_firestore(credentials_path)
    else:
        print(f"\n⚠️  Firebase credentials not found: {credentials_path}")
        print("   Sẽ import sample data thay thế")
    
    # Import các collections
    try:
        total = 0
        total += import_users(db_mysql, db_firestore)
        total += import_products(db_mysql, db_firestore)
        total += import_categories(db_mysql, db_firestore)
        total += import_banners(db_mysql, db_firestore)
        total += import_countries(db_mysql, db_firestore)
        total += import_filter_configs(db_mysql, db_firestore)
        
        print("\n" + "=" * 60)
        print(f"✅ HOÀN TẤT! Đã import tổng cộng {total} records")
        print("=" * 60)
        
    except Exception as e:
        print(f"\n❌ Lỗi: {e}")
        db_mysql.rollback()
        raise
    finally:
        db_mysql.close()

if __name__ == "__main__":
    main()
