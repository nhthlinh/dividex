# Dividex Shared Layer Architecture Analysis

**Generated:** May 13, 2026  
**Total Lines of Code:** 4,922 lines  
**Analysis Scope:** Complete `lib/shared/` folder structure

---

## 📊 Directory Tree Structure

```
lib/shared/
├── bloc/                          (22 lines)
│   └── app_bloc_observer.dart      - Global Bloc event/transition/error logging
│
├── bootstrap/                      (130 lines total)
│   ├── bootstrap.dart              - App initialization orchestrator
│   ├── error_handler.dart          - Global error handling & crash reporting
│   ├── firebase_service.dart       - Firebase initialization (FCM, Auth)
│   └── notification_initializer.dart - Push notification setup
│
├── exceptions/                     (9 lines)
│   └── app_exception.dart          - Custom exception class
│
├── models/                         (1,227 lines)
│   ├── banks.dart                  - Bank data & BankInfo class (1,024 lines)
│   ├── enum.dart                   - CurrencyEnum with VND support (193 lines)
│   └── paging_model.dart           - Generic pagination wrapper (24 lines)
│
├── pages/                          (269 lines)
│   └── choose_members_page.dart    - Shared member selection UI
│
├── services/                       (1,298 lines total)
│   ├── local/                      (341 lines)
│   │   ├── hive_service.dart       - Local storage (Hive DB) wrapper
│   │   ├── hive_boxes.dart         - Hive box name constants
│   │   ├── hive_keys.dart          - Hive key constants
│   │   └── models/                 (216 lines)
│   │       ├── setting_local_model.dart   - Theme/locale settings (Hive)
│   │       ├── token_local_model.dart     - JWT tokens (Hive)
│   │       └── user_local_model.dart      - User cache (Hive)
│   │
│   ├── notification/               (105 lines)
│   │   ├── fcm.dart                - Firebase Cloud Messaging handler
│   │   ├── notification_service.dart - In-app notification dispatcher
│   │   └── navigation_service.dart  - Route navigation from notifications
│   │
│   └── settings_service.dart       - Theme/locale manager with ChangeNotifier
│
├── utils/                          (1,063 lines)
│   ├── change_string.dart          - String transformation utilities
│   ├── download_qr.dart            - QR code download/generation
│   ├── get_time_ago.dart           - Human-readable time formatting
│   ├── image_compress.dart         - Image compression utilities
│   ├── jwt_decoder.dart            - JWT token parsing
│   ├── logger.dart                 - Logging utility wrapper
│   ├── message_code.dart           - Error/message code mapper
│   ├── noti_parser.dart            - Notification payload parser
│   ├── num.dart                    - Number formatting (decimal/currency)
│   ├── payout_api.dart             - Payment API helpers
│   ├── sha256.dart                 - Hashing utilities (126 lines)
│   └── validation_input.dart       - Form field validators
│
└── widgets/                        (2,090 lines)
    ├── app_shell.dart              - Root layout with bottom nav shell (175 lines)
    ├── bar_chart.dart              - Monthly expense chart widget (151 lines)
    ├── content_card.dart           - Reusable card container (42 lines)
    ├── create_pin.dart             - PIN creation dialog (69 lines)
    ├── custom_button.dart          - Themeable button component (113 lines)
    ├── custom_dropdown_widget.dart - Reusable dropdown (258 lines)
    ├── custom_form_wrapper.dart    - Form layout wrapper (140 lines)
    ├── custom_text_input_widget.dart - Unified text input field (169 lines)
    ├── info_card.dart              - Info display card (73 lines)
    ├── layout.dart                 - Layout templates (159 lines)
    ├── push_noti_widget.dart       - Push notification UI (27 lines)
    ├── push_noti_in_app_widget.dart - In-app notification display (78 lines)
    ├── settle_up_pop_up.dart       - Payment settlement dialog (103 lines)
    ├── show_dialog_widget.dart     - Reusable dialog helper (62 lines)
    ├── simple_layout.dart          - Minimal layout wrapper (86 lines)
    ├── text_button.dart            - Styled text button (76 lines)
    ├── two_option_selector_widget.dart - Toggle/selector widget (126 lines)
    ├── user_grid_widget.dart       - User grid display (157 lines)
    └── wave_painter.dart           - Wave animation painter (45 lines)
```

