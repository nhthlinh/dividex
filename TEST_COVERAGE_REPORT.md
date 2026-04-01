# DIVIDEX - Test Coverage Report

**Project:** Flask Expense Sharing App  
**Date Generated:** April 1, 2026  
**Coverage Summary:** Statements % | Branch % | Functions % | Lines %

---

## Feature: Auth

**Test Files:**
- `integration_test/login_test.dart`

### ✅ Tested

**UI / User Interactions:**
- Login with valid email and password → navigate to home
- Login with valid email but wrong password → show error and stay on login page
- OTP flow (inferred from test setup)
- Reset password flow (inferred from test setup)
- Form input for email and password with key-based selectors

**State Management:**
- `AuthLoginRequested` event → `AuthAuthenticated` state transition
- `AuthUnauthenticated` state initialization

**Integration Flows:**
- Full login flow: email input → password input → validate → navigate to home
- Error handling on failed login with user feedback

### ❌ Not covered (brief)
- Logout functionality
- Token refresh/expiration
- User registration flow
- Account recovery via email verification
- Multi-factor authentication flows beyond OTP
- Session management edge cases

---

## Feature: Users

**Test Files:**
- `test/features/user/presentation/bloc/user_bloc_test.dart`
- `test/features/user/data/repositories/user_repository_impl_test.dart`
- `test/features/user/data/source/user_remote_datasource_impl_test.dart`
- `test/features/user/presentation/widgets/loaded_users_widget_test.dart`
- `integration_test/user_profile_test.dart`

### ✅ Tested

**API / Repository:**
- Fetch user list for group creation with pagination (`getUserForCreateGroup` - page 1, 5 items per page)
- Return paging model with data, page, totalPage, totalItems
- Fetch current user info (`getMe`)
- Query with search parameter (filter by name/email)
- Throw exception when content is empty
- API mapping from response to PagingModel

**State Management:**
- `GetMeEvent` → emit current user state
- `InitialEvent(LoadType.friends)` → load paginated friend list successfully
- Load friends with search query
- Emit loading state completion

**UI (Widget):**
- Render user full name in tile widget
- Display user ID as subtitle

**Interactions:**
- Profile name input field receives text
- Save button triggers `UpdateMeEvent` with new name
- Avatar upload widget integration (in progress)

**Integration Flows:**
- Profile update flow: display current info → edit name → save → dispatch event
- Avatar upload flow

**Edge Cases:**
- Empty user list handling (throws exception in datasource)
- Null search query parameter
- Pagination boundaries (page 1, multiple pages)

### ❌ Not covered (brief)
- Delete user account
- Friend list filtering (blocked users, pending requests details)
- User search with complex filters
- User presence/online status
- User activity history
- Bulk user operations

---

## Feature: Groups

**Test Files:**
- `test/features/group/presentation/bloc/group_bloc_test.dart`
- `integration_test/group_test.dart`
- `test/features/group/presentation/widgets/member_carousel_test.dart`

### ✅ Tested

**API / Repository:**
- List groups with pagination (`listGroups` - page 1, 1000 items per page)
- Return paging model with search filter ("trip")
- Handle multi-page results (totalPage: 2, totalItems: 3)

**State Management:**
- `InitialEvent(searchQuery)` → load first page groups
- Emit loading state → false when complete
- Return LoadedGroupsBloc state with paginated data

**UI (Widget):**
- MemberCarousel renders PageView with avatars
- Display CircleAvatar for each member
- Handle NetworkImage loading errors gracefully

**Interactions:**
- Choose members from UI selection (via integration test helpers)
- Add group flow with member selection

**Integration Flows:**
- Group creation: enter name → select members → save
- Group settings page: display group info → update members → save

**Edge Cases:**
- Empty group members list (handled by carousel)
- Multiple members in carousel pagination
- Network image loading failures

### ❌ Not covered (brief)
- Delete group
- Leave group
- Group permission/role management
- QR code generation for group invites
- Group activity history
- Group member removal/blocking
- Editing group name/description
- Group privacy settings

---

## Feature: Events

**Test Files:**
- `integration_test/event_test.dart`

### ✅ Tested

**State Management:**
- `EventBloc` state initialization
- `EventDataBloc` for event data caching
- Empty Stream initialization (no side effects)

