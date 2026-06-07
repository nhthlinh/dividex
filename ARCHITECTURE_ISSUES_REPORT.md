# 🔴 **ARCHITECTURE ISSUES REPORT - CLEAN ARCHITECTURE VIOLATIONS**

## 📋 So Sánh Kiến Trúc Mô Tả vs Thực Tế

Bạn mô tả Clean Architecture với 4 tầng:
- **Presentation**: Chỉ hiển thị, stateless, dùng Bloc quản lý state
- **Domain**: Use Case + Repository Interface
- **Data**: Repository Implementation + Data Sources
- **Core**: DI, Logger, Error Handling, Theme

### Hiện Trạng: **❌ Không tuân thủ hoàn toàn**

---

## 🚨 **CÁC VẤN ĐỀ CHÍNH**

### **1. WIDGET LOGIC (CRITICAL - 30+ Pages)**

**Vấn đề**: Tất cả pages là **StatefulWidget** chứa business logic

```dart
// ❌ WRONG - Vi phạm Presentation Layer
class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController groupNameController = TextEditingController();
  List<UserModel> selectedMembers = [];

  void submitGroup() {
    if (_formKey.currentState!.validate()) {
      context.read<GroupBloc>().add(CreateGroupEvent(...));
    }
  }
  
  setState(() { /* UI update */ });
}
```

**Lẽ ra phải**:
```dart
// ✅ CORRECT - Stateless Widget
class AddGroupPage extends StatelessWidget {
  // Không chứa logic, chỉ build UI dựa trên state từ Bloc
  BlocBuilder<GroupBloc, GroupState>(
    builder: (context, state) {
      // UI rendering based on state
    }
  )
}
```

**Danh sách affected pages** (30+):
- `auth/presentation/pages/register_flow/register_page.dart`
- `auth/presentation/pages/login_and_forgot_pass_flow/login_page.dart`
- `group/presentation/pages/add_group_page.dart`
- `group/presentation/pages/group_page.dart`
- `event_expense/presentation/pages/add_expense_page.dart`
- `event_expense/presentation/pages/split_page.dart`
- `friend/presentation/pages/friend_page.dart`
- ... và nhiều pages khác

**Impact**: 
- ❌ Khó kiểm thử (State logic kết hợp UI)
- ❌ Lặp code (form logic lặp lại ở nhiều pages)
- ❌ Khó bảo trì (thay đổi UI phải chỉnh logic)

---

### **2. CIRCULAR DEPENDENCIES (CRITICAL - 8 Cases)**

**Vấn đề**: Shared Layer phụ thuộc Feature Layer (lẽ ra phải ngược lại)

#### **Case 1: choose_members_page.dart**
```dart
// ❌ shared/pages/choose_members_page.dart
import 'features/user/presentation/bloc/user_bloc.dart';
import 'features/user/data/models/user_model.dart';

class ChooseMembersPage extends StatefulWidget {
  context.read<LoadedUsersBloc>().add(...);  // Feature-specific Bloc
}
```

**Hậu quả**:
- Page này bị "locked" vào feature/user
- Không thể tái sử dụng cho features khác
- Nếu change user feature → break shared layer

**Phải sửa**: Tạo `shared/bloc/choose_members_bloc.dart` (generic, không phụ thuộc feature)

#### **Case 2: app_shell.dart**
```dart
// ❌ shared/widgets/app_shell.dart
import 'features/home/presentation/widgets/add_button_widget.dart';
```

#### **Case 3: settle_up_pop_up.dart**
```dart
// ❌ shared/widgets/settle_up_pop_up.dart
import 'features/group/presentation/bloc/group_bloc.dart';
```

#### **Case 4: create_pin.dart**
```dart
// ❌ shared/widgets/create_pin.dart
import 'features/user/presentation/bloc/user_bloc.dart';
```

**Tất cả 8 vấn đề**:
| Widget | Imports | Loại |
|--------|---------|------|
| `choose_members_page.dart` | features/user (bloc, models) | 🔴 Critical |
| `app_shell.dart` | features/home (widgets) | 🔴 Critical |
| `settle_up_pop_up.dart` | features/group (bloc) | 🟡 High |
| `create_pin.dart` | features/user (bloc) | 🟡 High |
| `bar_chart.dart` | features/group (domain) | 🟡 High |
| `user_grid_widget.dart` | features/user (models) | 🟡 High |
| `hive_service.dart` | features/image (models) | 🟡 High |
| `fcm.dart` | features/auth (datasource) | 🟡 High |

---

### **3. MIXING STATE MANAGEMENT PATTERNS (HIGH)**

**Vấn đề**: Pages dùng **cả setState() + Bloc**

```dart
// ❌ WRONG - Mix 2 patterns
class _AddGroupPageState extends State<AddGroupPage> {
  List<UserModel> selectedMembers = [];
  
  void _toggleUser(UserModel user) {
    setState(() {  // <-- setState() management
      _selectedMembers.add(user);
    });
    widget.onSelectedMembersChanged(_selectedMembers);
  }
  
  void submitGroup() {
    context.read<GroupBloc>().add(CreateGroupEvent(...));  // <-- Bloc
  }
}
```

