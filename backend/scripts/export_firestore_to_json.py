"""
Export Firestore collections thành JSON files
Dùng khi cần backup hoặc migrate dữ liệu
"""
import os
import json
from datetime import datetime

# Uncomment khi có Firebase credentials
# import firebase_admin
# from firebase_admin import credentials, firestore

def init_firestore(credentials_path):
    """Khởi tạo Firestore client"""
    # cred = credentials.Certificate(credentials_path)
    # firebase_admin.initialize_app(cred)
    # return firestore.client()
    print("⚠️  Firebase Admin SDK chưa được cấu hình")
    print("   Để sử dụng:")
    print("   1. pip install firebase-admin")
    print("   2. Tải service account JSON từ Firebase Console")
    print("   3. Uncomment code trong init_firestore()")
    return None

def export_collection(db, collection_name, output_dir):
    """
    Export một Firestore collection thành JSON
    
    Args:
        db: Firestore client
        collection_name: Tên collection
        output_dir: Thư mục lưu file JSON
    """
    if not db:
        print(f"❌ Không thể export {collection_name} - Firestore chưa kết nối")
        return
    
    # Tạo thư mục output nếu chưa có
    os.makedirs(output_dir, exist_ok=True)
    
    # Đọc tất cả documents
    docs_ref = db.collection(collection_name)
    docs = docs_ref.stream()
    
    # Chuyển thành list of dicts
    data = []
    count = 0
    for doc in docs:
        doc_data = doc.to_dict()
        doc_data['id'] = doc.id  # Thêm document ID
        
        # Convert Firestore timestamps thành string
        for key, value in doc_data.items():
            if hasattr(value, 'timestamp'):  # Firestore Timestamp
                doc_data[key] = value.isoformat()
        
        data.append(doc_data)
        count += 1
    
    # Lưu ra file JSON
    output_file = os.path.join(output_dir, f'{collection_name}.json')
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"✅ Exported {count} documents from '{collection_name}' → {output_file}")
    return count

def main():
    """Main export process"""
    print("=" * 60)
    print("📤 FIRESTORE TO JSON EXPORT TOOL")
    print("=" * 60)
    
    # Cấu hình
    credentials_path = os.getenv('FIREBASE_CREDENTIALS', 'firebase-credentials.json')
    output_dir = os.getenv('EXPORT_DIR', 'data/firestore_export')
    
    # Kiểm tra credentials
    if not os.path.exists(credentials_path):
        print(f"\n❌ Không tìm thấy Firebase credentials: {credentials_path}")
        print("   Tạo file này từ Firebase Console:")
        print("   Project Settings → Service Accounts → Generate new private key")
        return
    
    # Khởi tạo Firestore
    print(f"\n🔌 Connecting to Firestore...")
    db = init_firestore(credentials_path)
    
    if not db:
        print("\n❌ Không thể kết nối Firestore")
        print("   Uncomment code trong init_firestore() để enable Firebase")
        return
    
    print(f"✅ Firestore connected")
    print(f"📁 Output directory: {output_dir}\n")
    
    # Danh sách collections cần export
    collections = [
        'users',
        'products',
        'categories',
        'banners',
        'orders',
        'reviews',
        'filters',
        'countries'
    ]
    
    # Export từng collection
    total = 0
    for collection_name in collections:
        try:
            count = export_collection(db, collection_name, output_dir)
            if count is not None:
                total += count
        except Exception as e:
            print(f"⚠️  Lỗi khi export '{collection_name}': {e}")
    
    # Tạo metadata file
    metadata = {
        'export_date': datetime.utcnow().isoformat(),
        'total_documents': total,
        'collections': collections
    }
    
    metadata_file = os.path.join(output_dir, '_metadata.json')
    with open(metadata_file, 'w', encoding='utf-8') as f:
        json.dump(metadata, f, indent=2)
    
    print("\n" + "=" * 60)
    print(f"✅ HOÀN TẤT! Đã export {total} documents")
    print(f"📁 Files được lưu tại: {output_dir}")
    print("=" * 60)

if __name__ == "__main__":
    main()
