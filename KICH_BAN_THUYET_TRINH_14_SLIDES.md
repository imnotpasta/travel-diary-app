# KỊCH BẢN THUYẾT TRÌNH BÁO CÁO ĐỒ ÁN POWERPOINT (14 SLIDES)
## ĐỀ TÀI 10: TRAVEL DIARY APP - SỔ TAY DU LỊCH & KẾT NỐI CỘNG ĐỒNG

> 📁 **File PowerPoint chính thức (Đã đồng bộ ghi chú diễn giả trực tiếp vào file):**  
> • [Bao_Cao_De_Tai_10_TravelDiary.pptx](file:///E:/Projects/travel_diary_app/Bao_Cao_De_Tai_10_TravelDiary.pptx)  
> *(Ghi chú của từng slide đã được nhúng thẳng vào mục Speaker Notes của PowerPoint. Khi bật chế độ Presenter View bằng phím **F5** hoặc **Alt + F5**, bạn sẽ thấy lời thoại hiện trên màn hình laptop còn màn hình máy chiếu chỉ chiếu slide!)*
>
> ⏱️ **Tổng thời lượng đề xuất:** 8 – 10 phút thuyết trình + 5 phút Demo & Vấn đáp.

---

## 🧭 BẢNG PHÂN BỔ THỜI GIAN & TIẾN TRÌNH 14 SLIDE

| Slide | Tiêu đề Slide | Thời gian | Trọng tâm cần nhấn mạnh |
| :---: | :--- | :---: | :--- |
| **1** | Trang tiêu đề: Travel Diary App | 0:00 - 0:45 | Giới thiệu tên đề tài, nhóm thực hiện, Flutter, Dart, Clean Architecture. |
| **2** | Tổng quan hệ thống & 3 Trụ cột kỹ thuật | 0:45 - 1:30 | 3 Trụ cột: Presentation UI/UX, Local Storage SQLite, Cloud & REST API. |
| **3** | Tiêu chí 1: Responsive Màn hình Dọc (2 Cột) | 1:30 - 2:15 | `OrientationBuilder`, Badge "2 Cột (Đứng)", tối ưu thao tác 1 tay, 60 FPS. |
| **4** | Tiêu chí 1: Responsive Màn hình Ngang (3 Cột) | 2:15 - 3:00 | Mở rộng 3 cột khi xoay ngang, Zero Overflow, tận dụng không gian hiển thị. |
| **5** | Tiêu chí 1: Chế độ Sáng & Tối (Light & Dark) | 3:00 - 3:45 | Chuyển đổi Theme 1 chạm, Material 3, nền Dark Slate 900 bảo vệ mắt. |
| **6** | Tiêu chí 2: Sổ tay SQLite & Tìm kiếm tức thì | 3:45 - 4:30 | Offline 100%, Instant Search gõ "đà" ra "Khám phá Đà Lạt", CRUD hoàn chỉnh. |
| **7** | Tiêu chí 2: Form Tạo chuyến đi & ImagePicker | 4:30 - 5:15 | Form Validation chặt chẽ, chọn ảnh Camera / Thư viện máy, nén ảnh tối ưu. |
| **8** | Tiêu chí 3: Xác thực Firebase Authentication | 5:15 - 6:00 | JWT Token, Auth State Stream, tài khoản mẫu `traveler@vietnam.com`, Console 4 users. |
| **9** | Tiêu chí 3: Bảng tin Kỷ niệm Realtime Stream | 6:00 - 6:45 | Đồng bộ bài viết tức thì không cần kéo tải lại, tương tác thả tim, check-in. |
| **10**| Tiêu chí 3: Bình luận Realtime & Node Firebase | 6:45 - 7:30 | Node `/comments/$postId`, bình luận tức thì của "Bạch Lưu Dương" (“Quá đẹp”). |
| **11**| Tiêu chí 3: Cây Dữ liệu NoSQL Firebase RTDB | 7:30 - 8:15 | Đối soát Console nhánh `/posts` (Base64) và nhánh `/users` (hồ sơ người dùng). |
| **12**| Tiêu chí 4: REST API GET Thời tiết & Gợi ý | 8:15 - 9:00 | Open-Meteo HTTP GET 22.6°C mát mẻ, thuật toán AI gợi ý trang phục phù hợp. |
| **13**| Tiêu chí 4: REST API POST Đồng bộ Server | 9:00 - 9:45 | HTTP POST Payload, phản hồi chuẩn `201 Created`, Server ID, Dialog thành công. |
| **14**| Kết luận & Sẵn sàng Vấn đáp (Demo) | 9:45 - 10:30 | Offline + Online, Clean Code, 0 lỗi analyze, sẵn sàng mở máy demo trực tiếp. |

---

## 🎙️ LỜI THOẠI CHI TIẾT TỪNG SLIDE (KÈM HƯỚNG DẪN THAO TÁC)

---

### 🟢 SLIDE 1: TRANG TIÊU ĐỀ
* **Hiển thị:** *Travel Diary App - Ứng dụng Nhật ký Du lịch Thông minh & Kết nối Cộng đồng (Đề tài 10)*
* **Chips công nghệ:** *Flutter 3.24+ | Dart | Clean Architecture | SQLite Offline | Firebase | REST API Weather*
* **Thao tác:** Đứng thẳng tự tin, mắt bao quát Hội đồng, giọng mở đầu rõ ràng, hào hứng.
* **Lời thoại gợi ý:**
> *"Kính chào Quý Thầy/Cô trong Hội đồng chấm đồ án Lập trình Thiết bị Di động và các bạn sinh viên.  
> Hôm nay, em xin phép đại diện nhóm trình bày báo cáo Đồ án Đề tài 10: **Travel Diary App - Ứng dụng Nhật ký Du lịch Thông minh và Kết nối Cộng đồng**.  
> 
> Đồ án được xây dựng trên nền tảng **Flutter 3.24+** mới nhất bằng ngôn ngữ **Dart**, áp dụng mô hình kiến trúc phân tầng sạch **Clean Architecture**. Hệ thống kết hợp hài hòa giữa cơ sở dữ liệu cục bộ **SQLite Offline** cho du khách khi đến những nơi mất sóng, nền tảng đám mây **Firebase** cho mạng xã hội chia sẻ thời gian thực, và dịch vụ **REST API** khí tượng cung cấp thông tin thời tiết kèm gợi ý trang phục thông minh."*

---

### 🟢 SLIDE 2: TỔNG QUAN HỆ THỐNG
* **Hiển thị:** *Kiến Trúc Clean Architecture & 3 Trụ Cột Kỹ Thuật (Đảm bảo tính mở rộng, phân tách độc lập và trải nghiệm người dùng liền mạch)*
* **Thao tác:** Bấm chuyển slide, chỉ tay lần lượt vào 3 cột màu từ trái sang phải.
* **Lời thoại gợi ý:**
> *"Để đảm bảo ứng dụng có thể mở rộng dễ dàng, mã nguồn mạch lạc và không bị phụ thuộc lồng ghép, nhóm em đã thiết kế hệ thống dựa trên 3 trụ cột kỹ thuật cốt lõi:  
> 
> - **Trụ cột 1 - Presentation & UI:** Xây dựng theo ngôn ngữ Material Design 3 hiện đại, giao diện thích ứng đa màn hình với OrientationBuilder, hỗ trợ chuyển đổi mượt mà giữa Sáng và Tối (Light/Dark Mode).  
> - **Trụ cột 2 - Local Storage (SQLite):** Đảm bảo tính năng Offline-first, người dùng luôn ghi chép nhật ký, lưu trữ hình ảnh và tìm kiếm lịch trình an toàn ngay cả khi hoàn toàn không có Internet.  
> - **Trụ cột 3 - Cloud & REST API:** Quản lý phiên đăng nhập bảo mật với Firebase Authentication, trao đổi bình luận thời gian thực qua Firebase Realtime Database và tích hợp REST API thời tiết thực tế từ Open-Meteo."*

---

### 🟢 SLIDE 3: TIÊU CHÍ 1 · GIAO DIỆN THÍCH ỨNG (RESPONSIVE) - DỌC 2 CỘT
* **Hiển thị:** *Tự Động Bố Trí Lưới 2 Cột Khi Ở Màn Hình Dọc (Ảnh điện thoại album dọc)*
* **Thao tác:** Chỉ vào khung ảnh điện thoại bên phải, nhấn mạnh vào huy hiệu `2 Cột (Đứng)`.
* **Lời thoại gợi ý:**
> *"Đến với Tiêu chí 1 về Giao diện Thích ứng (Responsive):  
> Tại màn hình Album Kỷ niệm du lịch, nhóm sử dụng widget `OrientationBuilder` để tự động lắng nghe góc xoay và kích thước màn hình theo thời gian thực mà không cần khởi động lại ứng dụng.  
> 
> Khi người dùng cầm điện thoại ở chế độ màn hình dọc:  
> 1. **Nhận diện hướng màn hình tự động:** Hệ thống phát hiện thiết bị đang ở chế độ dọc và bố trí giao diện dạng lưới 2 cột cân xứng.  
> 2. **Tối ưu hóa thao tác 1 tay:** Chuẩn tỉ lệ thẻ ảnh Card Aspect Ratio, hình ảnh sắc nét kèm huy hiệu nhận diện trạng thái '2 Cột (Đứng)' trực quan.  
> 3. **Hiệu năng cuộn mượt mà:** Ứng dụng triển khai `GridView.builder` giúp tái sử dụng widget khi cuộn danh sách ảnh dài, duy trì tốc độ khung hình 60 FPS mượt mà."*

---

### 🟢 SLIDE 4: TIÊU CHÍ 1 · GIAO DIỆN THÍCH ỨNG (RESPONSIVE) - NGANG 3 CỘT
* **Hiển thị:** *Tự Động Mở Rộng 3 Cột Khi Xoay Màn Hình Ngang (Ảnh chụp xoay ngang rộng)*
* **Thao tác:** Chỉ vào ảnh chụp ngang lớn ở giữa màn hình.
* **Lời thoại gợi ý:**
> *"Tiếp tục với Tiêu chí 1 khi người dùng xoay ngang điện thoại hoặc sử dụng trên máy tính bảng:  
> 
> - **Tự động mở rộng 3 cột:** `OrientationBuilder` ngay lập tức tính toán lại biến `crossAxisCount = 3`, chuyển đổi từ 2 cột sang 3 cột trong tích tắc.  
> - **Zero Overflow – Không tràn viền:** Mọi kích thước khung ảnh tự động co giãn theo tỉ lệ chuẩn. Chiều ngang mở rộng giúp người dùng quan sát được nhiều album kỷ niệm hơn trên cùng một tầm mắt mà hoàn toàn không xảy ra lỗi tràn pixel hay vỡ bố cục."*

---

### 🟢 SLIDE 5: TIÊU CHÍ 1 · TRẢI NGHIỆM GIAO DIỆN (UI/UX) - LIGHT & DARK MODE
* **Hiển thị:** *Hỗ Trợ Chế Độ Sáng & Tối (2 ảnh điện thoại đặt song song: Giao diện Sáng vs Giao diện Tối)*
* **Thao tác:** Chỉ vào sự đối lập tương phản giữa 2 ảnh điện thoại.
* **Lời thoại gợi ý:**
> *"Bên cạnh tính năng Responsive, ứng dụng hỗ trợ trọn vẹn Chế độ Giao diện Kép Sáng và Tối (Light Mode & Dark Mode):  
> 
> 1. **Chuyển đổi Theme tức thì:** Người dùng có thể chủ động bật/tắt Dark Mode ngay tại trang Hồ sơ cá nhân chỉ với một thao tác chạm mà không làm gián đoạn luồng làm việc.  
> 2. **Chuẩn mực Material Design 3:** Bảng màu tương phản cao, nền tối Slate 900 bảo vệ thị giác người dùng khi tra cứu lịch trình ban đêm, đồng thời tiết kiệm pin tối đa cho màn hình OLED/AMOLED.  
> 3. **Hiển thị thông tin cá nhân:** Đồng bộ trạng thái tài khoản đã xác thực với Firebase Authentication kèm định danh vị trí du lịch của người dùng."*

---

### 🟢 SLIDE 6: TIÊU CHÍ 2 · CƠ SỞ DỮ LIỆU CỤC BỘ (LOCAL STORAGE) - SQLITE
* **Hiển thị:** *Sổ Tay Chuyến Đi SQLite & Bộ Lọc Tìm Kiếm Tức Thì (Ảnh danh sách chuyến đi lọc từ khóa "đà")*
* **Thao tác:** Chỉ vào thanh tìm kiếm trên màn hình điện thoại đang lọc từ khóa "đà" ra "Khám phá Đà Lạt".
* **Lời thoại gợi ý:**
> *"Chuyển sang Tiêu chí 2 về Lưu trữ Cục bộ:  
> Khi du khách đi du lịch ở những khu vực vùng sâu, vùng xa mất sóng mạng, ứng dụng vẫn hoạt động độc lập 100% nhờ SQLite Database tích hợp sẵn:  
> 
> 1. **Lưu trữ SQLite độc lập & bảo mật:** Mọi thông tin hành trình, điểm đến, ngày khởi hành và chi phí ước tính được lưu trữ trực tiếp trong bộ nhớ máy.  
> 2. **Tìm kiếm tức thì (Instant Filter):** Thanh tìm kiếm phản hồi ngay khi gõ từng ký tự. Như Thầy/Cô quan sát trên slide, khi người dùng gõ từ khóa 'đà', ứng dụng lập tức truy vấn và lọc ra chuyến đi 'Khám phá Đà Lạt' với độ trễ dưới 16 mili-giây.  
> 3. **Quản lý CRUD toàn diện:** Hỗ trợ đầy đủ bộ thao tác Thêm mới, Xem chi tiết, Chỉnh sửa và Xóa chuyến đi mượt mà."*

---

### 🟢 SLIDE 7: TIÊU CHÍ 2 · NHẬP LIỆU & BỘ CHỌN ẢNH (IMAGE PICKER)
* **Hiển thị:** *Biểu Mẫu Nhập Liệu Chuẩn Hóa & Chọn Ảnh Trực Tiếp (Form Thêm chuyến đi + Bottom Sheet)*
* **Thao tác:** Chỉ vào hộp thoại chọn "Thư viện máy" / "Chụp ảnh mới" ở góc dưới ảnh điện thoại.
* **Lời thoại gợi ý:**
> *"Để tạo mới chuyến đi, màn hình biểu mẫu được thiết kế chuẩn mực:  
> 
> 1. **Form Validation chặt chẽ:** Kiểm tra tính hợp lệ của tất cả các trường dữ liệu bắt buộc: tên chuyến đi, địa điểm, ngày tháng và kinh phí dự trù, ngăn chặn dữ liệu trống hoặc sai định dạng.  
> 2. **Tích hợp ImagePicker đa nguồn:** Cung cấp 2 lựa chọn tiện lợi cho du khách: lấy ảnh sẵn có từ 'Thư viện máy' hoặc 'Chụp ảnh mới' trực tiếp qua Camera điện thoại.  
> 3. **Xử lý nén ảnh & chuyển đổi:** Hình ảnh sau khi chọn được tự động nén tối ưu bộ nhớ, lưu đường dẫn nội bộ và sẵn sàng mã hóa để đồng bộ hóa lên máy chủ."*

---

### 🟢 SLIDE 8: TIÊU CHÍ 3 · XÁC THỰC NGƯỜI DÙNG ĐÁM MÂY - FIREBASE AUTH
* **Hiển thị:** *Firebase Authentication: Bảo Mật & Quản Trị Tài Khoản (Ảnh Login + Ảnh Firebase Console Users)*
* **Thao tác:** Chỉ vào khung tài khoản mẫu trên app và chỉ sang bảng điều khiển Firebase Console bên phải.
* **Lời thoại gợi ý:**
> *"Đến với Tiêu chí 3 về Kết nối Đám mây & Xác thực:  
> 
> 1. **Xác thực chuẩn Google Firebase:** Bảo vệ phiên đăng nhập an toàn bằng JWT Token, tự động duy trì và kiểm tra trạng thái qua luồng `authStateChanges()` Stream.  
> 2. **Tài khoản mẫu thử nghiệm:** Nhóm đã tích hợp sẵn banner tài khoản demo `traveler@vietnam.com` ngay trên màn hình đăng nhập để Quý Thầy/Cô có thể trải nghiệm tức thì mà không cần đăng ký mới.  
> 3. **Minh chứng Firebase Console:** Ảnh bên phải chụp trực tiếp từ Firebase Console ghi nhận danh sách 4 tài khoản người dùng thực tế đã được đăng ký và quản lý tập trung trên máy chủ Google."*

---

### 🟢 SLIDE 9: TIÊU CHÍ 3 · KẾT NỐI THỜI GIAN THỰC (REALTIME STREAM)
* **Hiển thị:** *Bảng Tin Kỷ Niệm Du Lịch Đa Người Dùng (Community Feed có bài đăng Làng Cù Lần, Đà Lạt)*
* **Thao tác:** Chỉ vào bài viết cộng đồng có hình ảnh và nút thả tim.
* **Lời thoại gợi ý:**
> *"Sau khi đăng nhập, người dùng bước vào Bảng tin Kỷ niệm Cộng đồng (Community Feed):  
> 
> 1. **Luồng Stream thời gian thực:** Kết nối với Firebase Realtime Database qua `StreamBuilder`. Khi bất kỳ ai đăng tải một kỷ niệm mới, bài viết lập tức hiển thị ngay trên màn hình của tất cả các thành viên khác mà không cần thao tác kéo tải lại trang (Pull-to-refresh).  
> 2. **Tương tác thả tim & xem chi tiết:** Người dùng có thể yêu thích bài viết, xem địa điểm check-in (như 'Làng Cù Lần, Đà Lạt') và hình ảnh kỷ niệm chất lượng cao.  
> 3. **Trải nghiệm mạng xã hội du lịch:** Giao diện thân thiện, hiện đại, khuyến khích các tín đồ du lịch chia sẻ những khoảnh khắc đẹp trong mỗi hành trình."*

---

### 🟢 SLIDE 10: TIÊU CHÍ 3 · TƯƠNG TÁC THỜI GIAN THỰC (COMMENTS)
* **Hiển thị:** *Hệ Thống Bình Luận Realtime & Đồng Bộ Node Firebase (Màn hình chi tiết bài viết + Node Console)*
* **Thao tác:** Chỉ vào bình luận của "Bạch Lưu Dương" trên app và đối soát sang dòng chữ trên Firebase Console.
* **Lời thoại gợi ý:**
> *"Tính năng tương tác nổi bật nhất trên cộng đồng là Hệ thống Bình luận thời gian thực:  
> 
> - **Bình luận tức thì:** Khi người dùng nhập nội dung và bấm gửi, tin nhắn lập tức xuất hiện trên màn hình của tất cả mọi người đang xem bài viết đó.  
> - **Dữ liệu phân nhánh thông minh:** Mỗi bài viết sở hữu một node bình luận riêng biệt dưới nhánh `/comments/$postId`, giúp tối ưu băng thông mạng và truy vấn cực kỳ gọn nhẹ.  
> - **Minh chứng Firebase Console:** Như Thầy/Cô quan sát trên slide, bình luận thực tế của người dùng 'Bạch Lưu Dương' với nội dung 'Quá đẹp 🥰🥰🥰' đã được lưu trữ và phản ánh chính xác 100% trên cơ sở dữ liệu đám mây."*

---

### 🟢 SLIDE 11: TIÊU CHÍ 3 · MINH CHỨNG CƠ SỞ DỮ LIỆU ĐÁM MÂY (RTDB)
* **Hiển thị:** *Cây Dữ Liệu NoSQL JSON Trên Firebase Realtime Database (2 ảnh chụp màn hình Console)*
* **Thao tác:** Chỉ vào 2 nhánh cây dữ liệu `/posts` và `/users`.
* **Lời thoại gợi ý:**
> *"Slide này minh chứng chi tiết cấu trúc cây NoSQL JSON trên Firebase Realtime Database:  
> 
> - **Node `/posts`:** Lưu trữ toàn bộ thông tin bài viết bao gồm tác giả, điểm đến 'Làng Cù Lần, Đà Lạt', lượt like và chuỗi hình ảnh Base64 được tối ưu dung lượng.  
> - **Node `/users`:** Quản lý hồ sơ người dùng 'Bạch Lưu Dương', định danh địa phương 'Hà Nội' và ảnh đại diện.  
> Cấu trúc phân nhánh độc lập này giúp giảm tải băng thông, dễ dàng mở rộng và tăng tốc độ đọc/ghi dữ liệu thời gian thực."*

---

### 🟢 SLIDE 12: TIÊU CHÍ 4 · DỊCH VỤ WEB (REST API GET) - THỜI TIẾT
* **Hiển thị:** *Tích Hợp API Thời Tiết Thực & Gợi Ý Trang Phục (Nhiệt độ 22.6°C tại Đà Lạt)*
* **Thao tác:** Chỉ vào thẻ nhiệt độ 22.6°C và khung gợi ý trang phục màu xanh bên dưới.
* **Lời thoại gợi ý:**
> *"Bước sang Tiêu chí 4 về Dịch vụ Web:  
> 
> 1. **Giao thức HTTP GET chuẩn mực:** Ứng dụng gửi yêu cầu tới Open-Meteo REST API và bóc tách dữ liệu JSON để lấy nhiệt độ thực tế tại điểm đến (như Đà Lạt hiện tại 22.6°C, độ ẩm và tốc độ gió).  
> 2. **Gợi ý trang phục thông minh (Rule-based):** Hệ thống phân tích nhiệt độ 22.6°C thuộc mức mát mẻ, từ đó kích hoạt lời khuyên thông minh: 'Thời tiết mát mẻ, lý tưởng để tham quan! Áo thun, quần dài nhẹ nhàng'.  
> 3. **Cảnh báo chỉ số thời tiết:** Hiển thị trực quan chỉ số UV, cảm giác thực tế và cảnh báo an toàn cho chuyến đi."*

---

### 🟢 SLIDE 13: TIÊU CHÍ 4 · ĐỒNG BỘ DỮ LIỆU BACKEND (REST API POST)
* **Hiển thị:** *Đẩy Nhật Ký Lên Server & Nhận Phản Hồi HTTP 201 (Hộp thoại Dialog 201 Created)*
* **Thao tác:** Chỉ vào hộp thoại thông báo thành công có mã 201.
* **Lời thoại gợi ý:**
> *"Song song với HTTP GET, ứng dụng triển khai phương thức HTTP POST để sao lưu dữ liệu hành trình lên máy chủ đám mây:  
> 
> 1. **HTTP POST truyền Payload:** Dữ liệu chuyến đi gồm tên chuyến, địa điểm, thời gian và kinh phí được đóng gói dạng JSON Body gửi lên RESTful Endpoint của máy chủ ReqRes.  
> 2. **Mã phản hồi HTTP 201 Created:** Máy chủ xử lý thành công và gửi phản hồi với mã trạng thái 201 Created kèm theo Server ID và dấu thời gian tạo (CreatedAt).  
> 3. **Dialog phản hồi trực quan:** Ứng dụng bắt trọn vẹn kết quả và hiển thị hộp thoại thông báo 'Đã gửi nhật ký lên server thành công!' một cách chuyên nghiệp."*

---

### 🟢 SLIDE 14: KẾT LUẬN & SẴN SÀNG VẤN ĐÁP
* **Hiển thị:** *Đồ án Travel Diary hoàn thành xuất sắc (Offline + Online, Responsive & Dark Mode, Sẵn sàng trình diễn)*
* **Thao tác:** Cúi đầu chào nhẹ nhàng, tự tin chuyển sang phần Demo hoặc trả lời câu hỏi.
* **Lời thoại gợi ý:**
> *"Tổng kết lại, Đồ án Travel Diary App đã hoàn thành xuất sắc 100% các tiêu chí kỹ thuật:  
> - **Offline + Online:** Kết hợp nhuần nhuyễn giữa SQLite lưu trữ ngoại tuyến và đám mây Firebase cùng REST API khi có mạng.  
> - **Responsive & Dark Mode:** Giao diện thích ứng hiện đại, mượt mà và tối ưu trải nghiệm người dùng.  
> - **Chất lượng kỹ thuật:** Mã nguồn Clean Code, 0 lỗi analyze, kiểm thử đầy đủ và đã build tệp Release APK hoàn chỉnh.  
> 
> Nhóm em đã chuẩn bị sẵn thiết bị thật và máy ảo Android để trình diễn trực tiếp các tính năng.  
> Em xin chân thành cảm ơn Quý Thầy/Cô đã chú ý lắng nghe, và nhóm rất mong nhận được những nhận xét, câu hỏi phản biện từ Hội đồng!"*

---

## 🎯 BỘ 5 CÂU HỎI VẤN ĐÁP PHẢN BIỆN (TRẢ LỜI ĐẠT ĐIỂM TỐI ĐA)

### ❓ Câu 1: "Tại sao nhóm lại dùng cả SQLite lẫn Firebase trong cùng một ứng dụng?"
> **Trả lời:**  
> *"Dạ thưa Thầy/Cô, đây là kiến trúc **Offline-first kết hợp Cloud sync**. Du khách đi du lịch thường đến các vùng đồi núi, biển đảo không có mạng Internet. Lúc này **SQLite** giúp họ ghi chép chi phí, xem nhật ký hoàn toàn ngoại tuyến. Khi có kết nối mạng trở lại, **Firebase** đóng vai trò mạng xã hội đám mây giúp chia sẻ kỷ niệm và bình luận thời gian thực với cộng đồng."*

### ❓ Câu 2: "Cảnh báo Secret/API Key của Google trên GitHub có gây rủi ro gì không?"
> **Trả lời:**  
> *"Dạ theo tài liệu chính thức của Google Firebase, Client API Key trong app di động thực chất là **Client Identifier** để app trỏ đúng Firebase Project, không phải Private Admin Secret. Cơ chế bảo mật thực sự của ứng dụng nằm ở **Firebase Security Rules** trên máy chủ và **Firebase Authentication User Token**, chỉ người dùng đã đăng nhập mới có quyền ghi dữ liệu."*

### ❓ Câu 3: "Làm thế nào để giao diện không bị giật lag khi tải nhiều hình ảnh kỷ niệm?"
> **Trả lời:**  
> *"Dạ trong code nhóm sử dụng `GridView.builder` và `ListView.builder`. Cơ chế này chỉ render các widget đang nằm trong tầm nhìn màn hình (Viewport / Lazy Loading). Đồng thời, ảnh chụp trước khi lưu đã được nén giảm dung lượng và mã hóa tối ưu, giúp ứng dụng duy trì tốc độ 60 FPS mượt mà."*

### ❓ Câu 4: "Tại sao nhóm chọn OrientationBuilder thay vì MediaQuery để làm Responsive?"
> **Trả lời:**  
> *"Dạ thưa Thầy/Cô, `MediaQuery` chỉ cung cấp kích thước toàn màn hình của thiết bị, trong khi `OrientationBuilder` cung cấp hướng hiển thị cục bộ ngay tại vùng chứa (context), giúp việc tính toán số cột của GridView (`crossAxisCount = 2` khi đứng, `3` khi ngang) diễn ra chính xác và phản hồi tức thì khi người dùng xoay máy."*

### ❓ Câu 5: "Ứng dụng xử lý bất đồng bộ ConnectionState trong FutureBuilder như thế nào?"
> **Trả lời:**  
> *"Dạ trong màn hình tra cứu thời tiết và REST API, `FutureBuilder` bắt đủ 4 trạng thái: Khi `ConnectionState.waiting` hiển thị vòng xoay `CircularProgressIndicator`; khi `snapshot.hasError` hiển thị thông báo lỗi kèm nút 'Thử lại'; và khi `snapshot.hasData` mới hiển thị thẻ thông tin nhiệt độ và gợi ý trang phục."*
