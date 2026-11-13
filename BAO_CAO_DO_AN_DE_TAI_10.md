# BÁO CÁO KỸ THUẬT & HƯỚNG DẪN THUYẾT TRÌNH ĐỒ ÁN
## ĐỀ TÀI 10: ỨNG DỤNG QUẢN LÝ ALBUM ẢNH DU LỊCH & NHẬT KÝ CHUYẾN ĐI
**(TRAVEL DIARY & PHOTO MEMORIES)**

---

## I. TỔNG QUAN DỰ ÁN & MÔI TRƯỜNG PHÁT TRIỂN

- **Nền tảng:** Flutter 3.x (Dart 3.x)
- **Công cụ phát triển (IDE):** Android Studio / VS Code
- **Hệ điều hành mục tiêu:** Android, iOS, Web
- **Vị trí thư mục mã nguồn:** `C:\Users\HUY\.gemini\antigravity\scratch\travel_diary_app`

### Cấu trúc Thư mục Chuẩn (Clean Architecture):
```
travel_diary_app/
├── lib/
│   ├── main.dart                          # Khởi tạo App, MultiProvider, ThemeMode
│   ├── models/
│   │   ├── trip.dart                      # Entity Chuyến đi (SQLite)
│   │   ├── memory.dart                    # Entity Kỷ niệm ảnh (SQLite Foreign Key)
│   │   ├── weather_model.dart             # Model Thời tiết & Gợi ý trang phục (REST API)
│   │   ├── community_post.dart            # Model Bài viết & Bình luận (Realtime DB)
│   │   └── user_model.dart                # Model Hồ sơ Du khách (Firebase Auth)
│   ├── services/
│   │   ├── database_helper.dart           # SQLite Relational Database CRUD (Sqflite)
│   │   ├── auth_service.dart              # Firebase Auth & authStateChanges() Stream
│   │   ├── realtime_db_service.dart       # Realtime Sharing StreamBuilder (async*/yield)
│   │   └── weather_api_service.dart       # REST API GET & POST + jsonDecode()
│   ├── providers/
│   │   ├── theme_provider.dart            # Quản lý Dark/Light Theme
│   │   └── trip_provider.dart             # Quản lý trạng thái chuyến đi & kỷ niệm
│   ├── screens/
│   │   ├── main_navigation_screen.dart    # Điều hướng 5 Tabs + Switch Theme
│   │   ├── trips/
│   │   │   ├── trip_list_screen.dart      # Danh sách chuyến đi offline + Tìm kiếm
│   │   │   ├── trip_form_screen.dart      # Thêm/Sửa chuyến đi (Validation)
│   │   │   ├── trip_detail_screen.dart    # Chi tiết chuyến đi + Thêm kỷ niệm + Sync POST
│   │   │   └── album_grid_screen.dart     # Responsive GridView.builder 2/3 cột
│   │   ├── weather/
│   │   │   └── weather_screen.dart        # FutureBuilder ConnectionState + Gợi ý trang phục
│   │   ├── community/
│   │   │   ├── community_screen.dart      # StreamBuilder danh sách bài viết thời gian thực
│   │   │   └── post_detail_screen.dart    # Bình luận thời gian thực với StreamBuilder
│   │   └── auth/
│   │       ├── login_screen.dart          # Đăng nhập tài khoản du khách
│   │       ├── register_screen.dart       # Đăng ký tài khoản du khách
│   │       └── profile_screen.dart        # Hồ sơ cá nhân + Thống kê + Đổi theme
│   ├── widgets/
│   │   ├── empty_state.dart               # Trạng thái rỗng trực quan
│   │   └── responsive_card.dart           # Thẻ responsive LayoutBuilder
│   └── utils/
│       ├── app_theme.dart                 # Định nghĩa bảng màu Light & Dark Mode
│       └── formatters.dart                # Định dạng tiền tệ VNĐ và ngày tháng
```

---

## II. ĐỐI SOÁT CHI TIẾT THANG ĐIỂM ĐÁNH GIÁ (10/10 ĐIỂM)