---

## 📦 1. BLOC FILES

### `shared/bloc/`

| File | Lines | Purpose | Dependencies |
|------|-------|---------|--------------|
| **app_bloc_observer.dart** | 22 | Global Bloc observer for debugging | `flutter_bloc`, `logger` |

**Purpose:** Implements `BlocObserver` to log all Bloc events, transitions, and errors globally.

**Usage Pattern:**
```dart
Bloc.observer = AppBlocObserver();
```

---

## 🗂️ 2. MODELS & DATA STRUCTURES

### `shared/models/`

| File | Lines | Purpose | Belongs To |
|------|-------|---------|-----------|
| **banks.dart** | 1,024 | Vietnamese bank data catalog | Payment/Transfer feature |
| **enum.dart** | 193 | Currency enumerations | Expense tracking, Payments |
| **paging_model.dart** | 24 | Generic pagination wrapper | All list-based features |

### Details:

**banks.dart**
- Contains hardcoded list of Vietnamese banks with:
  - Bank ID, name, code (ICB, VCB, etc.)
  - Logo URLs, transfer support flags
  - SWIFT codes for international transfers
- Primary use: Transfer/payment feature bank selection

**enum.dart**
- `CurrencyEnum`: Currently only VND enabled (Vietnamese Đồng)
- Many commented-out currencies suggest multi-currency support planned
- Used in: expense models, payment widgets

**paging_model.dart**
- Generic generic `<T>` pagination wrapper
- Properties: `data`, `page`, `totalPage`, `totalItems`
- Factory constructor from API JSON responses

---

## 📄 3. PAGES

### `shared/pages/`

| File | Lines | Purpose | Feature Usage | Bloc Dependencies |
|------|-------|---------|----------------|------------------|
| **choose_members_page.dart** | 269 | Reusable member selector | Groups, Expenses, Payments | `UserBloc` |

### `choose_members_page.dart` Details:

**Type:** Shared page used across multiple features

**Responsibilities:**
- Multi-select or single-select member picker
- Search functionality for members
- Supports filtering (can exclude current user)
- Initial member pre-selection

**Feature Imports:**
- `features/user/data/models/user_model.dart`
- `features/user/presentation/bloc/user_bloc.dart`
- `features/user/presentation/bloc/user_event.dart`
- `features/user/presentation/bloc/user_state.dart`

**Props:**
```dart
- id: String? (group/event ID context)
- type: LoadType (LOAD_GROUP, LOAD_EVENT, etc.)
- onSelectedMembersChanged: Callback for selection
- initialSelectedMembers: Pre-selected users
- isMultiSelect: bool
- isCanChooseMyself: bool
```

---

## 🎨 4. WIDGETS & COMPONENTS

### `shared/widgets/` (Largest folder: 2,090 lines)

#### **Layout Widgets**

| Widget | Lines | Purpose | Feature Deps | Bloc Deps |
|--------|-------|---------|--------------|-----------|
| **app_shell.dart** | 175 | Root navigation shell with bottom nav | home | ❌ |
| **layout.dart** | 159 | General page layout template | — | ❌ |
| **simple_layout.dart** | 86 | Minimal wrapper layout | — | ❌ |

**app_shell.dart** - Key Features:
- Bottom navigation visibility toggle
- Scroll direction detection (hide on scroll down, show on scroll up)
- Double-tap to show hidden nav bar
- Imports: `AddButtonWidget` from **home** feature (circular?)

#### **Form & Input Widgets**