**UI / Interactions:**
- Add event page rendering with custom buttons
- Select group from dropdown before creating event
- Member selection for event participants
- Event form with localization support

**Integration Flows:**
- Event creation: select group → choose participants → name event → save
- Event settings page with group info display
- Member selection dialog integration

**Edge Cases:**
- Empty event list
- Network errors during event fetch

### ❌ Not covered (brief)
- Event editing
- Event deletion
- Event time validation (start before end)
- Recurring events
- Event categories/types
- Event reminders/notifications
- Attendee RSVP tracking
- Event details retrieval

---

## Feature: Expenses

**Test Files:**
- `integration_test/expense_test.dart`

### ✅ Tested

**UI / Interactions:**
- Add expense page with event selection input
- Payer selection (from group members)
- Expense form with amount and description fields
- Split expense between members
- Choose event from dialog
- Choose payer from members dialog
- Expense report display

**Integration Flows:**
- Full expense creation: select event → select payer → enter amount → split → save
- Expense editing flow
- User debt calculation display

**State Management:**
- `ExpenseBloc` state management
- `ExpenseDataBloc` for caching expense data
- Loading states during expense operations

**Edge Cases:**
- Empty expense list
- Custom split resolver for complex division scenarios

### ❌ Not covered (brief)
- Expense deletion
- Expense attachment/receipt management
- OCR bill parsing
- Bulk expense import
- Expense categorization
- Recurring expenses
- Expense validation rules
- Split algorithm edge cases (3+ way splits details)

---

## Feature: Settlements / Debt

**Test Files:**
- `test/integration/debt_settlement_ui_test.dart`

### ✅ Tested

**UI (Widget):**
- Debt settlement display: show debtor name and amount owed
- Display formatted currency ("VND")
- Render settlement action button (ElevatedButton)
- Show user debt list with amounts

**Interactions:**
- Tap settlement button
- Confirm payment dialog

**Debt Calculation:**
- Calculate settlement between two users
- Display who owes whom and how much

### ❌ Not covered (brief)
- Batch settlement cleanup algorithm
- Multiple debt paths optimization
- Settlement history tracking
- Payment confirmation logic
- Cancel payment flows
- Partial payments
- Settlement between 3+ users

---

## Feature: Payments / Transfers

**Test Files:**
- `integration_test/transfer_full_test.dart`
- `test/integration/wallet_transfer_ui_test.dart`
- `integration_test/wallet_payment_test.dart`

### ✅ Tested

**API / Repository:**
- Account creation (POST /bank_account)
- Account verification (bank account name lookup)
- Account listing with pagination
- Account update (PUT /bank_account/:id)
- Account deletion (DELETE /bank_account/:id)

**UI / Interactions:**
- Transfer page: recipient selection from friends list
- Amount input/validation
- Description input for transfer
- Transfer confirmation page with review
- Recharge page display
- Withdraw page display
- Dialog for selecting from multiple options
- Add bank account page with bank/account number fields

**State Management:**
- `RechargeBloc` for payment operations
- `AccountBloc` for bank account management
- `VerifyAccountBloc` for account verification
- Friend list loading in transfer context

**Integration Flows:**
- Full transfer flow: select recipient → enter amount → enter description → confirm → success
- Add bank account: enter details → verify → save
- Recharge wallet flow
- Withdraw from wallet flow

**Edge Cases:**
- Empty balance handling
- Invalid amount input
- Missing recipient selection

### ❌ Not covered (brief)
- Payment method integration (Stripe, VietQR, etc.)
- Payment history reports
- Transaction fee calculation
- Failed payment retry logic
- Wallet balance updates
- Currency conversion
- Transaction cancellation
- Recurring payment setup

---

## Feature: Friends

**Test Files:**
- `integration_test/friend_test.dart`
- Implied: `features/friend/domain/usecase.dart` tests referenced in user tests

### ✅ Tested

**API / Repository:**
- Friend search by email/name
- Return friend list with status (FriendStatus.none, pending, etc.)
- Fetch friend requests with pagination

**UI / Interactions:**
- Search user input field
- Search button click
- Search result display with friend cards
- Friend card rendering with friend info

**State Management:**
- `LoadedFriendsState` with friend list pagination
- Search query integration

**Integration Flows:**
- Search for friend by email → display results → show friend cards
- Empty search result handling