**Vấn đề**:
- Selection logic dùng `setState()`
- Submit logic dùng `Bloc`
- Không nhất quán, khó bảo trì

**Phải sửa**: Tất cả logic → Bloc, widget chỉ `BlocBuilder`

**Ảnh hưởng**:
- ❌ Khó test (setState logic không dễ unit test)
- ❌ State không rõ ràng (setState + Bloc state)
- ❌ Reusability thấp

---

### **4. FEATURE-SPECIFIC MODELS Ở SHARED (HIGH)**

**Vấn đề**: `shared/pages/choose_members_page.dart` import `UserModel` từ features

```dart
// ❌ WRONG
import 'features/user/data/models/user_model.dart';

class ChooseMembersPage extends StatefulWidget {
  final List<UserModel>? initialSelectedMembers;  // Feature model
}
```

**Hậu quả**:
- Shared page phụ thuộc feature data model
- Nếu feature thay đổi model structure → break shared
- Violates layer boundary

**Phải sửa**: Dùng interface hoặc dto chung ở shared layer

---

### **5. STATEFUL PAGE PATTERN - MẬT ĐỘ CAO (MEDIUM)**

**Vấn đề**: TextEditingController + ValueNotifier + GlobalKey quản lý ở Page State

```dart
// ❌ WRONG - Quá nhiều state management ở Page
class _AddExpensePageState extends State<AddExpensePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController expenseNameController = TextEditingController();
  final TextEditingController expenseAmountController = TextEditingController();
  final ValueNotifier<CurrencyEnum> _selectedCurrency = ValueNotifier(...);
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier(...);
  // ... 10+ more ValueNotifiers
  
  @override
  void dispose() {
    expenseNameController.dispose();
    expenseAmountController.dispose();
    // ... Manual disposal x10+
  }
}
```

**Vấn đề**:
- ❌ Quá phức tạp
- ❌ Manual dispose dễ bị quên → memory leak
- ❌ Mỗi field là một controller → khó quản lý
- ❌ ValueNotifier lặp lại ở nhiều pages

**Nên dùng**:
- Bloc form plugin (`flutter_bloc` + form validators)
- Single BlocBuilder for entire form
- Tập trung form state ở 1 chỗ

---

### **6. ERROR HANDLING KHÔNG NHẤT QUÁN (MEDIUM)**

**Vấn đề**: Xử lý lỗi khác nhau ở nhiều chỗ

```dart
// ❌ In AuthBloc
catch (e) {
  showCustomToast(intl.error, type: ToastType.error);
  emit(AuthUnauthenticated());
}

// ❌ In GroupBloc
catch (e) {
  showCustomToast(intl.error, type: ToastType.error);
  // But không emit state - UI không biết error
}
```

**Vấn đề**:
- ❌ Error handling không uniform
- ❌ Một số Bloc không emit error state
- ❌ Toast dùng để hiển thị error (phải dùng state)
- ❌ Khó test error scenarios

**Phải sửa**:
```dart
// ✅ CORRECT
try {
  ...
} catch (e) {
  emit(GroupError(e.toString()));  // Error as state
  // UI subscribe và hiển thị
}
```

---

### **7. DATA SOURCE STRATEGY KHÔNG RÕ RÀNG (MEDIUM)**

**Vấn đề**: Không rõ khi nào dùng Remote vs Local

```dart
// ❌ Không rõ strategy
Future<UserModel> getMe() async {
  return remoteDataSource.getMe();  // Luôn gọi API
  // Không check cache trước?
  // Offline thì sao?
}
```

**Phải sửa**:
```dart
// ✅ CORRECT - Offline-first strategy
Future<UserModel> getMe() async {
  try {
    final remote = await remoteDataSource.getMe();
    await localDataSource.cacheUser(remote);
    return remote;
  } catch (e) {
    return localDataSource.getCachedUser();  // Fallback to cache
  }
}
```

---

### **8. NAVIGATION LOGIC Ở NHIỀU NƠI (MEDIUM)**

**Vấn đề**: Navigation code lặp lại ở Bloc + Pages

```dart
// ❌ In AuthBloc
emit(AuthAuthenticated());
// Nhưng listener page phải:
if (state is AuthAuthenticated) {
  context.go('/home');
}

// ❌ Cũng có listener ở khác chỗ
if (state is AuthAuthenticated) {
  context.pushNamed('home');
}
```

**Vấn đề**:
- ❌ Navigation logic phân tán
- ❌ Có thể có conflict (2 listener navigate cùng lúc)
- ❌ Khó bảo trì

**Phải sửa**: Centralize navigation ở router interceptor

---

### **9. BLOC OVERLOAD - QUẢN LÝ QUÁQUÁ (MEDIUM)**

**Vấn đề**: Một Bloc làm quá nhiều việc