| Widget | Lines | Purpose | Feature Deps |
|--------|-------|---------|--------------|
| **custom_text_input_widget.dart** | 169 | Themed text field | — |
| **custom_dropdown_widget.dart** | 258 | Reusable dropdown selector | — |
| **custom_button.dart** | 113 | Themeable button component | — |
| **text_button.dart** | 76 | Simple text button | — |
| **two_option_selector_widget.dart** | 126 | Toggle/binary selector | — |
| **custom_form_wrapper.dart** | 140 | Form container layout | — |

#### **Dialog & Popup Widgets**

| Widget | Lines | Purpose | Feature Deps | Bloc Deps |
|--------|-------|---------|--------------|-----------|
| **show_dialog_widget.dart** | 62 | Base dialog wrapper | — | ❌ |
| **create_pin.dart** | 69 | PIN creation dialog | user | `UserBloc` ✓ |
| **settle_up_pop_up.dart** | 103 | Payment settlement popup | user, group | `GroupBloc` ✓ |

**create_pin.dart** - Feature Imports:
- `features/user/presentation/bloc/user_bloc.dart`
- `features/user/presentation/bloc/user_event.dart`
- Triggers: `CreatePinEvent(pin: ...)`

**settle_up_pop_up.dart** - Feature Imports:
- `features/user/data/models/user_model.dart`
- `features/group/presentation/bloc/group_bloc.dart`
- `features/group/presentation/bloc/group_event.dart`
- Triggers: Payment settlement events on group

#### **Data Display Widgets**

| Widget | Lines | Purpose | Feature Deps |
|--------|-------|---------|--------------|
| **bar_chart.dart** | 151 | Monthly expense chart | group (domain) |
| **user_grid_widget.dart** | 157 | User grid display | user |
| **content_card.dart** | 42 | Generic card container | — |
| **info_card.dart** | 73 | Info display card | — |

**bar_chart.dart** - Feature Imports:
- `features/group/domain/usecase.dart` (imports domain for `CustomBarChartData` class)
- Uses: `MonthlyBarChart` widget for group expense visualization

#### **Notification Widgets**

| Widget | Lines | Purpose |
|--------|-------|---------|
| **push_noti_in_app_widget.dart** | 78 | In-app notification display |
| **push_noti_widget.dart** | 27 | Push notification handler |

#### **Utility Widgets**

| Widget | Lines | Purpose |
|--------|-------|---------|
| **wave_painter.dart** | 45 | Wave animation painter (CustomPainter) |

---

## 🔧 5. SERVICES

### Local Storage (`services/local/`)

**HiveService** (102 lines)
- Manages local database using Hive
- Handles box initialization for:
  - Settings (theme, locale)
  - Tokens (JWT auth)
  - User cache
  - Images

**Registered Adapters:**
1. `UserLocalModel` (ID: 3)
2. `SettingsLocalModel` (ID: 1)
3. `TokenLocalModel` (ID: 2)
4. `ImageModel` (ID: 4) → **Imports: features/image**

**Local Models:**
- `setting_local_model.dart`: Theme mode, locale code
- `token_local_model.dart`: Stores JWT tokens
- `user_local_model.dart`: Caches user profile data

### Notification Services (`services/notification/`)

**FCM Service** (28 lines)
- Firebase Cloud Messaging setup
- **IMPORTS: features/auth/data/source/auth_remote_datasource.dart** (possible circular reference)

**NotificationService** (47 lines)
- Notification event dispatcher
- Parses and routes notifications

**NavigationService** (10 lines)
- Routes navigation based on notification payloads

### Settings Service (53 lines)
- Extends `ChangeNotifier` for reactive updates
- Manages theme and locale persistence
- Singleton pattern with `@lazySingleton`

---

## 🚀 6. BOOTSTRAP PROCESS

### `bootstrap/bootstrap.dart` (57 lines)

**Initialization Sequence:**
1. Load `.env` file
2. Configure dependency injection (get_it)
3. Initialize Hive local storage
4. Initialize Firebase
5. Initialize notifications
6. Wait for all dependencies ready
7. Setup global error handler
8. Setup Bloc observer
9. Request Firebase messaging permissions
10. Launch app with MultiBlocProvider