**Edge Cases:**
- No matching users found
- Empty friend list display
- Friend search with pagination

### ❌ Not covered (brief)
- Add friend request flow
- Accept/reject friend request
- Friend removal/blocking
- Online/offline status
- Friend profile details view
- Mutual friends calculation
- Friend suggestion algorithm
- Friend group organization

---

## Feature: Notifications

**Test Files:**
- `test/features/notifications/presentation/bloc/notification_bloc_test.dart`
- `test/features/notifications/data/repositories/noti_repository_impl_test.dart`
- `test/features/notifications/presentation/pages/noti_page_test.dart`
- `integration_test/message_notification_test.dart` (partial)

### ✅ Tested

**API / Repository:**
- Fetch notifications with pagination (page 1, 20 items per page)
- Return empty notification list
- Paging model structure (page, totalPage, totalItems)

**State Management:**
- `InitialEvent` → `LoadedNotiState` with pagination
- Loading state (`isLoading: false` when complete)
- Page number tracking in state

**UI:**
- Notification page rendering
- Empty notification state display

### ❌ Not covered (brief)
- Mark notification as read
- Delete notification
- Notification types (friend request, expense, payment, etc.)
- Notification filtering
- Real-time notification updates
- Group notifications
- Notification preferences/settings
- Push notification integration
- Notification sound/vibration

---

## Feature: Messages / Chat

**Test Files:**
- `integration_test/message_notification_test.dart`

### ✅ Tested

**State Management:**
- `ChatBloc` initialization
- `LoadedMessageBloc` for message history
- `ChatService` connection state

**UI / Interactions:**
- Chat page rendering
- Message input field
- Send message interaction
- Message list display

**Integration Flows:**
- Chat flow with message history
- Notification page alongside chat

### ❌ Not covered (brief)
- Send message with various content types (text, image, emoji)
- Message editing
- Message deletion
- Message reactions
- Typing indicators
- Read receipts
- Message history pagination
- Group chat vs 1-on-1
- Block user from messaging
- Chat search
- Message persistence

---

## Feature: Dashboard / Home

**Test Files:**
- `test/features/home/presentation/bloc/account_bloc_test.dart`
- `test/features/home/data/repositories/account_repository_impl_test.dart`
- `test/features/home/data/source/account_remote_datasource_impl_test.dart`
- `test/features/home/presentation/widgets/add_button_widget_test.dart`

### ✅ Tested

**State Management:**
- `GetAccountsEvent` → emit accounts list
- Fetch bank accounts with pagination (1, 1000)
- Update AccountState with account data

**UI (Widget):**
- AddButtonPopup renders close button
- Displays action menu items (InkWells)
- Localization support

**API / Repository:**
- Create bank account and return UID
- Verify bank account (return owner name)
- Update account details
- Delete account

### ❌ Not covered (brief)
- Dashboard overview (balance, recent transactions)
- Quick action tiles
- Summary statistics display
- Recent activity feed
- Dashboard filters
- Refresh home data
- Settings menu interactions

---

## Feature: Image Processing / OCR

**Test Files:**
- `test/features/image/presentation/widgets/image_edit_widget_test.dart`

### ✅ Tested

**UI (Widget):**
- Image editor displays rotation/crop buttons
- Rotate left icon button
- Rotate right icon button
- Flip icon button
- Crop icon button
- PNG image loading and rendering

**Interactions:**
- Image editing UI rendering

### ❌ Not covered (brief)
- Image cropping functionality
- Image rotation application
- Image flip functionality
- OCR bill parsing accuracy
- Receipt data extraction
- Image upload to server
- Image compression
- Multiple image handling
- Image undo/redo

---

## Feature: Search / Reports

**Test Files:**
- `integration_test/search_report_test.dart` (inferred from file list)

### ❌ Not covered (in detail - test file referenced but not fully analyzed)

Likely covers:
- Search across expenses
- Generate reports
- Filter by date range, group, category

---

## Core Infrastructure

### API / Network Layer

**Test Files:**
- `test/core/network/dio_client_test.dart`

### ✅ Tested

**API Call Wrapper:**
- Successful API call returns value
- DioException with response data → formatted exception with message_code and message
- DioException without response → network error exception
- Non-DioException → rethrown as-is (e.g., StateError)
- Error message formatting (includes error code and text)

