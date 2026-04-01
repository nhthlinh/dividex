# DIVIDEX

**DIVIDEX** là ứng dụng di động giúp quản lý và chia sẻ chi phí nhóm một cách dễ dàng và công bằng. Ứng dụng hỗ trợ người dùng theo dõi chi tiêu, tính toán nợ nần và thanh toán trực tuyến.

**Dự án:** Đồ Án Chuyên Ngành - DACN-251  
**Công nghệ:** Flutter + Firebase

---

## Tính Năng Chính

### Quản lý Tài Khoản
- Đăng ký, đăng nhập tài khoản
- Chỉnh sửa thông tin cá nhân
- Quản lý danh sách bạn bè

### Quản lý Nhóm
- Tạo và quản lý các nhóm chia chi phí
- Mời thành viên qua QR code
- Cập nhật, xóa nhóm

### Quản lý Chi Phí
- Tạo sự kiện/hoạt động nhóm
- Thêm khoản chi tiêu chi tiết
- Đính kèm hóa đơn (hình ảnh)
- Lịch sử chi tiêu, tìm kiếm và lọc

### Thông Minh & AI
- OCR nhận dạng hóa đơn tự động

### Thanh Toán
- Tính toán tự động cho các khoản nợ
- Xem số tiền cần trả/được nhận
- Tích hợp cổng thanh toán (VietQR, v.v.)

---

## Kiến Trúc Dự Án

Dự án tuân theo **Clean Architecture** kết hợp **BLoC Pattern**:

```
lib/
├── features/           # Các tính năng chính
│   ├── auth/           # Xác thực
│   ├── user/           # Quản lý người dùng
│   ├── group/          # Quản lý nhóm
│   ├── expense/        # Quản lý chi phí
│   ├── settlement/     # Tính toán chia tiền
│   ├── payment/        # Thanh toán
│   ├── ai_assistant/   # AI & OCR
│   └── admin/          # Quản trị
├── core/               # Lõi ứng dụng
├── shared/             # Dùng chung (widgets, utils)
├── config/             # Cấu hình
└── main.dart           # Entry point
```

### Cấu Trúc Module

Mỗi module trong `features/` được chia thành 3 lớp:

- **Presentation:** UI, Widgets, BLoC
- **Domain:** Use Cases, Repository Interface, Entities
- **Data:** Implementation Repository, Models, API Calls

---

## Tech Stack

| Công cụ | Phiên bản | Mục đích |
|---------|----------|---------|
| **Flutter** | ^3.8.0 | Framework chính |
| **Flutter BLoC** | ^9.1.1 | State Management |
| **Provider** | ^6.0.5 | Dependency Injection |
| **GoRouter** | ^15.1.3 | Navigation & Routing |
| **Dio** | ^5.0.0 | HTTP Client |
| **Firebase** | - | Backend & Authentication |
| **Hive** | ^2.2.3 | Local Database |
| **Shared Preferences** | ^2.5.3 | Cài đặt nhẹ |
| **Intl** | ^0.20.2 | Internationalization |
| **GetIt** | - | Service Locator |

---

## Requirements

- Flutter SDK ^3.8.0
- Dart ^3.8.0
- Android SDK (untuk build Android)
- Xcode (untuk build iOS)

---

## Hướng Dẫn Cài Đặt

### 1. Clone Repository

```bash
git clone <repository-url>
cd dividex
```

### 2. Cài Đặt Dependencies

```bash
flutter pub get
```

### 3. Code Generation (BLoC, JSON, Routing)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Setup Firebase

- Tạo Firebase project trên [Firebase Console](https://console.firebase.google.com)
- Tải `google-services.json` (Android) và `GoogleService-Info.plist` (iOS)
- Đặt vào thư mục tương ứng

### 5. Setup Environment Variables

```bash
cp .env.example .env
# Chỉnh sửa .env với các thông tin cần thiết
```

### 6. Generate Localization

```bash
flutter gen-l10n
```

### 7. Run Ứng Dụng

```bash
# Chạy trên web
flutter run -d chrome

# Hoặc chạy trên thiết bị thực/emulator
flutter run
```

---

## Testing

[TESTCASE DETAIL](./TEST_COVERAGE_REPORT.md)

### Run Unit Tests

```bash
flutter test
```

### Run Integration Tests

```bash
flutter test integration_test/
```

### Check Test Coverage

```bash
flutter test --coverage
lcov --list coverage/lcov.info
```

---

## Scripts

```bash
# Clean và rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Analyze code
dart analyze

# Format code
dart format lib/

# Check localization
flutter gen-l10n
```

---

## Coding Standards

- Tuân theo [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Sử dụng `flutter analyze` để kiểm tra code quality
- Mỗi feature phải có unit tests

---

## Contribution

1. Tạo branch mới cho feature: `git checkout -b feature/your-feature`
2. Commit changes: `git commit -m 'Add feature: ...'`
3. Push lên repository: `git push origin feature/your-feature`
4. Tạo Pull Request

---

## License

Dự án này được phát triển cho mục đích học tập.

---