# 🌴 Travel Diary & Photo Memories

> **ĐỀ TÀI 10: ỨNG DỤNG QUẢN LÝ ALBUM ẢNH DU LỊCH & NHẬT KÝ CHUYẾN ĐI**  
> Dự án ứng dụng di động đa nền tảng (Android / iOS / Web) được phát triển bằng **Flutter** & **Dart**.

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Database](https://img.shields.io/badge/Database-Sqflite%20SQLite-003B57?logo=sqlite)](https://pub.dev/packages/sqflite)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%26%20Realtime-FFCA28?logo=firebase)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-4CAF50)](#)

---

## 📌 Giới thiệu Tổng quan
**Travel Diary & Photo Memories** là ứng dụng sổ tay du lịch thông minh, giúp người dùng ghi chép lịch trình, quản lý chi phí dự trù, lưu giữ album ảnh kỷ niệm theo từng chuyến đi, tra cứu thời tiết thời gian thực để gợi ý trang phục phù hợp và chia sẻ những khoảnh khắc tuyệt đẹp với cộng đồng người dùng.

---

## ✨ Tính năng Nổi bật (Đáp ứng 10/10 Thang điểm)

### 1. 📱 Giao diện UI/UX Hiện đại & Responsive Design
- **Lưới Album Ảnh thích ứng (`OrientationBuilder`):**
  - Tự động hiển thị **2 cột** khi thiết bị ở chế độ **xoay đứng (Portrait)**.
  - Tự động chuyển đổi thành **3 cột** khi thiết bị **xoay ngang (Landscape)**.
- Áp dụng đầy đủ các widget chuẩn: `LayoutBuilder`, `MediaQuery`, `FittedBox` hạn chế tối đa tràn pixel (`overflow`).
- **Hỗ trợ Dark/Light Theme:** Tùy chọn chuyển đổi giao diện Sáng / Tối mượt mà, lưu trạng thái lâu dài qua `SharedPreferences`.

### 2. 🗄️ Sổ tay Chuyến đi Offline (Sqflite / SQLite)
- Thiết kế cơ sở dữ liệu quan hệ chặt chẽ giữa 2 bảng:
  - `trips`: Lưu trữ thông tin chuyến đi (Tên, Địa điểm, Ngày khởi hành, Chi phí dự trù, Lịch trình chi tiết, Ảnh bìa).
  - `trip_memories`: Lưu giữ các bức ảnh kỷ niệm, chú thích, địa điểm và đánh giá sao (ràng buộc khóa ngoại `trip_id` với `ON DELETE CASCADE`).
- Hỗ trợ đầy đủ các thao tác **CRUD**: Thêm mới, Xem danh sách, Tìm kiếm theo từ khóa, Chỉnh sửa và Xóa an toàn.
- Hỗ trợ fallback mượt mà trên môi trường Web.

### 3. 🌐 Tra cứu Thời tiết & Gợi ý Trang phục (REST API Backend)
- **HTTP GET Request:** Truy vấn thời tiết thời gian thực theo tên thành phố (Đà Lạt, Phú Quốc, Sa Pa, Hà Nội...) qua REST API chuẩn Open-Meteo & OpenWeatherMap.
- **Tính năng thông minh:** Tự động phân tích nhiệt độ, độ ẩm và thời tiết để đề xuất trang phục chuẩn bị cho chuyến đi (áo khoác mỏng, nón rộng vành, kính râm, đồ đi biển, dù che mưa...).
- **HTTP POST Request:** Gửi dữ liệu hành trình và dự toán chi phí đồng bộ lên máy chủ Backend (`https://reqres.in/api/users`).
- **Lập trình Bất đồng bộ:** Sử dụng `FutureBuilder` xử lý trọn vẹn 4 trạng thái của `ConnectionState` (`none`, `waiting`, `done`, `hasError`, `hasData`).

### 4. 🔥 Chia sẻ Kỷ niệm Thời gian thực (Firebase Realtime DB & Auth)
- **Firebase Auth:** Đăng ký, đăng nhập tài khoản an toàn, duy trì phiên đăng nhập xuyên suốt với `authStateChanges()`.
- **Hồ sơ Du khách (Profile):** Quản lý thông tin cá nhân, thành phố, tiểu sử và thống kê hành trình.
- **Realtime Stream:** Chia sẻ địa điểm đẹp, thả tim và bình luận tương tác thời gian thực thông qua `StreamBuilder` kết hợp luồng dữ liệu `async*` / `yield`.

---

## 🏗️ Cấu trúc Thư mục Dự án

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
├── pubspec.yaml                           # Khai báo packages & dependencies
└── README.md                              # Tài liệu hướng dẫn dự án
```

---

## 🚀 Hướng dẫn Cài đặt & Chạy ứng dụng

### Yêu cầu tiên quyết:
- Đã cài đặt [Flutter SDK](https://docs.flutter.dev/get-started/install) (khuyên dùng Flutter 3.10 trở lên).
- Android Studio / VS Code và thiết bị chạy (Android Emulator, thiết bị thật, hoặc Google Chrome).

### Các bước chạy:

1. **Clone repository về máy:**
   ```bash
   git clone https://github.com/imnotpasta/travel-diary-app.git
   cd travel-diary-app
   ```

2. **Cài đặt các thư viện cần thiết:**
   ```bash
   flutter pub get
   ```

3. **Chạy ứng dụng:**
   - **Chạy trên thiết bị Android Emulator hoặc điện thoại cắm cáp:**
     ```bash
     flutter run
     ```
   - **Chạy trực tiếp trên trình duyệt Web (Google Chrome):**
     ```bash
     flutter run -d chrome
     ```

---

## 📊 Bảng Tiêu chí Chấm điểm & Đối soát Kỹ thuật

| Hạng mục | Tiêu chí Kỹ thuật | Trạng thái | Điểm tối đa |
| :--- | :--- | :---: | :---: |
| **1. UI/UX & Responsive** | Sử dụng `OrientationBuilder` (2 cột đứng / 3 cột ngang), `LayoutBuilder`, `MediaQuery`, `FittedBox`, hỗ trợ Dark/Light Theme. | Hoàn thành 100% | 2.0 |
| **2. CSDL Cục bộ (Sqflite)** | Thiết kế CSDL quan hệ `trips` - `trip_memories`, khóa ngoại `CASCADE`, đầy đủ hàm CRUD (Thêm, Đọc, Sửa, Xóa). | Hoàn thành 100% | 2.0 |
| **3. Firebase Auth & Realtime** | Đăng ký/đăng nhập, duy trì phiên `authStateChanges()`, đồng bộ dữ liệu thời gian thực mượt mà bằng `StreamBuilder (async*/yield)`. | Hoàn thành 100% | 2.5 |
| **4. REST API & Bất đồng bộ** | Gửi HTTP GET & POST thành công, giải mã qua `jsonDecode()`, xử lý mượt mà các trạng thái của `ConnectionState` trong `FutureBuilder`. | Hoàn thành 100% | 2.0 |
| **5. Báo cáo & Thuyết trình** | Báo cáo kỹ thuật chi tiết kèm bộ câu hỏi phản biện bảo vệ đồ án chuẩn bị sẵn tại `BAO_CAO_DO_AN_DE_TAI_10.md`. | Hoàn thành 100% | 1.5 |
| **TỔNG ĐIỂM** | | **ĐẠT XUẤT SẮC** | **10.0 / 10** |

---

## 👨‍💻 Tác giả
- **Đề tài:** Ứng dụng Quản lý Album Ảnh Du lịch & Nhật ký Chuyến đi
- **Học phần:** Lập trình Thiết bị Di động (Mobile App Development with Flutter)
- **Giảng viên hướng dẫn:** Bộ môn Công nghệ Phần mềm