**Root Blocs Initialized:**
- `BottomNavVisibilityCubit`
- `AuthBloc`
- `LoadedNotiBloc`
- `RechargeBloc`
- `LocaleCubit`
- `ThemeCubit`

### Supporting Initialization Files

**error_handler.dart** (22 lines)
- Global exception handler
- Sets up error zone

**firebase_service.dart** (31 lines)
- Firebase & Firestore initialization
- Options from `firebase_options.dart`

**notification_initializer.dart** (20 lines)
- Awesome Notifications setup
- Request notification permissions

---

## ⚙️ 7. UTILITIES

### Utility Breakdown (1,063 lines total)

| Utility | Lines | Purpose |
|---------|-------|---------|
| **sha256.dart** | 126 | Cryptographic hashing (PIN/password) |
| **validation_input.dart** | 186 | Form validators (email, phone, PIN, etc.) |
| **payout_api.dart** | 63 | Payment API integration helpers |
| **noti_parser.dart** | 67 | Parse notification payloads |
| **num.dart** | 41 | Format numbers/currency with decimals |
| **message_code.dart** | 35 | Map error codes to messages |
| **get_time_ago.dart** | 47 | Format timestamps ("2 hours ago") |
| **change_string.dart** | 34 | String transformations |
| **jwt_decoder.dart** | 14 | Decode JWT tokens |
| **logger.dart** | 14 | Logging wrapper around logger package |
| **image_compress.dart** | 11 | Image compression utilities |
| **download_qr.dart** | 36 | QR code generation/download |

---

## 🔴 8. CIRCULAR DEPENDENCIES DETECTED

### **Type 1: SHARED → FEATURES (One-Way Dependency)**

These are technically NOT circular but represent architecture violations where shared layer depends on feature layers:

#### Critical Issues:

1. **app_shell.dart → home feature**
   ```dart
   import 'package:Dividex/features/home/presentation/widgets/add_button_widget.dart';
   ```
   - **Issue:** Shared shell imports feature widget (should be opposite)
   - **Risk Level:** HIGH - Violates layering

2. **settle_up_pop_up.dart → group feature**
   ```dart
   import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
   import 'package:Dividex/features/group/presentation/bloc/group_event.dart';
   ```
   - **Issue:** Shared widget tightly coupled to group feature
   - **Risk Level:** MEDIUM - Could move to group feature

3. **create_pin.dart → user feature**
   ```dart
   import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
   import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
   ```
   - **Issue:** PIN creation is user-specific, should be in user feature
   - **Risk Level:** MEDIUM

4. **bar_chart.dart → group feature**
   ```dart
   import 'package:Dividex/features/group/domain/usecase.dart';
   ```
   - **Issue:** Chart widget imports group domain (imports CustomBarChartData)
   - **Risk Level:** MEDIUM

5. **choose_members_page.dart → user feature**
   ```dart
   import 'package:Dividex/features/user/data/models/user_model.dart';
   import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
   ```
   - **Issue:** Heavy coupling to user feature
   - **Risk Level:** MEDIUM

#### Moderate Issues:

6. **user_grid_widget.dart → user feature**
   ```dart
   import 'package:Dividex/features/user/data/models/user_model.dart';
   ```
   - **Issue:** Generic widget tightly bound to user model

7. **hive_service.dart → image feature**
   ```dart
   import 'package:Dividex/features/image/data/models/image_model.dart';
   ```
   - **Issue:** Service layer imports feature model adapter

8. **fcm.dart → auth feature**
   ```dart
   import 'package:Dividex/features/auth/data/source/auth_remote_datasource.dart';
   ```
   - **Issue:** Notification service imports auth datasource

### **Type 2: REVERSE DEPENDENCIES (Features → Shared)**

These are CORRECT and should exist:

✅ **Multiple features import shared:**
- bootstrap files
- local models & services
- shared widgets
- shared utilities
- shared exceptions

Examples:
```dart
// CORRECT - features depend on shared:
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
```

---

## 📋 9. DEPENDENCY MATRIX

### Shared → Features (Architecture Violations ⚠️)

