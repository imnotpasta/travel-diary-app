# KỊCH BẢN THUYẾT TRÌNH POWERPOINT BẢN CHỮ TO (14 SLIDES)
## ĐỀ TÀI 10: ỨNG DỤNG QUẢN LÝ ALBUM ẢNH DU LỊCH & NHẬT KÝ CHUYẾN ĐI
**(TRAVEL DIARY & PHOTO MEMORIES)**

> 📁 **File PowerPoint:** [Bao_Cao_De_Tai_10_BigFont.pptx](file:///E:/Projects/travel_diary_app/Bao_Cao_De_Tai_10_BigFont.pptx) *(hoặc [Bao_Cao_De_Tai_10_Travel_Diary.pptx](file:///E:/Projects/travel_diary_app/Bao_Cao_De_Tai_10_Travel_Diary.pptx))*  
> *Được thiết kế 14 slide chữ to (18pt - 36pt), ít chữ, bố cục thẻ nổi bật, trực quan và không chứa ảnh chụp rườm rà để bạn tập trung demo trực tiếp ứng dụng.*

---

## NỘI DUNG TỪNG SLIDE & LỜI THOẠI THUYẾT TRÌNH (10/10 ĐIỂM)

### 📌 SLIDE 1: TRANG TIÊU ĐỀ
- **Cỡ chữ:** Tiêu đề 36pt, Tiêu đề phụ 26pt.
- **Nội dung:** Tên đề tài 10, sinh viên thực hiện, giảng viên hướng dẫn.
- **Lời thoại:** *"Kính chào Quý Thầy/Cô. Em xin đại diện nhóm trình bày báo cáo Đề tài 10: Ứng dụng Quản lý Album Ảnh Du lịch và Nhật ký Chuyến đi bằng Flutter và Dart."*

---

### 📌 SLIDE 2: THỰC TRẠNG & VẤN ĐỀ
- **Cỡ chữ:** Đầu mục 20pt, diễn giải 17pt.
- **Nội dung:** 4 khó khăn thực tế: Mất mạng khi đi du lịch, Chi phí dự trù phân tán, Ảnh kỷ niệm lộn xộn, Bất ngờ về thời tiết.
- **Lời thoại:** *"Xuất phát từ thực tế du khách thường bị mất sóng khi đi du lịch và gặp khó khăn trong việc quản lý ngân sách cũng như chuẩn bị đồ đạc theo thời tiết..."*

---

### 📌 SLIDE 3: GIẢI PHÁP ỨNG DỤNG TRAVEL DIARY
- **Cỡ chữ:** Đầu mục 20pt, diễn giải 17pt.
- **Nội dung:** Sổ tay Offline SQLite 100%, Tra cứu thời tiết REST API thông minh, Mạng xã hội realtime Stream, Giao diện Responsive.
- **Lời thoại:** *"Ứng dụng Travel Diary giải quyết triệt để vấn đề trên nhờ cơ chế lưu trữ offline không phụ thuộc internet, gợi ý trang phục tự động và kết nối chia sẻ cộng đồng."*

---

### 📌 SLIDE 4: KIẾN TRÚC HỆ THỐNG CLEAN ARCHITECTURE
- **Cỡ chữ:** 18pt & 15pt cho 4 tầng rõ ràng.
- **Nội dung:** Presentation Layer ➔ State Management ➔ Service Layer ➔ Data & External Layer.
- **Lời thoại:** *"Mã nguồn được tổ chức theo kiến trúc Clean Architecture phân tầng độc lập, giúp ứng dụng vận hành ổn định và dễ dàng mở rộng."*

---

### 📌 SLIDE 5: TIÊU CHÍ 1 - BỘ 4 WIDGET RESPONSIVE
- **Cỡ chữ:** Tiêu đề card 20pt, nội dung 16pt.
- **Nội dung:** `OrientationBuilder`, `LayoutBuilder`, `MediaQuery`, `FittedBox`.
- **Lời thoại:** *"Ở tiêu chí Responsive (2.0 điểm), em ứng dụng trọn vẹn 4 widget chuẩn: OrientationBuilder xoay màn hình, LayoutBuilder và MediaQuery đo đạc kích thước và FittedBox triệt tiêu hoàn toàn lỗi tràn pixel."*

---

### 📌 SLIDE 6: TIÊU CHÍ 1 - LƯỚI ALBUM 2/3 CỘT & DARK/LIGHT THEME
- **Cỡ chữ:** Đầu mục 21pt/18pt, diễn giải 16pt.
- **Nội dung:** Xoay đứng (Portrait) hiển thị 2 cột, Xoay ngang (Landscape) hiển thị 3 cột; Chế độ Sáng / Tối lưu bền vững vào `SharedPreferences`.
- **Lời thoại:** *"Đặc biệt, lưới album ảnh tự động thích ứng: xoay đứng 2 cột, xoay ngang 3 cột mượt mà. Ứng dụng cũng hỗ trợ chuyển đổi Dark / Light Theme bảo vệ mắt."*

---

### 📌 SLIDE 7: TIÊU CHÍ 2 - THIẾT KẾ CSDL QUAN HỆ SQFLITE
- **Cỡ chữ:** Tiêu đề 20pt, cột bảng 16pt.
- **Nội dung:** Bảng `trips` liên kết bảng `trip_memories` qua Khóa ngoại `trip_id` với ràng buộc toàn vẹn `ON DELETE CASCADE`.
- **Lời thoại:** *"Tại CSDL cục bộ (2.0 điểm), em thiết kế quan hệ 1-N. Ràng buộc CASCADE đảm bảo khi xóa chuyến đi thì toàn bộ ảnh kỷ niệm liên quan sẽ tự động được dọn dẹp sạch sẽ."*

---

### 📌 SLIDE 8: TIÊU CHÍ 2 - ĐẦY ĐỦ 4 HÀM CRUD
- **Cỡ chữ:** Tiêu đề 19pt, tên hàm 16pt.
- **Nội dung:** Thêm mới (Create), Tìm kiếm nhanh (Read với `LIKE %keyword%`), Chỉnh sửa (Update), Xóa an toàn (Delete kèm `AlertDialog`).
- **Lời thoại:** *"Tất cả các thao tác Thêm, Đọc, Sửa, Xóa và Tìm kiếm tức thì đều được xây dựng hoàn chỉnh và kiểm thử chặt chẽ."*

---

### 📌 SLIDE 9: TIÊU CHÍ 3 - FIREBASE AUTH & HỒ SƠ DU KHÁCH
- **Cỡ chữ:** Đầu mục 20pt, diễn giải 17pt.
- **Nội dung:** Đăng ký/đăng nhập Email & Mật khẩu bảo mật, Duy trì phiên liên tục với `authStateChanges()`, Quản lý hồ sơ cá nhân.
- **Lời thoại:** *"Ở tiêu chí Firebase (2.5 điểm), hệ thống xác thực người dùng an toàn và duy trì phiên đăng nhập xuyên suốt bằng Stream authStateChanges()."*

---

### 📌 SLIDE 10: TIÊU CHÍ 3 - ĐỒNG BỘ REALTIME STREAM (ASYNC* / YIELD)
- **Cỡ chữ:** Đầu mục 20pt, diễn giải 17pt.
- **Nội dung:** Mô hình phản ứng bất đồng bộ với cú pháp `async*` và toán tử `yield`, `StreamBuilder` tự render lại UI tức thì khi có bài viết hoặc bình luận mới.
- **Lời thoại:** *"Tính năng chia sẻ cộng đồng ứng dụng cú pháp async* và yield. Khi có dữ liệu mới phát sinh, StreamBuilder lập tức cập nhật giao diện thời gian thực mà không cần reload trang."*

---

### 📌 SLIDE 11: TIÊU CHÍ 4 - REST API HTTP GET & GỢI Ý TRANG PHỤC
- **Cỡ chữ:** Đầu mục 20pt, diễn giải 17pt.
- **Nội dung:** Gửi HTTP GET lấy thời tiết theo thành phố, giải mã JSON với `jsonDecode()`, thuật toán gợi ý đồ mặc theo nhiệt độ (nắng nóng, se lạnh, mưa...).
- **Lời thoại:** *"Về REST API (2.0 điểm), ứng dụng gửi HTTP GET tra cứu thời tiết và tự động đưa ra gợi ý trang phục thông minh hỗ trợ chuyến đi."*

---

### 📌 SLIDE 12: TIÊU CHÍ 4 - REST API HTTP POST & CONNECTIONSTATE
- **Cỡ chữ:** Đầu mục 20pt/18pt, diễn giải 16pt.
- **Nội dung:** Gửi HTTP POST đồng bộ hành trình lên máy chủ ReqRes.in (mã 201 Created); `FutureBuilder` xử lý trọn vẹn 4 trạng thái `none`, `waiting`, `done`, `hasError`.
- **Lời thoại:** *"Đồng thời ứng dụng gửi HTTP POST lên Backend ReqRes.in và xử lý mượt mà cả 4 trạng thái ConnectionState trong FutureBuilder."*

---

### 📌 SLIDE 13: KỊCH BẢN THAO TÁC DEMO TRỰC TIẾP
- **Cỡ chữ:** Đầu mục 19pt, hướng dẫn 16pt.
- **Nội dung:** 5 bước demo: 1. Thêm chuyến đi ➔ 2. Xoay màn hình 2/3 cột ➔ 3. Tra cứu thời tiết & xem đồ gợi ý ➔ 4. Bình luận realtime ➔ 5. Đổi Dark Mode.
- **Lời thoại:** *"Sau đây, em xin phép mở ứng dụng chạy demo trực tiếp cả 5 luồng tính năng trên thiết bị để Quý Thầy/Cô cùng kiểm tra..."*

---

### 📌 SLIDE 14: LỜI CẢM ƠN & KẾT THÚC
- **Cỡ chữ:** 36pt & 20pt nổi bật.
- **Lời thoại:** *"Em xin trân trọng cảm ơn Quý Thầy/Cô đã lắng nghe và đánh giá đồ án. Nhóm rất mong nhận được những góp ý quý báu từ Hội đồng!"*
