# DIVIDEX
Đây là project ĐỒ ÁN CHUYÊN NGÀNH và LUẬN VĂN TỐT NGHIỆP. Công nghệ sử dụng là FLUTTER.

---
## 0. **Auth Module** (Quản lý xác thực)

* **Presentation:** màn hình đăng nhập, đăng ký.
* **Domain:** `UseCases` như `LoginUser`, `RegisterUser`. Repository interface: `AuthRepository`.
* **Data:** implementation của `AuthRepository` (gọi API / DB), model `UserModel`.

---

---
## 1. **User Module** (Quản lý người dùng)

* **Presentation:** màn hình đăng nhập, đăng ký, chỉnh sửa profile, danh sách bạn bè.
* **Domain:** `UseCases` như `UpdateProfile`, `AddFriend`. Repository interface: `UserRepository`.
* **Data:** implementation của `UserRepository` (gọi API / DB), model `UserModel`.

---

## 2. **Group Module** (Quản lý nhóm chia chi phí)

* **Presentation:** màn hình tạo nhóm, quản lý thành viên, quét QR mời.
* **Domain:** `CreateGroup`, `InviteMember`, `UpdateGroup`, `DeleteGroup`. Repository interface: `GroupRepository`.
* **Data:** API + DB cho `GroupRepository`, model `GroupModel`.

---

## 3. **Event & Expense Module** (Sự kiện & chi tiêu)

* **Presentation:** màn hình tạo sự kiện, thêm khoản chi tiêu, đính kèm ảnh hóa đơn.
* **Domain:** `CreateEvent`, `AddExpense`, `AttachReceipt`, `GetExpensesByEvent`. Repository: `EventRepository`, `ExpenseRepository`.
* **Data:** implementation cho event + expense.

---

## 4. **Settlement Module** (Tính toán & chia chi phí)

* **Presentation:** giao diện xem số tiền cần trả/được nhận.
* **Domain:** `CalculateSettlement`, `GetBalanceByUser`, `MarkAsPaid`.
* **Data:** thực hiện logic chia tiền hoặc gọi service thanh toán.

---

## 5. **History & Search Module** (Lịch sử chi tiêu + tìm kiếm)

* **Presentation:** màn hình lịch sử, filter, search bar.
* **Domain:** `GetHistoryByGroup`, `FilterExpenses`, `SearchExpenses`.
* **Data:** query DB theo filter/search.

---

## 6. **Payment Module** (Thanh toán & tích hợp cổng thanh toán)

* **Presentation:** nút chuyển tiền, màn hình confirm.
* **Domain:** `PayDebt`, `Withdraw`, `Deposit`. Repository: `PaymentRepository`.
* **Data:** tích hợp VietQR / cổng thanh toán khác.

---

## 7. **AI Assistant Module** (OCR + Chatbot)

* **Presentation:** giao diện upload bill, khung chat AI.
* **Domain:** `ParseBillWithOCR`, `AskChatbot`.
* **Data:** gọi dịch vụ AI (OCR, NLP, Chatbot).

---

## 8. **Admin Module**

* **Presentation:** dashboard quản trị (user list, report).
* **Domain:** `BanUser`, `ViewSystemLogs`, `ResetPassword`.
* **Data:** API quản trị.

```
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d chrome
flutter gen-l10n
```

## Promt

You are a senior Flutter QA automation engineer.

Write an integration test using Flutter integration_test package.

Test case:
- Name: {{TEST_NAME}}
- Description: {{DESCRIPTION}}

Requirements:
- Use WidgetTester
- Use find.byKey for UI elements
- Follow Given - When - Then structure
- Include full runnable test code
- Mock API if needed
- Handle async with pumpAndSettle

App context:
- Expense Splitter app
- Features: auth, group, expense, wallet, debt

Output:
- Full Dart test file
- Clean, production-ready code


1. AUTH
    Login thành công với email + password đúng
    Login fail khi sai password
    Login fail khi email không tồn tại
    Validate email sai format
    Không cho login khi để trống field
    Register thành công
    Register fail khi email đã tồn tại
    OTP verify đúng → cho đổi password
    OTP sai hoặc hết hạn thì không cho vào màn đổi password
    Reset password thành công và quay về login
    Reset password fail do token không hợp lệ
2. USER PROFILE
    Update profile thành công
    Upload avatar thành công
    Validate input profile (name rỗng)
    Logout → quay về login screen
3. FRIEND
    Tìm user theo email thành công
    Không tìm thấy user → show “User not found”
    Gửi request kết bạn thành công
    Không gửi request nếu đã là bạn
    Accept request → thành bạn
    Reject request → không thành bạn
    Không cho gửi request khi message rỗng
    Không accept/reject khi friendshipUid null
4. GROUP
    Tạo group thành công
    Tạo group fail khi không nhập tên
    Invite member thành công
    Remove member khỏi group
    Update group info
    Non-owner không được edit group
    Owner có thể dissolve group
    User rời group thành công
5. EVENT
    Tạo event trong group
    Edit event info
    Xóa event
    Add member vào event
    Không cho tạo event nếu không thuộc group
    Load danh sách event đúng
6. EXPENSE
    Tạo expense thành công
    Chia đều tiền cho các member
    Chia custom amount
    Không cho tạo expense khi amount = 0
    Attach bill image (OCR)
    Edit expense
    Delete expense
    Hiển thị đúng danh sách expense
7. DEBT / SPLIT
    Tính toán nợ đúng sau khi thêm expense
    Tối ưu nợ (reduce transactions)
    Update lại nợ sau khi thanh toán
    Hiển thị đúng ai nợ ai
8. WALLET / PAYMENT
    Nạp tiền vào ví thành công
    Thanh toán nợ bằng ví khi đủ tiền
    Thanh toán fail khi không đủ tiền
    Xác nhận thanh toán ngoài app
9. SEARCH / REPORT
    Tìm kiếm expense theo filter
    Hiển thị report (tổng chi, thống kê)