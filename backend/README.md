 Furniture backend (FastAPI) - scaffold

 Thư mục này chứa scaffold FastAPI tối thiểu, có thể tách ra repository riêng.

 Bắt đầu nhanh (phát triển với Docker):

 1. Sao chép file cấu hình môi trường:

 ```bash
 cp .env.example .env
 ```

 2. Build và chạy bằng docker-compose:

 ```bash
 docker-compose up --build
 ```

 3. API:
 - Mở http://localhost:8000
 - Danh sách sản phẩm: http://localhost:8000/products

 Kết nối MySQL bằng MySQL Workbench:
 - Host: 127.0.0.1
 - Port: 3306
 - Username: `furniture`
 - Password: `furniture_pass`
 - Schema: `furniture_db`

 Ghi chú và bước tiếp theo:
 - Scaffold này tạo bảng trong DB khi khởi động để thuận tiện phát triển; trong môi trường production hãy sử dụng Alembic cho migration.
 - Nên khởi tạo repository git mới cho backend (thư mục `backend/`) và đẩy lên remote.
 - Chiến lược xác thực:
   - Trong giai đoạn chuyển, bạn có thể giữ Firebase Auth (backend verify token bằng `firebase-admin`) hoặc triển khai xác thực JWT do backend cấp.

 Chuyển dữ liệu từ Firestore:
 - Xuất dữ liệu từ Firestore (dùng Admin SDK hoặc `gcloud firestore export`), sau đó viết script import để chèn vào MySQL. Trong scaffold có mẫu script import để bạn tham khảo.

 Tôi có thể hỗ trợ thêm:
 - Thêm cấu hình Alembic và migration khởi tạo.
 - Viết script export/import dữ liệu Firestore -> MySQL (cần service account credentials).
 - Triển khai endpoint xác thực (register/login) và flow JWT nếu bạn muốn chuyển hoàn toàn khỏi Firebase.