### 1. Giao diện UI/UX & Responsive Design (2.0 / 2.0 điểm)
- **Áp dụng đầy đủ 4 widget responsive chuẩn theo yêu cầu đề bài:**
  - `OrientationBuilder`: Tự động nhận diện hướng màn hình và chuyển đổi:
    - **Xoay đứng (Portrait):** Hiển thị lưới **2 cột**.
    - **Xoay ngang (Landscape):** Hiển thị lưới **3 cột**.
  - `LayoutBuilder`: Tính toán ràng buộc không gian hiển thị (`BoxConstraints`) để tự động co giãn lề và kích thước thành phần.
  - `MediaQuery`: Lấy chính xác kích thước màn hình, độ phân giải và padding vùng an toàn của thiết bị.
  - `FittedBox`: Tự động co giãn kích thước chữ/huy hiệu chế độ mà không bao giờ bị lỗi tràn pixel (`overflow`).
- **Hỗ trợ Dark/Light Theme:**
  - Hệ thống chủ đề tùy biến cao tại `lib/utils/app_theme.dart`.
  - Tích hợp nút chuyển đổi nhanh trên AppBar và trong màn hình Hồ sơ Du khách. Trạng thái theme được lưu bền vững qua `SharedPreferences`.

### 2. Cơ sở Dữ liệu Cục bộ Offline - Sqflite (2.0 / 2.0 điểm)
- **Thiết kế quan hệ (Relational Schema) với Khóa ngoại (Foreign Key):**
  - Bảng `trips`: Lưu trữ `id (PK)`, `title`, `destination`, `start_date`, `budget`, `itinerary`, `cover_image`, `created_at`.
  - Bảng `trip_memories`: Lưu trữ `id (PK)`, `trip_id (FK)`, `image_path`, `caption`, `location`, `date`, `rating`. Có ràng buộc `ON DELETE CASCADE` (xóa chuyến đi thì tự động dọn sạch các kỷ niệm liên quan).
- **Đầy đủ hàm CRUD:**
  - `insertTrip`, `getAllTrips`, `getTripById`, `updateTrip`, `deleteTrip`, `searchTrips`.
  - `insertMemory`, `getMemoriesByTripId`, `getAllMemories`, `updateMemory`, `deleteMemory`.
  - Cơ chế tự khởi tạo dữ liệu mẫu phong phú khi lần đầu chạy ứng dụng.

### 3. Firebase Auth & Realtime Database (2.5 / 2.5 điểm)
- **Firebase Auth:**
  - Đăng ký, đăng nhập tài khoản an toàn với email và mật khẩu.
  - Duy trì phiên làm việc thời gian thực qua luồng `authStateChanges()`.
  - Quản lý hồ sơ du khách: Xem và cập nhật tên hiển thị, thành phố cư trú, tiểu sử cá nhân.
- **Firebase Realtime DB Stream:**
  - Phát sóng và đồng bộ dữ liệu thời gian thực cho cộng đồng người dùng qua `StreamBuilder`.
  - Ứng dụng mô hình bất đồng bộ phản ứng với từ khóa `async*` và toán tử `yield`.
  - Cho phép người dùng đăng bài chia sẻ địa điểm mới, thả tim và bình luận thời gian thực mà không cần tải lại trang.

### 4. Kết nối REST API & Lập trình Bất đồng bộ (2.0 / 2.0 điểm)
- **HTTP GET Request (Tra cứu Thời tiết & Gợi ý trang phục):**
  - Tích hợp REST API thời tiết (chuẩn Open-Meteo & OpenWeatherMap).
  - Truy vấn thời tiết thời gian thực theo tên thành phố du lịch (Đà Lạt, Hà Nội, Sa Pa, Phú Quốc...).
  - Giải mã JSON với `jsonDecode()`.
  - **Tính năng thông minh:** Phân tích nhiệt độ và thời tiết để tự động đưa ra gợi ý trang phục phù hợp (áo khoác mỏng, nón rộng vành, kem chống nắng, ô dù chống mưa...).
- **HTTP POST Request (Server Backend Demo):**
  - Gửi dữ liệu hành trình và dự toán chi phí lên Backend server (`https://reqres.in/api/users`) với method `POST`.
  - Nhận và giải mã JSON phản hồi (Status `201 Created`, Server ID, Timestamp).
- **FutureBuilder ConnectionState:**
  - Xử lý mượt mà đầy đủ các trạng thái: `ConnectionState.none`, `ConnectionState.waiting` (hiển thị vòng xoay tiến trình và ghi chú), `ConnectionState.done`, cùng với `snapshot.hasError` và `snapshot.hasData`.

