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