```
LAYER VIOLATION SUMMARY:

SHARED WIDGETS:
├── app_shell          → features/home (widget import) ❌ HIGH
├── settle_up_pop_up   → features/group (bloc import) ⚠️  MEDIUM  
├── create_pin         → features/user (bloc import) ⚠️  MEDIUM
├── bar_chart          → features/group (domain import) ⚠️ MEDIUM
├── choose_members_page → features/user (bloc import) ⚠️ MEDIUM
├── user_grid_widget   → features/user (model import) ⚠️ MEDIUM
│
SHARED SERVICES:
├── hive_service       → features/image (model adapter) ⚠️ MEDIUM
├── fcm                → features/auth (datasource) ⚠️ MEDIUM
│
SHARED PAGES:
└── choose_members_page → features/user (bloc import) ⚠️ MEDIUM
```

### Features → Shared (Correct Dependencies ✅)

```
EXPECTED & CORRECT:
- auth/*, event_expense/*, group/*, user/*, etc.
  └─ All import from shared/: services, widgets, utils, models
```

---

## 🔧 10. RECOMMENDATIONS

### Immediate Priority (P1)

1. **Move feature-specific widgets out of shared:**
   - `settle_up_pop_up.dart` → `features/group/presentation/widgets/`
   - `create_pin.dart` → `features/user/presentation/widgets/`
   - `choose_members_page.dart` → `features/user/presentation/pages/`

2. **Fix app_shell.dart:**
   - Extract `AddButtonWidget` to shared widgets or pass as parameter
   - Use dependency injection instead of direct import

3. **Extract CustomBarChartData to shared:**
   - Move `CustomBarChartData` from group domain to `shared/models/`
   - Keep chart widget in shared, models in shared

### Secondary Priority (P2)

4. **Decouple bar_chart.dart from group:**
   - Move chart data model to shared/models
   - Pass data objects instead of importing domain logic

5. **Genericize user_grid_widget.dart:**
   - Create generic `GridWidget<T>` that accepts any model
   - Keep `user_grid_widget` as specialized wrapper

6. **Service dependencies:**
   - Review hive_service image adapter registration
   - Move image model to shared if widely used
   - Decouple fcm from auth datasource

### Long-term (P3)

7. **Dependency injection:**
   - Use injection container to resolve bloc dependencies
   - Avoid direct bloc imports in shared widgets

8. **Architecture refactor:**
   - Consider BLoC/MVVM pattern for all features
   - Establish strict shared layer interface

---

## 📈 11. METRICS

| Metric | Value |
|--------|-------|
| **Total Shared Files** | 48 |
| **Total Lines** | 4,922 |
| **Largest File** | banks.dart (1,024 lines) |
| **Average File Size** | 102.5 lines |
| **Files with Feature Deps** | 8 (16.7%) |
| **Architecture Violations** | 8 issues |
| **Severity (Critical)** | 1 (app_shell) |
| **Severity (Medium)** | 7 others |

---

## 📍 12. FILE SIZE DISTRIBUTION

```
Widgets:        2,090 lines (42.5%)
Models:         1,227 lines (24.9%)
Services:       1,298 lines (26.4%)
Utils:          1,063 lines (21.6%)
Bootstrap:        130 lines (2.6%)
Bloc:              22 lines (0.4%)
Exceptions:         9 lines (0.2%)

TOTAL:          4,922 lines
```

---

## 🎯 Summary

The **shared layer** acts as a central hub for:
- ✅ UI components and layouts
- ✅ Utilities and helpers
- ✅ Local persistence (Hive)
- ✅ Global services (notifications, settings)
- ✅ Error handling and logging
- ✅ Generic data models

**Current Issues:**
- ⚠️ 8 files improperly depend on feature layers
- ⚠️ Feature-specific business logic mixed with reusable widgets
- ⚠️ Missing abstraction layers for bloc dependencies

**Recommended Fix:** Reorganize feature-specific widgets into their respective feature layers and use dependency injection for bloc access.
