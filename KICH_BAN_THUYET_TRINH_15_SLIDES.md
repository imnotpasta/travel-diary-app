# KỊCH BẢN THUYẾT TRÌNH BÁO CÁO ĐỒ ÁN POWERPOINT (15 SLIDES)
## ĐỀ TÀI 10: TRAVEL DIARY APP - SỔ TAY DU LỊCH & KẾT NỐI CỘNG ĐỒNG

> 📁 **File PowerPoint hoàn chỉnh (Đã chèn 15 ảnh to rõ):**  
> • [Bao_Cao_De_Tai_10_Thuyet_Trinh.pptx](file:///E:/Projects/travel_diary_app/Bao_Cao_De_Tai_10_Thuyet_Trinh.pptx)  
> • [Bao_Cao_De_Tai_10_Travel_Diary.pptx](file:///E:/Projects/travel_diary_app/Bao_Cao_De_Tai_10_Travel_Diary.pptx)  
> *(Tỉ lệ chuẩn 16:9 Widescreen, nền Dark Slate 900, điểm nhấn Cyan/Teal/Amber, ảnh chụp thực tế sắc nét, chữ lớn 16pt - 44pt)*

---

## 🎙️ LỜI THOẠI GỢI Ý CHI TIẾT CHO TỪNG SLIDE (DỰNG SẴN 10/10 ĐIỂM)

### 📌 SLIDE 1: TRANG TIÊU ĐỀ (TITLE SLIDE)
* **Nội dung slide:** Tiêu đề đồ án "TRAVEL DIARY APP", nhóm Đề tài 10, nền tảng Flutter/Dart, Clean Architecture.
* **Lời thoại gợi ý:**  
  > *"Kính chào Quý Thầy/Cô và các bạn sinh viên trong Hội đồng chấm đồ án Lập trình Thiết bị Di động. Hôm nay, em xin đại diện nhóm trình bày báo cáo Đồ án Đề tài 10: **Travel Diary App - Ứng dụng Nhật ký Du lịch Thông minh và Kết nối Cộng đồng**. Đồ án được xây dựng trên nền tảng Flutter đa nền tảng, tích hợp đồng thời cơ sở dữ liệu cục bộ SQLite, điện toán đám mây Firebase và dịch vụ REST API."*

---

### 📌 SLIDE 2: TỔNG QUAN KIẾN TRÚC CLEAN ARCHITECTURE & 3 TRỤ CỘT KỸ THUẬT
* **Nội dung slide:** 3 trụ cột kỹ thuật: UI/UX Presentation (Material 3, Responsive), Local Storage (SQLite Offline), Cloud & Services (Firebase Auth, RTDB, Weather REST API).
* **Lời thoại gợi ý:**  
  > *"Để đảm bảo tính mở rộng và dễ bảo trì, ứng dụng được kiến trúc theo mô hình Clean Architecture chuẩn mực với 3 trụ cột kỹ thuật: Trụ cột 1 là tầng Presentation với giao diện thích ứng đa màn hình; Trụ cột 2 là tầng dữ liệu cục bộ SQLite giúp ứng dụng hoạt động ngoại tuyến 100% khi đi du lịch vùng không có sóng; và Trụ cột 3 là đám mây Firebase kết hợp REST API thời tiết để chia sẻ và gợi ý thông minh."*

---

### 📌 SLIDE 3: TIÊU CHÍ 1 - GIAO DIỆN THÍCH ỨNG DỌC (RESPONSIVE 2 CỘT)
* **Ảnh minh họa:** `Screenshot_...15-38-51` (Màn hình Album Grid dọc - Badge "2 Cột (Đứng)").
* **Lời thoại gợi ý:**  
  > *"Đến với Tiêu chí 1 về Giao diện thích ứng (Responsive): Trên màn hình Album Kỷ niệm, nhóm em sử dụng widget `OrientationBuilder` để nhận diện góc xoay thiết bị trong thời gian thực. Khi người dùng cầm điện thoại ở chế độ màn hình dọc thông thường, giao diện tự động sắp xếp dạng lưới 2 cột chuẩn tỉ lệ, có gắn huy hiệu '2 Cột (Đứng)' rõ ràng, tối ưu hoàn hảo cho thao tác vuốt lướt bằng một tay."*

---

### 📌 SLIDE 4: TIÊU CHÍ 1 - GIAO DIỆN THÍCH ỨNG XOAY NGANG (RESPONSIVE 3 CỘT)
* **Ảnh minh họa:** `Screenshot_...15-39-04` (Màn hình Album Grid xoay ngang - Badge "3 Cột (Ngang)").
* **Lời thoại gợi ý:**  
  > *"Khi người dùng xoay ngang điện thoại hoặc sử dụng trên máy tính bảng, `OrientationBuilder` ngay lập tức tính toán lại và mở rộng lưới thành 3 cột ngang. Toàn bộ kích thước khung ảnh được co giãn mượt mà, hoàn toàn không xảy ra lỗi tràn viền (Zero Overflow), tận dụng tối đa chiều rộng của màn hình để hiển thị được nhiều khoảnh khắc du lịch hơn."*

---

### 📌 SLIDE 5: TIÊU CHÍ 1 - GIAO DIỆN KÉP SÁNG & TỐI (LIGHT MODE & DARK MODE)
* **Ảnh minh họa:** `Screenshot_...15-39-19` (Light) và `Screenshot_...15-39-23` (Dark) đặt song song.
* **Lời thoại gợi ý:**  
  > *"Bên cạnh tính năng Responsive, nhóm phát triển tính năng Chuyển đổi giao diện Sáng - Tối (Light & Dark Mode) tức thì ngay tại trang Hồ sơ cá nhân. Bảng màu được thiết kế theo tiêu chuẩn Material Design 3: nền Dark Slate 900 có độ tương phản cao, bảo vệ thị giác khi tra cứu lịch trình ban đêm và tiết kiệm pin tối đa cho màn hình OLED/AMOLED."*

---

### 📌 SLIDE 6: TIÊU CHÍ 2 - SỔ TAY OFFLINE SQLITE & TÌM KIẾM TỨC THÌ
* **Ảnh minh họa:** `Screenshot_...15-39-43` (Danh sách Chuyến đi + Thanh tìm kiếm lọc từ khóa "đà").
* **Lời thoại gợi ý:**  
  > *"Bước sang Tiêu chí 2 về Cơ sở dữ liệu cục bộ: Nhóm đã tích hợp SQLite Engine độc lập trên thiết bị. Mọi chuyến đi, chi phí dự trù và thời gian đều được lưu bền vững. Tính năng tìm kiếm tức thì (Instant Search) lọc dữ liệu ngay khi người dùng gõ từng ký tự. Như Thầy/Cô thấy trên slide, khi gõ từ khóa 'đà', ứng dụng lập tức truy vấn và lọc ra chuyến đi 'Khám phá Đà Lạt' với tốc độ dưới 16ms."*

---

### 📌 SLIDE 7: TIÊU CHÍ 2 - BIỂU MẪU NHẬP LIỆU & BỘ CHỌN ẢNH THIẾT BỊ (IMAGE PICKER)
* **Ảnh minh họa:** `Screenshot_...15-40-13` (Form Thêm chuyến đi + Bottom Sheet chọn Camera/Thư viện).
* **Lời thoại gợi ý:**  
  > *"Để quản lý chuyến đi, màn hình Tạo chuyến đi áp dụng Form Validation chặt chẽ, kiểm tra tính hợp lệ của tên điểm đến, ngày khởi hành và chi phí. Nhóm tích hợp plugin `image_picker` cho phép người dùng lựa chọn linh hoạt: chụp ảnh mới trực tiếp từ Camera hoặc tải ảnh có sẵn từ Thư viện máy. Ảnh sau khi chọn được nén và xử lý tối ưu bộ nhớ."*

---

### 📌 SLIDE 8: TIÊU CHÍ 3 - XÁC THỰC NGƯỜI DÙNG FIREBASE AUTHENTICATION
* **Ảnh minh họa:** `Screenshot_...15-56-16` (Login Screen) + `Screenshot ...154937.png` (Firebase Auth Console).
* **Lời thoại gợi ý:**  
  > *"Về Tiêu chí 3 - Kết nối Đám mây: Hệ thống xác thực được bảo vệ bởi Firebase Authentication SDK. Phiên đăng nhập được quản lý bằng JWT Token và lắng nghe qua Stream. Trên giao diện đăng nhập, nhóm đã cung cấp sẵn tài khoản demo `traveler@vietnam.com`. Ảnh bên phải là minh chứng thực tế trên bảng điều khiển Firebase Console với 4 tài khoản người dùng đã được đăng ký và quản lý tập trung."*

---

### 📌 SLIDE 9: TIÊU CHÍ 3 - BẢNG TIN KỶ NIỆM THỜI GIAN THỰC (COMMUNITY FEED)
* **Ảnh minh họa:** `Screenshot_...15-43-07` (Bảng tin bài viết cộng đồng, địa điểm Làng Cù Lần, nút thả tim).
* **Lời thoại gợi ý:**  
  > *"Sau khi đăng nhập, người dùng có thể truy cập Bảng tin Cộng đồng. Điểm đặc biệt là toàn bộ dữ liệu bài viết được đồng bộ thời gian thực qua Firebase Realtime Database Stream. Khi một thành viên bất kỳ đăng tải kỷ niệm du lịch mới, bài viết sẽ tự động xuất hiện ngay trên thiết bị của các thành viên khác mà không cần thực hiện thao tác kéo tải lại trang."*

---

### 📌 SLIDE 10: TIÊU CHÍ 3 - BÌNH LUẬN REALTIME & ĐỒNG BỘ NODE FIREBASE
* **Ảnh minh họa:** `Screenshot_...15-43-13` (Chi tiết bài viết & danh sách bình luận) + `Screenshot ...154755.png` (Node /comments).
* **Lời thoại gợi ý:**  
  > *"Khi bấm vào chi tiết bài viết, người dùng có thể gửi bình luận trực tiếp. Dữ liệu tin nhắn được phân nhánh độc lập dưới node `/comments/$postId`. Trên slide là đối soát thực tế: bình luận của người dùng 'Bạch Lưu Dương' với nội dung 'Quá đẹp 🥰🥰🥰' trên ứng dụng được máy chủ Firebase ghi nhận và lưu trữ chính xác 100%."*

---

### 📌 SLIDE 11: TIÊU CHÍ 3 - MINH CHỨNG CƠ SỞ DỮ LIỆU ĐÁM MÂY (FIREBASE RTDB)
* **Ảnh minh họa:** `Screenshot ...154716.png` (Node /posts) + `Screenshot ...154850.png` (Node /users).
* **Lời thoại gợi ý:**  
  > *"Slide này thể hiện cấu trúc cây NoSQL JSON trên Firebase Realtime Database. Nhánh `/posts` lưu trữ thông tin chuyến đi, tác giả, địa điểm và ảnh Base64 nén. Nhánh `/users` quản lý thông tin hồ sơ và định danh người dùng. Kiến trúc phân nhánh này giúp tối ưu hóa băng thông mạng và truy vấn nhanh chóng."*

---

### 📌 SLIDE 12: TIÊU CHÍ 4 - TRA CỨU THỜI TIẾT REST API GET & GỢI Ý TRANG PHỤC
* **Ảnh minh họa:** `Screenshot_...15-43-32` (Màn hình Thời tiết Đà Lạt 22.6°C + Thẻ gợi ý trang phục).
* **Lời thoại gợi ý:**  
  > *"Tiếp theo là Tiêu chí 4 về Dịch vụ Web: Ứng dụng thực hiện phương thức HTTP GET gửi tới Open-Meteo REST API để thu thập dữ liệu thời tiết tại địa điểm du lịch. Hệ thống tự động phân tích: nhiệt độ hiện tại 22.6°C thuộc mức mát mẻ, từ đó kích hoạt thuật toán gợi ý thông minh: khuyên du khách mặc áo thun, quần dài nhẹ nhàng để thuận tiện tham quan ngoài trời."*

---

### 📌 SLIDE 13: TIÊU CHÍ 4 - ĐỒNG BỘ BACKEND REST API POST (201 CREATED)
* **Ảnh minh họa:** `Screenshot_...15-43-46` (Hộp thoại Dialog thông báo mã 201 Created từ Server ReqRes).
* **Lời thoại gợi ý:**  
  > *"Song song với GET, ứng dụng triển khai phương thức HTTP POST để đẩy nhật ký du lịch lên máy chủ sao lưu đám mây ReqRes. Dữ liệu được đóng gói JSON Payload chuẩn mực. Khi máy chủ tiếp nhận, ứng dụng nhận phản hồi HTTP Status Code 201 Created kèm mã ID và thời gian khởi tạo, đồng thời hiển thị hộp thoại thông báo thành công chuyên nghiệp."*

---

### 📌 SLIDE 14: BẢNG TỔNG HỢP ĐỐI SOÁT 5 TIÊU CHÍ CHẤM ĐIỂM (10/10 ĐIỂM)
* **Nội dung slide:** Bảng đối soát chi tiết 5 tiêu chí: Giao diện (2đ), SQLite (2đ), Firebase (2đ), REST API (2đ), Sáng tạo & Kiến trúc (2đ).
* **Lời thoại gợi ý:**  
  > *"Tổng hợp lại bảng đối soát 5 tiêu chí chấm điểm: Nhóm em đã hoàn thiện trọn vẹn 100% tất cả các hạng mục theo barem đánh giá của môn học. Mỗi tiêu chí đều có minh chứng rõ ràng từ mã nguồn Dart, phân tầng Clean Architecture, 0 lỗi `flutter analyze` cho đến tệp cài đặt Release APK hoàn chỉnh."*

---

### 📌 SLIDE 15: KẾT LUẬN & SẴN SÀNG TRÌNH DIỄN (LIVE DEMO)
* **Nội dung slide:** Lời cảm ơn Quý Thầy/Cô, khẳng định sản phẩm hoàn thiện, sẵn sàng mở máy ảo demo trực tiếp và trả lời phản biện.
* **Lời thoại gợi ý:**  
  > *"Dự án Travel Diary App đã hoàn thành xuất sắc các mục tiêu đề ra, mang lại một giải pháp du lịch tiện ích kết hợp giữa Offline và Online. Nhóm em đã chuẩn bị sẵn thiết bị thật và máy ảo Android để trình diễn trực tiếp các tính năng. Em xin chân thành cảm ơn Quý Thầy/Cô đã chú ý lắng nghe và rất mong nhận được những góp ý quý báu từ Hội đồng!"*

---

## 💡 MẸO TRẢ LỜI CÁC CÂU HỎI VẤN ĐÁP THƯỜNG GẶP (Q&A TIPS)

1. **Thầy cô hỏi: "Tại sao dùng SQLite mà lại cần thêm Firebase?"**
   * *Trả lời:* "Dạ thưa Thầy/Cô, SQLite phục vụ tính năng cá nhân và ngoại tuyến (Offline-first) giúp du khách đi vùng sâu, vùng xa mất mạng vẫn ghi chép lịch trình và chi phí bình thường. Còn Firebase là mạng xã hội đám mây giúp chia sẻ kỷ niệm và bình luận đa người dùng trong thời gian thực khi có kết nối Internet."

2. **Thầy cô hỏi: "Cảnh báo Secret/API Key của Google có ảnh hưởng gì không?"**
   * *Trả lời:* "Dạ theo tài liệu chính thức của Firebase, Client API Key trong app di động chỉ là Client Identifier để định danh dự án. Cơ chế bảo mật thực sự được bảo vệ thông qua Firebase Security Rules và xác thực Firebase Auth bằng User Token trên máy chủ."

3. **Thầy cô hỏi: "Làm thế nào để ứng dụng không bị giật lag khi danh sách ảnh dài?"**
   * *Trả lời:* "Dạ trong code em sử dụng `GridView.builder` và `ListView.builder`. Cơ chế này chỉ render các phần tử đang hiển thị trong Viewport màn hình (Lazy Loading), giúp tái sử dụng bộ nhớ và duy trì tốc độ khung hình 60 FPS mượt mà."