**Error Handling:**
- 400 status code with "INVALID_INPUT" and message
- Network timeout errors
- Status code extraction from response

### ❌ Not covered (brief)
- Connection retry logic
- Timeout configuration
- Request interceptors (auth tokens, etc.)
- Response interceptors
- File upload/download
- Streaming responses
- Certificate pinning

---

### Services

**Test Files:**
- `test/core/services/device_info_service_test.dart`

### ⚠️ Not Testable
- DeviceInfoService marked as "hard to isolate"
- Platform-specific device information retrieval
- Note: This is a documentation of testability constraints, not a test

---

## Shared / Utilities

**Test Files:**
- `test/shared/utils/validation_input_test.dart`
- `test/shared/utils/jwt_decoder_test.dart` (inferred)

### ✅ Tested

**Email Validation:**
- Null/empty email → error message
- Invalid email format → error message
- Valid email (john.doe@example.com) → pass

**Password Validation:**
- Empty password → error
- Too short (< 8 chars) → error
- Weak password (missing character groups) → error
- Strong password (mixed case, numbers, symbols) → pass

**Confirm Password Validation:**
- Empty confirm password → error
- Passwords don't match → error
- Passwords match → pass

**Amount Validation:**
- Empty amount → error
- Non-numeric input → error
- Zero/negative amount → error
- Valid positive number → pass

**Phone Number Validation:**
- Empty phone → error
- Invalid format → error
- Valid phone number → pass

**Name Validation:**
- Empty name → error
- Invalid characters → error
- Valid name → pass

**OTP Validation:**
- Empty OTP → error
- Invalid format → error
- Valid OTP → pass

**PIN Validation:**
- Empty PIN → error
- Invalid format → error
- Valid PIN → pass

**Event Date Validation:**
- Empty start/end date → error
- Invalid date format → error
- Start date after end date → error
- Valid date range → pass

### ❌ Not covered (brief)
- Cross-field validation (e.g., password vs confirm password)
- Async validation (server-side)
- Localization of validation messages in other languages
- Special character handling
- Unicode support

---

## Configuration / Routing

**Test Files:**
- `integration_test/app_route_traversal_test.dart`
- `integration_test/app_route_traversal_mocked_test.dart` (inferred from file list)

### ⚠️ Inferred Coverage
- Navigation between routes
- Router initialization
- Path traversal (likely testing route names and destinations)

---

## Summary: Testing Patterns Observed

### ✅ Well-Covered Areas
1. **BLoC State Management** - Most features have bloc tests with events/states
2. **API Layer** - Repository and datasource tests with mocked Dio client
3. **Critical User Flows** - Login, transfer, group creation, expense creation
4. **Form Validation** - Comprehensive input validation tests
5. **Widget Rendering** - Basic widget tests for UI feedback (loading, empty states)
6. **Pagination** - Paging model tests across multiple features
7. **Error Handling** - API exceptions, validation errors

### ❌ Gaps / Low Coverage Areas
1. **feature/admins** - No test files found
2. **feature/config** - Coverage marked as "very low"
3. **feature/groups** - Partial (create only, no delete/update/leave)
4. **shared/widgets** - Only a few widget tests; most UI not covered
5. **Feature Depth** - Most tests focus on happy path; edge cases and error flows limited
6. **Integration Tests** - Only core flows tested; many feature interactions not covered
7. **State Transitions** - Limited testing of state machine edge cases
8. **Concurrent Operations** - No tests for race conditions
9. **Performance Tests** - No load/performance tests
10. **Accessibility** - No semantic or accessibility tests

### 🎯 Key Testing Tools Used
- **flutter_test** - Widget tests
- **mocktail** - Mocking dependencies
- **integration_test** - Full-flow testing
- **BLoC pattern** - State management testing
- **Fake/Mock Classes** - Dependency injection for tests

---

## Recommendations for Next Steps

1. **Increase Admin Feature Tests** - Current gap in admin dashboard coverage
2. **Expand UI Widget Tests** - Cover more widgets and conditional states
3. **Edge Case Coverage** - Add tests for error scenarios, network failures
4. **Notification System** - Expand real-time notification testing
5. **Concurrency Tests** - Test race conditions in multi-user operations
6. **Performance Regression** - Add benchmark tests for key operations
7. **Accessibility** - Add semantic and a11y tests for compliance