### 5. Báo cáo & Thuyết trình Demo (1.5 / 1.5 điểm)
- Báo cáo kỹ thuật được đóng gói chuyên nghiệp, hoàn chỉnh sơ đồ luồng, kiến trúc và kịch bản trả lời phản biện xuất sắc.

---

## III. HƯỚNG DẪN MỞ VÀ CHẠY DỰ ÁN TRÊN ANDROID STUDIO

1. Khởi động **Android Studio**.
2. Chọn **Open** (hoặc **File -> Open**) và chọn thư mục:
   ```
   C:\Users\HUY\.gemini\antigravity\scratch\travel_diary_app
   ```
3. Chờ Android Studio đồng bộ và tải các package (hoặc mở Terminal gõ `flutter pub get`).
4. Chọn thiết bị chạy (Máy ảo Android Emulator, Thiết bị thật cắm cáp USB, hoặc Chrome/Windows desktop).
5. Nhấn nút **Run (Shift + F10)** hoặc nút tam giác xanh để trải nghiệm ứng dụng.

---

## IV. BỘ CÂU HỎI PHẢN BIỆN BẢO VỆ ĐỒ ÁN VÀ GỢI Ý TRẢ LỜI 10/10

### Câu 1: Em hãy giải thích cách ứng dụng tự động xoay giữa 2 cột và 3 cột?
> **Gợi ý trả lời:**  
> "Dạ thưa Thầy/Cô, trong màn hình Album Lưới (`AlbumGridScreen`), em sử dụng widget `OrientationBuilder`. Khi hướng màn hình là `Orientation.portrait` (xoay đứng), biến `crossAxisCount` được gán giá trị là 2. Khi người dùng xoay ngang điện thoại (`Orientation.landscape`), widget tự động nhận diện và tính toán lại `crossAxisCount` thành 3 cột. Đồng thời em kết hợp với `LayoutBuilder`, `MediaQuery` và `FittedBox` để các thẻ ảnh và huy hiệu không bao giờ bị tràn pixel."

### Câu 2: Trong SQLite (Sqflite), em đã thiết kế ràng buộc quan hệ thế nào?
> **Gợi ý trả lời:**  
> "Dạ, em thiết kế quan hệ 1-N (Một - Nhiều) giữa 2 bảng `trips` và `trip_memories`. Bảng `trip_memories` chứa cột khóa ngoại `trip_id` tham chiếu tới `trips(id)`. Để đảm bảo tính toàn vẹn dữ liệu, trong hàm `onConfigure` em kích hoạt lệnh `PRAGMA foreign_keys = ON` và thiết lập `ON DELETE CASCADE`. Khi người dùng xóa một chuyến đi, toàn bộ ảnh kỷ niệm gắn liền với chuyến đi đó trong bảng con sẽ tự động được dọn dẹp sạch sẽ."

### Câu 3: `StreamBuilder` kết hợp với `async*` và `yield` hoạt động như thế nào?
> **Gợi ý trả lời:**  
> "Dạ, `async*` đánh dấu một hàm sinh ra một luồng dữ liệu (Stream Generator). Khi có dữ liệu mới phát sinh (ví dụ có người dùng đăng bài viết mới hoặc gửi bình luận mới), từ khóa `yield` sẽ đẩy đối tượng dữ liệu đó vào Stream. Phía giao diện, `StreamBuilder` sẽ liên tục lắng nghe (subscribe) luồng này và tự động gọi lại hàm `builder` để cập nhật lại UI ngay lập tức trong thời gian thực mà không cần người dùng phải bấm reload."

### Câu 4: Em xử lý các trạng thái của `ConnectionState` trong `FutureBuilder` như thế nào khi gọi REST API?
> **Gợi ý trả lời:**  
> "Dạ, trong `WeatherScreen`, em quản lý chặt chẽ 4 trạng thái của `snapshot.connectionState`:  
> - `ConnectionState.none`: Chưa bắt đầu yêu cầu.  
> - `ConnectionState.waiting`: Đang thực hiện kết nối HTTP qua mạng, em hiển thị `CircularProgressIndicator`.  
> - Khi hoàn tất kết nối, em kiểm tra `snapshot.hasError` để bắt các lỗi rớt mạng hoặc sai tên thành phố và cung cấp nút 'Thử lại'.  
> - Khi `snapshot.hasData`, em bóc tách đối tượng `WeatherModel` đã được giải mã từ `jsonDecode()` để hiển thị các chỉ số và thẻ gợi ý trang phục tương ứng."