```dart
// ❌ LoadedGroupsBloc
class LoadedGroupsBloc extends Bloc<LoadGroupsEvent, LoadedGroupsState> {
  on<InitialEvent>(_onInitial);           // Load groups
  on<LoadMoreGroupsEvent>(_onLoadMoreGroups);  // Pagination
  on<RefreshGroupsEvent>(_onRefreshGroups);    // Refresh
  on<SearchGroupsEvent>(_onSearchGroups);      // Search
  // + Handle pagination state + loading states
}

// ❌ GroupBloc (tách từ trên)
class GroupBloc extends Bloc<GroupsEvent, GroupState> {
  on<CreateGroupEvent>(_onCreate);
  on<UpdateGroupEvent>(_onUpdate);
  on<DeleteGroupEvent>(_onDelete);
}

// ❌ LoadedGroupsEventsBloc
class LoadedGroupsEventsBloc extends Bloc<...> {
  // Load events in group
}
```

**Vấn đề**:
- ❌ 3 Blocs để quản lý 1 feature (group) → duplicate code
- ❌ Mỗi Bloc handle pagination differently
- ❌ Khó sync state giữa các Bloc

**Có thể refactor thành**:
- `GroupCrudBloc` (create/update/delete)
- `GroupListBloc` (list + pagination + search)
- Tách rõ responsibilities

---

### **10. TESTING DIFFICULTY (MEDIUM)**

**Vấn đề**: Code khó test

```dart
// ❌ Khó test
class _AddGroupPageState extends State {
  void _toggleUser(UserModel user) {
    setState(() {
      selectedMembers.add(user);
    });
    widget.onSelectedMembersChanged(selectedMembers);
  }
}
// Phải test qua UI? setState không có unit test
```

**Nên**:
```dart
// ✅ Dễ test
class AddGroupBloc extends Bloc {
  on<ToggleUserEvent>((event, emit) {
    final updated = [...state.selectedMembers, event.user];
    emit(state.copyWith(selectedMembers: updated));
  });
}
// Unit test: verify state change
```

---

## 📊 **SUMMARY - VIOLATIONS MATRIX**

| Issue | Severity | Count | Layer Violated | Fix Effort |
|-------|----------|-------|---|---|
| StatefulWidget logic | 🔴 Critical | 30+ pages | Presentation | 🟠 High |
| Circular dependencies | 🔴 Critical | 8 components | Layer boundary | 🟠 High |
| setState() + Bloc mix | 🟡 High | 15+ pages | Presentation | 🟠 High |
| Feature models in Shared | 🟡 High | 3+ places | Data/Layer | 🟠 High |
| Form state overload | 🟡 High | 10+ pages | Presentation | 🟠 High |
| Error handling scattered | 🟡 High | All Blocs | Domain/Presentation | 🟡 Medium |
| Data source strategy unclear | 🟡 High | 5+ repo | Data | 🟡 Medium |
| Navigation logic split | 🟡 High | All pages | Presentation | 🟡 Medium |
| Bloc overload | 🟠 Medium | 3 features | Domain | 🟡 Medium |
| Hard to test | 🟠 Medium | Most code | All | 🟡 Medium |

---

## 🎯 **PRIORITY FIXES**

### **Phase 1 - CRITICAL (tuần 1)**
1. **Refactor shared pages to be Stateless**
   - Move state to shared Blocs
   - Xoá setState() calls

2. **Break circular dependencies**
   - Tạo shared/bloc cho generic components
   - Tạo shared/models cho DTOs
   - Remove feature imports từ shared

### **Phase 2 - HIGH (tuần 2)**
3. **Consolidate form handling**
   - Use flutter_bloc form plugin
   - Single form Bloc per page
   - Manual TextEditingController → Bloc

4. **Standardize error handling**
   - Error as state (not toast)
   - Consistent error handling patterns
   - Error state listeners

### **Phase 3 - MEDIUM (tuần 3)**
5. **Clarify data source strategy**
   - Document cache vs remote logic
   - Implement offline-first where needed

6. **Optimize Bloc structure**
   - Evaluate consolidating 3 Blocs for group
   - Share pagination logic

---

## ✅ **FOLLOW CLEAN ARCHITECTURE CHECKLIST**

- [ ] All Pages are StatelessWidget
- [ ] All state managed by Bloc
- [ ] No Bloc imports in shared layer
- [ ] No feature models in shared
- [ ] Error handling as state (not toast)
- [ ] Data source strategy documented
- [ ] No circular dependencies
- [ ] Easy to unit test
- [ ] Form logic in Bloc (not Page)
- [ ] Navigation centralized

---

## 💡 **RECOMMENDED NEXT STEPS**

1. **Audit shared layer completely**
   - Identify all feature dependencies
   - List all StatefulWidgets

2. **Create shared Blocs**
   - `shared/bloc/choose_members_bloc.dart`
   - `shared/bloc/form_validator_bloc.dart`

3. **Migrate one feature at a time**
   - Start with auth (simpler)
   - Then group
   - Then event_expense

4. **Setup testing infrastructure**
   - `flutter_test` + `bloc_test`
   - Test data generators

5. **Document patterns**
   - Create architecture guidelines
   - Code samples for common patterns
