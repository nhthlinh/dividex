import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// No description provided for @addGroup.
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get addGroup;

  /// No description provided for @addEvent.
  ///
  /// In en, this message translates to:
  /// **'Add event'**
  String get addEvent;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error, please try again later!'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Successfully!'**
  String get success;

  /// No description provided for @otpSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email has been sent'**
  String get otpSentSuccess;

  /// No description provided for @emailInput.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailInput;

  /// No description provided for @emailInputDescription.
  ///
  /// In en, this message translates to:
  /// **'We will send a link to your email.'**
  String get emailInputDescription;

  /// No description provided for @passwordInputDescription.
  ///
  /// In en, this message translates to:
  /// **'Contain at least 8 characters, including uppercase, lowercase, numbers, and special characters.'**
  String get passwordInputDescription;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Type your email '**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get loginWithGoogle;

  /// No description provided for @loginPageToRegister.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have account?'**
  String get loginPageToRegister;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @otpInputPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your Email'**
  String get otpInputPageTitle;

  /// No description provided for @otpInputPageDescription.
  ///
  /// In en, this message translates to:
  /// **'We have sent a link to your email.'**
  String get otpInputPageDescription;

  /// No description provided for @otpInputPageDidntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive email?'**
  String get otpInputPageDidntReceiveCode;

  /// No description provided for @otpInputPageResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get otpInputPageResend;

  /// No description provided for @otpInputError1.
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP code'**
  String get otpInputError1;

  /// No description provided for @resetPassPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassPageTitle;

  /// No description provided for @resetPassPageDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password below.'**
  String get resetPassPageDescription;

  /// No description provided for @resetPassNewPassHint.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get resetPassNewPassHint;

  /// No description provided for @resetPassConfirmPassHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get resetPassConfirmPassHint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @resetPassSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully!'**
  String get resetPassSuccess;

  /// No description provided for @resetPassError.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset password. Please try again.'**
  String get resetPassError;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordInputDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your password again'**
  String get confirmPasswordInputDescription;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @registerPageToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get registerPageToLogin;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Email already exists'**
  String get emailAlreadyExists;

  /// No description provided for @phoneNumberAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Phone number already exists'**
  String get phoneNumberAlreadyExists;

  /// No description provided for @emailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Email not found'**
  String get emailNotFound;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'Can not find account with this email. Please create a new one!'**
  String get userNotFound;

  /// No description provided for @noTransaction.
  ///
  /// In en, this message translates to:
  /// **'You have no transactions'**
  String get noTransaction;

  /// No description provided for @addFirstTransaction.
  ///
  /// In en, this message translates to:
  /// **'Let\'s add your first transaction in group'**
  String get addFirstTransaction;

  /// No description provided for @expenseNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Expense\'s name'**
  String get expenseNameLabel;

  /// No description provided for @expenseNameHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: Dinner'**
  String get expenseNameHint;

  /// No description provided for @expenseAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseAmountLabel;

  /// No description provided for @expenseAmountHint.
  ///
  /// In en, this message translates to:
  /// **'120.000'**
  String get expenseAmountHint;

  /// No description provided for @expenseCurrencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get expenseCurrencyLabel;

  /// No description provided for @expenseCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expenseCategoryLabel;

  /// No description provided for @expenseEventLabel.
  ///
  /// In en, this message translates to:
  /// **'Belong to event'**
  String get expenseEventLabel;

  /// No description provided for @expensePayerLabel.
  ///
  /// In en, this message translates to:
  /// **'Payer'**
  String get expensePayerLabel;

  /// No description provided for @expenseSplitEquallyLabel.
  ///
  /// In en, this message translates to:
  /// **'Split equally'**
  String get expenseSplitEquallyLabel;

  /// No description provided for @expenseSplitCustomLabel.
  ///
  /// In en, this message translates to:
  /// **'Split custom'**
  String get expenseSplitCustomLabel;

  /// No description provided for @addConfigLabel.
  ///
  /// In en, this message translates to:
  /// **'Add more config'**
  String get addConfigLabel;

  /// No description provided for @expenseNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get expenseNoteLabel;

  /// No description provided for @expenseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get expenseDateLabel;

  /// No description provided for @expenseReminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get expenseReminderLabel;

  /// No description provided for @addExpenseImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get addExpenseImageLabel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @eventNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Event\'s name'**
  String get eventNameLabel;

  /// No description provided for @eventNameHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: Go out on Sunday'**
  String get eventNameHint;

  /// No description provided for @eventGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Belong to group'**
  String get eventGroupLabel;

  /// No description provided for @eventStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Event\'s start day'**
  String get eventStartDateLabel;

  /// No description provided for @eventEndDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Event\'s end day'**
  String get eventEndDateLabel;

  /// No description provided for @eventMembers.
  ///
  /// In en, this message translates to:
  /// **'Event\'s members'**
  String get eventMembers;

  /// No description provided for @eventDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Event\'s description'**
  String get eventDescriptionLabel;

  /// No description provided for @eventDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: Go out with family on weekend'**
  String get eventDescriptionHint;

  /// No description provided for @addGroupImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Group\'s avatar'**
  String get addGroupImageLabel;

  /// No description provided for @groupNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group\'s name'**
  String get groupNameLabel;

  /// No description provided for @groupNameHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: Class 12L'**
  String get groupNameHint;

  /// No description provided for @appTitleHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get appTitleHome;

  /// No description provided for @searchTab.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTab;

  /// No description provided for @appTitleCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get appTitleCommunity;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'Qr code'**
  String get qrCode;

  /// No description provided for @profileSetting.
  ///
  /// In en, this message translates to:
  /// **'Profile setting'**
  String get profileSetting;

  /// No description provided for @settingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingLanguage;

  /// No description provided for @settingChooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language for your app'**
  String get settingChooseLanguage;

  /// No description provided for @settingChooseEng.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingChooseEng;

  /// No description provided for @settingChooseVie.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get settingChooseVie;

  /// No description provided for @settingTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingTheme;

  /// No description provided for @settingChooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme for your app'**
  String get settingChooseTheme;

  /// No description provided for @settingChooseDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingChooseDark;

  /// No description provided for @settingChooseLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingChooseLight;

  /// No description provided for @settingTerm.
  ///
  /// In en, this message translates to:
  /// **'Term of use'**
  String get settingTerm;

  /// No description provided for @settingSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingSecurity;

  /// No description provided for @securitySettings.
  ///
  /// In en, this message translates to:
  /// **'Security Setting'**
  String get securitySettings;

  /// No description provided for @settingChangePass.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get settingChangePass;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get minute;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @ago.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get ago;

  /// No description provided for @emailInputError1.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get emailInputError1;

  /// No description provided for @emailInputError2.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get emailInputError2;

  /// No description provided for @passInputError1.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passInputError1;

  /// No description provided for @passInputError2.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be shorter than 8 characters'**
  String get passInputError2;

  /// No description provided for @passInputError3.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter, one uppercase letter, one number, and one special character'**
  String get passInputError3;

  /// No description provided for @passInputError4.
  ///
  /// In en, this message translates to:
  /// **'Repeated password does not match'**
  String get passInputError4;

  /// No description provided for @phoneInputError1.
  ///
  /// In en, this message translates to:
  /// **'Phone number cannot be empty'**
  String get phoneInputError1;

  /// No description provided for @phoneInputError2.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get phoneInputError2;

  /// No description provided for @nameInputError1.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameInputError1;

  /// No description provided for @nameInputError2.
  ///
  /// In en, this message translates to:
  /// **'Name must be more than 2 and less than 50 characters'**
  String get nameInputError2;

  /// No description provided for @amountInputError1.
  ///
  /// In en, this message translates to:
  /// **'Total expense cannot be empty'**
  String get amountInputError1;

  /// No description provided for @amountInputError2.
  ///
  /// In en, this message translates to:
  /// **'Invalid total expense'**
  String get amountInputError2;

  /// No description provided for @amountInputError3.
  ///
  /// In en, this message translates to:
  /// **'Total expense must be greater than 0'**
  String get amountInputError3;

  /// No description provided for @eventStartError1.
  ///
  /// In en, this message translates to:
  /// **'Start date cannot be empty'**
  String get eventStartError1;

  /// No description provided for @eventEndError1.
  ///
  /// In en, this message translates to:
  /// **'End date cannot be empty'**
  String get eventEndError1;

  /// No description provided for @eventStartError2.
  ///
  /// In en, this message translates to:
  /// **'Invalid start date'**
  String get eventStartError2;

  /// No description provided for @eventEndError2.
  ///
  /// In en, this message translates to:
  /// **'Invalid end date'**
  String get eventEndError2;

  /// No description provided for @eventStartAfterEndError.
  ///
  /// In en, this message translates to:
  /// **'Start date cannot be after end date'**
  String get eventStartAfterEndError;

  /// No description provided for @eventEndBeforeStartError.
  ///
  /// In en, this message translates to:
  /// **'End date cannot be before start date'**
  String get eventEndBeforeStartError;

  /// No description provided for @less.
  ///
  /// In en, this message translates to:
  /// **'less'**
  String get less;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get more;

  /// No description provided for @imagePicker1.
  ///
  /// In en, this message translates to:
  /// **'Choose image from gallery'**
  String get imagePicker1;

  /// No description provided for @imagePicker2.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get imagePicker2;

  /// No description provided for @imagePickerError1.
  ///
  /// In en, this message translates to:
  /// **'Image selection failed, please try again'**
  String get imagePickerError1;

  /// No description provided for @cropImage.
  ///
  /// In en, this message translates to:
  /// **'Edit image'**
  String get cropImage;

  /// No description provided for @sumary.
  ///
  /// In en, this message translates to:
  /// **'Sumary'**
  String get sumary;

  /// No description provided for @recentTransaction.
  ///
  /// In en, this message translates to:
  /// **'Recent transaction'**
  String get recentTransaction;

  /// No description provided for @youOwn.
  ///
  /// In en, this message translates to:
  /// **'You own'**
  String get youOwn;

  /// No description provided for @ownYou.
  ///
  /// In en, this message translates to:
  /// **'Own you'**
  String get ownYou;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @friend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friend;

  /// No description provided for @remind.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get remind;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Settle up'**
  String get pay;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @noFriends.
  ///
  /// In en, this message translates to:
  /// **'You have no friend'**
  String get noFriends;

  /// No description provided for @addFirstFriend.
  ///
  /// In en, this message translates to:
  /// **'Find your friend and add them'**
  String get addFirstFriend;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addFriend;

  /// No description provided for @sendFriendRequestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your request has been sent'**
  String get sendFriendRequestSuccess;

  /// No description provided for @addFriendMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Hi, nice to meet you'**
  String get addFriendMessageHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @tryDifferentKeyword.
  ///
  /// In en, this message translates to:
  /// **'Try different keyword'**
  String get tryDifferentKeyword;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'Found nothing'**
  String get noSearchResults;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @addFriendMessage.
  ///
  /// In en, this message translates to:
  /// **'Friend request'**
  String get addFriendMessage;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @transportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get transportation;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utilities;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @housing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get housing;

  /// No description provided for @healthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get healthcare;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @miscellaneous.
  ///
  /// In en, this message translates to:
  /// **'Miscellaneous'**
  String get miscellaneous;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'TERMS OF SERVICE'**
  String get termsOfServiceTitle;

  /// No description provided for @dIVIDEXApp.
  ///
  /// In en, this message translates to:
  /// **'DIVIDEX'**
  String get dIVIDEXApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version: {versionNumber}'**
  String version(Object versionNumber);

  /// No description provided for @effectiveDate.
  ///
  /// In en, this message translates to:
  /// **'Effective Date: {date}'**
  String effectiveDate(Object date);

  /// No description provided for @acceptanceOfTerms.
  ///
  /// In en, this message translates to:
  /// **'1. ACCEPTANCE OF TERMS'**
  String get acceptanceOfTerms;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to DIVIDEX (\"App\", \"Service\", \"we\", or \"DIVIDEX\").'**
  String get welcomeMessage;

  /// No description provided for @agreementText.
  ///
  /// In en, this message translates to:
  /// **'By accessing, downloading, installing, or using the App, you agree to be bound by these Terms of Service (\"Terms\").'**
  String get agreementText;

  /// No description provided for @disagreementText.
  ///
  /// In en, this message translates to:
  /// **'If you do not agree with any part of these Terms, please do not use our Service.'**
  String get disagreementText;

  /// No description provided for @serviceDescription.
  ///
  /// In en, this message translates to:
  /// **'2. SERVICE DESCRIPTION'**
  String get serviceDescription;

  /// No description provided for @dIVIDEXDescription.
  ///
  /// In en, this message translates to:
  /// **'DIVIDEX is an application designed to help users manage and share group expenses, offering the following features:'**
  String get dIVIDEXDescription;

  /// No description provided for @createGroups.
  ///
  /// In en, this message translates to:
  /// **'Create and manage expense-sharing groups.'**
  String get createGroups;

  /// No description provided for @trackExpenses.
  ///
  /// In en, this message translates to:
  /// **'Track and record shared expenses.'**
  String get trackExpenses;

  /// No description provided for @splitPayments.
  ///
  /// In en, this message translates to:
  /// **'Split and allocate costs among group members.'**
  String get splitPayments;

  /// No description provided for @sendReminders.
  ///
  /// In en, this message translates to:
  /// **'Sending payment reminders.'**
  String get sendReminders;

  /// No description provided for @generateReports.
  ///
  /// In en, this message translates to:
  /// **'Generate expense reports for groups.'**
  String get generateReports;

  /// No description provided for @socialInteractions.
  ///
  /// In en, this message translates to:
  /// **'Interact with group members through comments and notifications.'**
  String get socialInteractions;

  /// No description provided for @receiveNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications about transactions and related activities.'**
  String get receiveNotifications;

  /// No description provided for @accountRegistrationSecurity.
  ///
  /// In en, this message translates to:
  /// **'3. ACCOUNT REGISTRATION AND SECURITY'**
  String get accountRegistrationSecurity;

  /// No description provided for @registrationRequirements.
  ///
  /// In en, this message translates to:
  /// **'3.1 Registration Requirements'**
  String get registrationRequirements;

  /// No description provided for @ageRequirement.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 13 years old to use the Service.'**
  String get ageRequirement;

  /// No description provided for @accurateInfo.
  ///
  /// In en, this message translates to:
  /// **'Registration information must be accurate, complete, and kept up to date.'**
  String get accurateInfo;

  /// No description provided for @oneUniqueAccount.
  ///
  /// In en, this message translates to:
  /// **'Each user may only create one unique account.'**
  String get oneUniqueAccount;

  /// No description provided for @emailVerification.
  ///
  /// In en, this message translates to:
  /// **'You must verify your email via OTP code.'**
  String get emailVerification;

  /// No description provided for @accountSecurity.
  ///
  /// In en, this message translates to:
  /// **'3.2 Account Security'**
  String get accountSecurity;

  /// No description provided for @passwordProtection.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for protecting your password and login credentials.'**
  String get passwordProtection;

  /// No description provided for @unauthorizedUse.
  ///
  /// In en, this message translates to:
  /// **'Notify us immediately if you detect unauthorized use of your account.'**
  String get unauthorizedUse;

  /// No description provided for @noSharingResponsibility.
  ///
  /// In en, this message translates to:
  /// **'We are not responsible for damages caused by sharing login information.'**
  String get noSharingResponsibility;

  /// No description provided for @useOfService.
  ///
  /// In en, this message translates to:
  /// **'4. USE OF SERVICE'**
  String get useOfService;

  /// No description provided for @grantedRights.
  ///
  /// In en, this message translates to:
  /// **'4.1 Granted Rights'**
  String get grantedRights;

  /// No description provided for @limitedRight.
  ///
  /// In en, this message translates to:
  /// **'We grant you a limited, non-exclusive, non-transferable right to:'**
  String get limitedRight;

  /// No description provided for @accessUsePersonal.
  ///
  /// In en, this message translates to:
  /// **'Access and use the App for personal, non-commercial purposes.'**
  String get accessUsePersonal;

  /// No description provided for @manageShareExpenses.
  ///
  /// In en, this message translates to:
  /// **'Manage and share group expenses in accordance with these Terms.'**
  String get manageShareExpenses;

  /// No description provided for @usageRestrictions.
  ///
  /// In en, this message translates to:
  /// **'4.2 Usage Restrictions'**
  String get usageRestrictions;

  /// No description provided for @mayNot.
  ///
  /// In en, this message translates to:
  /// **'You MUST NOT:'**
  String get mayNot;

  /// No description provided for @illegalPurposes.
  ///
  /// In en, this message translates to:
  /// **'Use the Service for illegal or unauthorized purposes.'**
  String get illegalPurposes;

  /// No description provided for @fakeAccounts.
  ///
  /// In en, this message translates to:
  /// **'Create fake accounts or provide false information.'**
  String get fakeAccounts;

  /// No description provided for @spamHarass.
  ///
  /// In en, this message translates to:
  /// **'Send spam, harass, or abuse other users.'**
  String get spamHarass;

  /// No description provided for @manipulateData.
  ///
  /// In en, this message translates to:
  /// **'Manipulate or provide false expense information.'**
  String get manipulateData;

  /// No description provided for @botsScripts.
  ///
  /// In en, this message translates to:
  /// **'Use bots, scripts, or automated tools to access the Service.'**
  String get botsScripts;

  /// No description provided for @hackSabotage.
  ///
  /// In en, this message translates to:
  /// **'Attempt to hack, sabotage, or illegally collect data from the system.'**
  String get hackSabotage;

  /// No description provided for @userContent.
  ///
  /// In en, this message translates to:
  /// **'5. USER CONTENT'**
  String get userContent;

  /// No description provided for @contentOwnership.
  ///
  /// In en, this message translates to:
  /// **'5.1 Content Ownership'**
  String get contentOwnership;

  /// No description provided for @retainOwnership.
  ///
  /// In en, this message translates to:
  /// **'You retain ownership of the content you create (e.g., expense details, comments).'**
  String get retainOwnership;

  /// No description provided for @dIVIDEXContentRights.
  ///
  /// In en, this message translates to:
  /// **'By providing content, you grant DIVIDEX the right to use, display, and distribute that content within the App.'**
  String get dIVIDEXContentRights;

  /// No description provided for @contentStandards.
  ///
  /// In en, this message translates to:
  /// **'5.2 Content Standards'**
  String get contentStandards;

  /// No description provided for @mustNot.
  ///
  /// In en, this message translates to:
  /// **'Content provided MUST NOT:'**
  String get mustNot;

  /// No description provided for @falseInfo.
  ///
  /// In en, this message translates to:
  /// **'Contain false, fraudulent, or misleading information.'**
  String get falseInfo;

  /// No description provided for @violatePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Violate the privacy rights of others.'**
  String get violatePrivacy;

  /// No description provided for @offensiveContent.
  ///
  /// In en, this message translates to:
  /// **'Contain offensive, violent, or discriminatory content.'**
  String get offensiveContent;

  /// No description provided for @unauthorizedAdvertising.
  ///
  /// In en, this message translates to:
  /// **'Include unauthorized advertising or sales.'**
  String get unauthorizedAdvertising;

  /// No description provided for @sharePersonalWithoutConsent.
  ///
  /// In en, this message translates to:
  /// **'Share others\' personal information without consent.'**
  String get sharePersonalWithoutConsent;

  /// No description provided for @moderationRights.
  ///
  /// In en, this message translates to:
  /// **'5.3 Moderation Rights'**
  String get moderationRights;

  /// No description provided for @reviewRemoveContent.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to review and remove violating content without prior notice.'**
  String get reviewRemoveContent;

  /// No description provided for @moderationDecisionsFinal.
  ///
  /// In en, this message translates to:
  /// **'Our moderation decisions are final.'**
  String get moderationDecisionsFinal;

  /// No description provided for @privacyDataProtection.
  ///
  /// In en, this message translates to:
  /// **'6. PRIVACY AND DATA PROTECTION'**
  String get privacyDataProtection;

  /// No description provided for @informationCollection.
  ///
  /// In en, this message translates to:
  /// **'6.1 Information Collection'**
  String get informationCollection;

  /// No description provided for @collectProcessInfo.
  ///
  /// In en, this message translates to:
  /// **'We collect and process personal information in accordance with our Privacy Policy, including:'**
  String get collectProcessInfo;

  /// No description provided for @profileInfo.
  ///
  /// In en, this message translates to:
  /// **'Profile information (name, email, avatar).'**
  String get profileInfo;

  /// No description provided for @expenseData.
  ///
  /// In en, this message translates to:
  /// **'Expense and transaction data for groups.'**
  String get expenseData;

  /// No description provided for @appUsageInfo.
  ///
  /// In en, this message translates to:
  /// **'App usage information.'**
  String get appUsageInfo;

  /// No description provided for @informationSharing.
  ///
  /// In en, this message translates to:
  /// **'6.2 Information Sharing'**
  String get informationSharing;

  /// No description provided for @infoDisplayedPublicly.
  ///
  /// In en, this message translates to:
  /// **'Your information (e.g., group expenses) may be displayed publicly within groups based on privacy settings.'**
  String get infoDisplayedPublicly;

  /// No description provided for @noSellToThirdParties.
  ///
  /// In en, this message translates to:
  /// **'We do not sell personal information to third parties.'**
  String get noSellToThirdParties;

  /// No description provided for @sharedWithPartners.
  ///
  /// In en, this message translates to:
  /// **'Information may be shared with service partners to operate the App.'**
  String get sharedWithPartners;

  /// No description provided for @freePaidFeatures.
  ///
  /// In en, this message translates to:
  /// **'7. FREE AND PAID FEATURES'**
  String get freePaidFeatures;

  /// No description provided for @freeFeatures.
  ///
  /// In en, this message translates to:
  /// **'7.1 Free Features'**
  String get freeFeatures;

  /// No description provided for @basicFeaturesFree.
  ///
  /// In en, this message translates to:
  /// **'The App’s basic features are provided free of charge, including:'**
  String get basicFeaturesFree;

  /// No description provided for @createGroupsExpenses.
  ///
  /// In en, this message translates to:
  /// **'Creating groups and recording expenses.'**
  String get createGroupsExpenses;

  /// No description provided for @basicSplitPayments.
  ///
  /// In en, this message translates to:
  /// **'Basic cost-splitting functionality.'**
  String get basicSplitPayments;

  /// No description provided for @basicReports.
  ///
  /// In en, this message translates to:
  /// **'Generating basic expense reports.'**
  String get basicReports;

  /// No description provided for @paidFeatures.
  ///
  /// In en, this message translates to:
  /// **'7.2 Paid Features'**
  String get paidFeatures;

  /// No description provided for @premiumFeaturesPayment.
  ///
  /// In en, this message translates to:
  /// **'Premium features (e.g., advanced reports or payment integrations) may require payment.'**
  String get premiumFeaturesPayment;

  /// No description provided for @transactionsNotified.
  ///
  /// In en, this message translates to:
  /// **'All transactions will be clearly notified before completion.'**
  String get transactionsNotified;

  /// No description provided for @refundPolicyPublished.
  ///
  /// In en, this message translates to:
  /// **'Refund policies will be published separately.'**
  String get refundPolicyPublished;

  /// No description provided for @intellectualProperty.
  ///
  /// In en, this message translates to:
  /// **'8. INTELLECTUAL PROPERTY'**
  String get intellectualProperty;

  /// No description provided for @dIVIDEXsRights.
  ///
  /// In en, this message translates to:
  /// **'8.1 DIVIDEX’s Rights'**
  String get dIVIDEXsRights;

  /// No description provided for @appInterfaceLogoOwned.
  ///
  /// In en, this message translates to:
  /// **'The App, interface, logo, and materials are owned by DIVIDEX.'**
  String get appInterfaceLogoOwned;

  /// No description provided for @copyingProhibited.
  ///
  /// In en, this message translates to:
  /// **'Copying, distributing, or creating derivative works is strictly prohibited.'**
  String get copyingProhibited;

  /// No description provided for @respectingCopyright.
  ///
  /// In en, this message translates to:
  /// **'8.2 Respecting Copyright'**
  String get respectingCopyright;

  /// No description provided for @respectOthersRights.
  ///
  /// In en, this message translates to:
  /// **'We respect the intellectual property rights of others.'**
  String get respectOthersRights;

  /// No description provided for @handleInfringement.
  ///
  /// In en, this message translates to:
  /// **'We will address copyright infringement claims in accordance with applicable law.'**
  String get handleInfringement;

  /// No description provided for @serviceTermination.
  ///
  /// In en, this message translates to:
  /// **'9. SERVICE TERMINATION'**
  String get serviceTermination;

  /// No description provided for @terminationByUser.
  ///
  /// In en, this message translates to:
  /// **'9.1 Termination by User'**
  String get terminationByUser;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'You may delete your account at any time through the App’s settings.'**
  String get deleteAccount;

  /// No description provided for @infoRetainedLaw.
  ///
  /// In en, this message translates to:
  /// **'Some information may be retained as required by law.'**
  String get infoRetainedLaw;

  /// No description provided for @terminationByDIVIDEX.
  ///
  /// In en, this message translates to:
  /// **'9.2 Termination by DIVIDEX'**
  String get terminationByDIVIDEX;

  /// No description provided for @suspendTerminateAccounts.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to suspend or terminate accounts if:'**
  String get suspendTerminateAccounts;

  /// No description provided for @violatingTerms.
  ///
  /// In en, this message translates to:
  /// **'You violate these Terms.'**
  String get violatingTerms;

  /// No description provided for @illegalHarmfulActivities.
  ///
  /// In en, this message translates to:
  /// **'You engage in illegal or harmful activities.'**
  String get illegalHarmfulActivities;

  /// No description provided for @lawEnforcementRequests.
  ///
  /// In en, this message translates to:
  /// **'Requested by law enforcement authorities.'**
  String get lawEnforcementRequests;

  /// No description provided for @discontinuingService.
  ///
  /// In en, this message translates to:
  /// **'The Service is discontinued.'**
  String get discontinuingService;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'10. DISCLAIMER'**
  String get disclaimer;

  /// No description provided for @asIsService.
  ///
  /// In en, this message translates to:
  /// **'10.1 Service “As Is”'**
  String get asIsService;

  /// No description provided for @serviceProvidedAsIs.
  ///
  /// In en, this message translates to:
  /// **'The Service is provided “as is” and “as available”.'**
  String get serviceProvidedAsIs;

  /// No description provided for @noGuaranteeOperation.
  ///
  /// In en, this message translates to:
  /// **'We do not guarantee uninterrupted, error-free, or fully secure operation.'**
  String get noGuaranteeOperation;

  /// No description provided for @limitationOfLiability.
  ///
  /// In en, this message translates to:
  /// **'10.2 Limitation of Liability'**
  String get limitationOfLiability;

  /// No description provided for @noResponsibilityUserContent.
  ///
  /// In en, this message translates to:
  /// **'DIVIDEX is not responsible for user-generated content or transactions.'**
  String get noResponsibilityUserContent;

  /// No description provided for @noGuaranteeAccuracy.
  ///
  /// In en, this message translates to:
  /// **'We do not guarantee the accuracy of expense information provided by other users.'**
  String get noGuaranteeAccuracy;

  /// No description provided for @noResponsibilityIndirectDamages.
  ///
  /// In en, this message translates to:
  /// **'We are not liable for indirect, incidental, or consequential damages.'**
  String get noResponsibilityIndirectDamages;

  /// No description provided for @disputeResolution.
  ///
  /// In en, this message translates to:
  /// **'11. DISPUTE RESOLUTION'**
  String get disputeResolution;

  /// No description provided for @negotiation.
  ///
  /// In en, this message translates to:
  /// **'11.1 Negotiation'**
  String get negotiation;

  /// No description provided for @resolveThroughNegotiation.
  ///
  /// In en, this message translates to:
  /// **'Disputes will be resolved through good-faith negotiation first.'**
  String get resolveThroughNegotiation;

  /// No description provided for @applicableLaw.
  ///
  /// In en, this message translates to:
  /// **'11.2 Applicable Law'**
  String get applicableLaw;

  /// No description provided for @termsGovernedByLaw.
  ///
  /// In en, this message translates to:
  /// **'These Terms are governed by the laws of Vietnam.'**
  String get termsGovernedByLaw;

  /// No description provided for @courtJurisdiction.
  ///
  /// In en, this message translates to:
  /// **'11.3 Court Jurisdiction'**
  String get courtJurisdiction;

  /// No description provided for @competentCourtsResolve.
  ///
  /// In en, this message translates to:
  /// **'Competent courts in Vietnam will resolve disputes that cannot be settled through negotiation.'**
  String get competentCourtsResolve;

  /// No description provided for @termsUpdates.
  ///
  /// In en, this message translates to:
  /// **'12. TERMS UPDATES'**
  String get termsUpdates;

  /// No description provided for @rightToModify.
  ///
  /// In en, this message translates to:
  /// **'12.1 Right to Modify'**
  String get rightToModify;

  /// No description provided for @updateTerms.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to update these Terms at any time.'**
  String get updateTerms;

  /// No description provided for @notificationsSent.
  ///
  /// In en, this message translates to:
  /// **'Notifications will be sent via the App or registered email.'**
  String get notificationsSent;

  /// No description provided for @acceptingChanges.
  ///
  /// In en, this message translates to:
  /// **'12.2 Accepting Changes'**
  String get acceptingChanges;

  /// No description provided for @continuedUseMeansAgreement.
  ///
  /// In en, this message translates to:
  /// **'Continued use of the Service after updates means you agree to the new Terms.'**
  String get continuedUseMeansAgreement;

  /// No description provided for @disagreeStopUse.
  ///
  /// In en, this message translates to:
  /// **'If you disagree, please stop using the Service.'**
  String get disagreeStopUse;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'13. CONTACT INFORMATION'**
  String get contactInformation;

  /// No description provided for @questionsContact.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about these Terms, please contact:'**
  String get questionsContact;

  /// No description provided for @dIVIDEXTeam.
  ///
  /// In en, this message translates to:
  /// **'DIVIDEX Team'**
  String get dIVIDEXTeam;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email: {emailAddress}'**
  String email(Object emailAddress);

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address: {streetAddress}'**
  String address(Object streetAddress);

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone: {phoneNumber}'**
  String phone(Object phoneNumber);

  /// No description provided for @otherTerms.
  ///
  /// In en, this message translates to:
  /// **'14. OTHER TERMS'**
  String get otherTerms;

  /// No description provided for @severability.
  ///
  /// In en, this message translates to:
  /// **'14.1 Severability'**
  String get severability;

  /// No description provided for @invalidTerm.
  ///
  /// In en, this message translates to:
  /// **'If any Term is deemed invalid, the remaining Terms remain in effect.'**
  String get invalidTerm;

  /// No description provided for @entireAgreement.
  ///
  /// In en, this message translates to:
  /// **'14.2 Entire Agreement'**
  String get entireAgreement;

  /// No description provided for @entireAgreementText.
  ///
  /// In en, this message translates to:
  /// **'These Terms constitute the entire agreement between you and DIVIDEX regarding the use of the Service.'**
  String get entireAgreementText;

  /// No description provided for @thankYouMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using DIVIDEX - Your Platform for Group Expense Sharing!'**
  String get thankYouMessage;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: {date}'**
  String lastUpdated(Object date);

  /// No description provided for @acceptancePrompt.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you accept our '**
  String get acceptancePrompt;

  /// No description provided for @termsOfServiceLink.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceLink;

  /// No description provided for @andConjunction.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get andConjunction;

  /// No description provided for @privacyPolicyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLink;

  /// No description provided for @splashPage2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Dividex is a powerful tool that allows you to easily share your bill with friends'**
  String get splashPage2Subtitle;

  /// No description provided for @createAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Create your\nDividex account'**
  String get createAccountPrompt;

  /// No description provided for @welcomeNewMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to DIVIDEX,'**
  String get welcomeNewMessage;

  /// No description provided for @createNewAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Hello there, create New account'**
  String get createNewAccountPrompt;

  /// No description provided for @welcomeBackMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBackMessage;

  /// No description provided for @signInAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Hello there, sign in to continue'**
  String get signInAccountPrompt;

  /// No description provided for @emailVerificationMessage.
  ///
  /// In en, this message translates to:
  /// **'We texted you a code to verify your email'**
  String get emailVerificationMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @numberInputError1.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get numberInputError1;

  /// No description provided for @numberInputError2.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get numberInputError2;

  /// No description provided for @otpInputError2.
  ///
  /// In en, this message translates to:
  /// **'The OTP code must be a 6-digit number'**
  String get otpInputError2;

  /// No description provided for @otpLabel.
  ///
  /// In en, this message translates to:
  /// **'Type your code'**
  String get otpLabel;

  /// No description provided for @emailVerificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'We texted you a code to verify your email'**
  String get emailVerificationCodeSent;

  /// No description provided for @codeExpirationNotice.
  ///
  /// In en, this message translates to:
  /// **'This code will expire 5 minutes after this message. If you don’t get a message, please choose resend after 5 minutes'**
  String get codeExpirationNotice;

  /// No description provided for @otpInputPageChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get otpInputPageChangeEmail;

  /// No description provided for @emailOrPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect'**
  String get emailOrPasswordIncorrect;

  /// No description provided for @passwordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Password is incorrect'**
  String get passwordIncorrect;

  /// No description provided for @invalidOrExpiredOtp.
  ///
  /// In en, this message translates to:
  /// **'OTP is expired, please try again!'**
  String get invalidOrExpiredOtp;

  /// Greet the user by name
  ///
  /// In en, this message translates to:
  /// **'Welcome {userName}!'**
  String welcomeUser(Object userName);

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @transactionReport.
  ///
  /// In en, this message translates to:
  /// **'Transaction report'**
  String get transactionReport;

  /// No description provided for @friendRequest.
  ///
  /// In en, this message translates to:
  /// **'{userName}\'s request '**
  String friendRequest(Object userName);

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @your.
  ///
  /// In en, this message translates to:
  /// **'Your'**
  String get your;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @searchTransactionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search for specific shared expenses, bills, or payments within groups'**
  String get searchTransactionSubtitle;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @searchUserSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search for users to add as friends or participants in expenses'**
  String get searchUserSubtitle;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchTransaction.
  ///
  /// In en, this message translates to:
  /// **'Search transaction'**
  String get searchTransaction;

  /// No description provided for @searchUser.
  ///
  /// In en, this message translates to:
  /// **'Search user'**
  String get searchUser;

  /// No description provided for @addGroupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new group to share manage expense with your friend.'**
  String get addGroupSubtitle;

  /// No description provided for @addMembers.
  ///
  /// In en, this message translates to:
  /// **'Choose members'**
  String get addMembers;

  /// No description provided for @refreshFail.
  ///
  /// In en, this message translates to:
  /// **'Session expired, please login again'**
  String get refreshFail;

  /// No description provided for @uploadImageHint.
  ///
  /// In en, this message translates to:
  /// **'Please upload image, size less than 100KB'**
  String get uploadImageHint;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get chooseFile;

  /// No description provided for @fileChosen.
  ///
  /// In en, this message translates to:
  /// **'file chosen'**
  String get fileChosen;

  /// No description provided for @noFileChosen.
  ///
  /// In en, this message translates to:
  /// **'No file chosen'**
  String get noFileChosen;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @addEventSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new event to share and manage expense easily.'**
  String get addEventSubtitle;

  /// No description provided for @addExpenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new expense to share costs easily and keep everything fair for the group.'**
  String get addExpenseSubtitle;

  /// No description provided for @expenseSplitType.
  ///
  /// In en, this message translates to:
  /// **'Choose transaction type:'**
  String get expenseSplitType;

  /// No description provided for @groupNotFound.
  ///
  /// In en, this message translates to:
  /// **'The group was not found.'**
  String get groupNotFound;

  /// No description provided for @createIsDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to create this item.'**
  String get createIsDenied;

  /// No description provided for @updateIsDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to update this item.'**
  String get updateIsDenied;

  /// No description provided for @deleteIsDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to delete this item.'**
  String get deleteIsDenied;

  /// No description provided for @eventNotFound.
  ///
  /// In en, this message translates to:
  /// **'The event was not found.'**
  String get eventNotFound;

  /// No description provided for @expenseNotFound.
  ///
  /// In en, this message translates to:
  /// **'The expense was not found'**
  String get expenseNotFound;

  /// No description provided for @friendRelationAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This friend relationship already exists.'**
  String get friendRelationAlreadyExists;

  /// No description provided for @friendRequestNotFound.
  ///
  /// In en, this message translates to:
  /// **'The friend request was not found.'**
  String get friendRequestNotFound;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @splitRemainingEqually.
  ///
  /// In en, this message translates to:
  /// **'Split remaining equally'**
  String get splitRemainingEqually;

  /// No description provided for @allocated.
  ///
  /// In en, this message translates to:
  /// **'Allocated'**
  String get allocated;

  /// No description provided for @noEventsInGroup.
  ///
  /// In en, this message translates to:
  /// **'No events in this group yet'**
  String get noEventsInGroup;

  /// Number of members in a group
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No members} =1{1 member} other{{count} members}}'**
  String membersText(int count);

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @groupAddMemberHint.
  ///
  /// In en, this message translates to:
  /// **'You can add new members to this group through'**
  String get groupAddMemberHint;

  /// No description provided for @groupAddMemberQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get groupAddMemberQr;

  /// No description provided for @groupAddMemberFriends.
  ///
  /// In en, this message translates to:
  /// **'Add friends (already in app)'**
  String get groupAddMemberFriends;

  /// No description provided for @groupChangeLeader.
  ///
  /// In en, this message translates to:
  /// **'Change Leader'**
  String get groupChangeLeader;

  /// No description provided for @groupSettings.
  ///
  /// In en, this message translates to:
  /// **'Group\'s settings'**
  String get groupSettings;

  /// No description provided for @eventSettings.
  ///
  /// In en, this message translates to:
  /// **'Event\'s settings'**
  String get eventSettings;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get done;

  /// No description provided for @notYet.
  ///
  /// In en, this message translates to:
  /// **'NOT YET'**
  String get notYet;

  /// No description provided for @deleteConfirm1.
  ///
  /// In en, this message translates to:
  /// **'You can only remove a member after '**
  String get deleteConfirm1;

  /// No description provided for @deleteConfirm2.
  ///
  /// In en, this message translates to:
  /// **'all debts in the group have been settled.'**
  String get deleteConfirm2;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @leaveIsDenied.
  ///
  /// In en, this message translates to:
  /// **'Total amount is not zero, please settle up before leaving'**
  String get leaveIsDenied;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @totalEvents.
  ///
  /// In en, this message translates to:
  /// **'Event attended'**
  String get totalEvents;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expensed shared'**
  String get totalExpenses;

  /// No description provided for @totalSpending.
  ///
  /// In en, this message translates to:
  /// **'Group\'s total spending'**
  String get totalSpending;

  /// No description provided for @userSpending.
  ///
  /// In en, this message translates to:
  /// **'Your total spending'**
  String get userSpending;

  /// No description provided for @contributionRate.
  ///
  /// In en, this message translates to:
  /// **'Contribution ratio'**
  String get contributionRate;

  /// No description provided for @event_not_joined_title.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t joined this event yet'**
  String get event_not_joined_title;

  /// No description provided for @event_not_joined_message.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Join\' to become a participant of this event.'**
  String get event_not_joined_message;

  /// No description provided for @join_button.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join_button;

  /// No description provided for @cancel_button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel_button;

  /// No description provided for @leader.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get leader;

  /// No description provided for @contributon.
  ///
  /// In en, this message translates to:
  /// **'Contribution'**
  String get contributon;

  /// No description provided for @dueDay.
  ///
  /// In en, this message translates to:
  /// **'Due day'**
  String get dueDay;

  /// No description provided for @billDetail.
  ///
  /// In en, this message translates to:
  /// **'Bill detail'**
  String get billDetail;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @expenseSplitNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Expense split not match, please check again'**
  String get expenseSplitNotMatch;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get accountNumber;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @accountNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Type your new account number'**
  String get accountNumberLabel;

  /// No description provided for @chooseBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Choose beneficiary'**
  String get chooseBeneficiary;

  /// No description provided for @findBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Find beneficiary'**
  String get findBeneficiary;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @binLabel.
  ///
  /// In en, this message translates to:
  /// **'Field your bin to verify transfer'**
  String get binLabel;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @youHaveSuccessfullyTransferred.
  ///
  /// In en, this message translates to:
  /// **'You have successfully transferred'**
  String get youHaveSuccessfullyTransferred;

  /// No description provided for @transferSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Transfer successful'**
  String get transferSuccessful;

  /// No description provided for @youHaveSuccessfullyWithdraw.
  ///
  /// In en, this message translates to:
  /// **'You have successfully withdraw'**
  String get youHaveSuccessfullyWithdraw;

  /// No description provided for @withdrawSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Withdraw successful'**
  String get withdrawSuccessful;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Save your bank account infor successfully!'**
  String get accountCreated;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Delete your bank account infor successfully!'**
  String get accountDeleted;

  /// No description provided for @accountUpdated.
  ///
  /// In en, this message translates to:
  /// **'Update your bank account infor successfully!'**
  String get accountUpdated;

  /// No description provided for @addNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Add new account'**
  String get addNewAccount;

  /// No description provided for @addAccountGuide.
  ///
  /// In en, this message translates to:
  /// **'Please enter your bank account information here if you wish to withdraw money to your personal account.'**
  String get addAccountGuide;

  /// No description provided for @rechargeIntoApp.
  ///
  /// In en, this message translates to:
  /// **'Recharge into Dividex'**
  String get rechargeIntoApp;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @showBalance.
  ///
  /// In en, this message translates to:
  /// **'Show balance'**
  String get showBalance;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter amount'**
  String get pleaseEnterAmount;

  /// No description provided for @totalDebt.
  ///
  /// In en, this message translates to:
  /// **'Total dept'**
  String get totalDebt;

  /// No description provided for @sharedEvents.
  ///
  /// In en, this message translates to:
  /// **'Shared events'**
  String get sharedEvents;

  /// No description provided for @mutualGroups.
  ///
  /// In en, this message translates to:
  /// **'Mutual groups'**
  String get mutualGroups;

  /// No description provided for @mutualFriends.
  ///
  /// In en, this message translates to:
  /// **'Mutual friends'**
  String get mutualFriends;

  /// No description provided for @seePhoto.
  ///
  /// In en, this message translates to:
  /// **'See photo'**
  String get seePhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @deletePhoto.
  ///
  /// In en, this message translates to:
  /// **'Delete photo'**
  String get deletePhoto;

  /// No description provided for @eventAddMemberHint.
  ///
  /// In en, this message translates to:
  /// **'You can add new members to this event through'**
  String get eventAddMemberHint;

  /// No description provided for @eventAddMembers.
  ///
  /// In en, this message translates to:
  /// **'Add members (already in group)'**
  String get eventAddMembers;

  /// No description provided for @groupMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get groupMember;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @settleUp.
  ///
  /// In en, this message translates to:
  /// **'Settle up'**
  String get settleUp;

  /// No description provided for @createDepositSuccess.
  ///
  /// In en, this message translates to:
  /// **'Deposit success'**
  String get createDepositSuccess;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Transaction day'**
  String get date;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @walletReport.
  ///
  /// In en, this message translates to:
  /// **'Wallet report'**
  String get walletReport;

  /// No description provided for @netBalance.
  ///
  /// In en, this message translates to:
  /// **'Net balance'**
  String get netBalance;

  /// No description provided for @expenseDeletedInfo.
  ///
  /// In en, this message translates to:
  /// **'Expense has been soft delete, please restore or hard delete in group setting.'**
  String get expenseDeletedInfo;

  /// No description provided for @deleteDate.
  ///
  /// In en, this message translates to:
  /// **'Delete day'**
  String get deleteDate;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @hardDelete.
  ///
  /// In en, this message translates to:
  /// **'Hard delete'**
  String get hardDelete;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete expense'**
  String get deleteExpense;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile picture'**
  String get profilePicture;

  /// No description provided for @pinInputError1.
  ///
  /// In en, this message translates to:
  /// **'Please enter pin code'**
  String get pinInputError1;

  /// No description provided for @pinInputError2.
  ///
  /// In en, this message translates to:
  /// **'Pin code must has 6 number'**
  String get pinInputError2;

  /// No description provided for @updatePin.
  ///
  /// In en, this message translates to:
  /// **'Update pin code'**
  String get updatePin;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPin;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// No description provided for @updatePinGuide.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current PIN and set a new 6-digit PIN. Pin code will be used to verify your transactions. '**
  String get updatePinGuide;

  /// No description provided for @fee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get fee;

  /// No description provided for @pinInvalid.
  ///
  /// In en, this message translates to:
  /// **'Pin is invalid, please set your pin in setting'**
  String get pinInvalid;

  /// No description provided for @insufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance is not enough'**
  String get insufficientBalance;

  /// No description provided for @realAmount.
  ///
  /// In en, this message translates to:
  /// **'Converted amount'**
  String get realAmount;

  /// No description provided for @realAmountDescription.
  ///
  /// In en, this message translates to:
  /// **'The amount after currency conversion.'**
  String get realAmountDescription;

  /// No description provided for @originalAmount.
  ///
  /// In en, this message translates to:
  /// **'Original amount'**
  String get originalAmount;

  /// No description provided for @originalAmountDescription.
  ///
  /// In en, this message translates to:
  /// **'The amount before currency conversion.'**
  String get originalAmountDescription;

  /// No description provided for @confirmTransfer.
  ///
  /// In en, this message translates to:
  /// **'Confirm transfer'**
  String get confirmTransfer;

  /// No description provided for @exchangeRateMessage.
  ///
  /// In en, this message translates to:
  /// **'Current exchange rate: 1 {baseCurrency} = {rate} VND'**
  String exchangeRateMessage(Object baseCurrency, Object rate);

  /// No description provided for @convertedAmountMessage.
  ///
  /// In en, this message translates to:
  /// **'Converted amount: {amount} VND'**
  String convertedAmountMessage(Object amount);

  /// No description provided for @continueQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to continue?'**
  String get continueQuestion;

  /// No description provided for @toSettleUpDebtInGroup.
  ///
  /// In en, this message translates to:
  /// **' through a transfer or any method outside the DivideX app.'**
  String get toSettleUpDebtInGroup;

  /// No description provided for @outSideTransfer.
  ///
  /// In en, this message translates to:
  /// **'Outside transfer'**
  String get outSideTransfer;

  /// No description provided for @pinNotSet.
  ///
  /// In en, this message translates to:
  /// **'Set up your pin to transfer'**
  String get pinNotSet;

  /// No description provided for @pinIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Your pin is incorect'**
  String get pinIncorrect;

  /// No description provided for @createPinGuide.
  ///
  /// In en, this message translates to:
  /// **'Please create a 6-digit PIN to secure your account. You’ll use this PIN to log in or confirm important actions.'**
  String get createPinGuide;

  /// No description provided for @createPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Create PIN'**
  String get createPinTitle;

  /// No description provided for @youBorrowed.
  ///
  /// In en, this message translates to:
  /// **'you borrowed'**
  String get youBorrowed;

  /// No description provided for @youLent.
  ///
  /// In en, this message translates to:
  /// **'you lent'**
  String get youLent;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @externalExpense.
  ///
  /// In en, this message translates to:
  /// **'External expense'**
  String get externalExpense;

  /// No description provided for @internalExpense.
  ///
  /// In en, this message translates to:
  /// **'Internal expense'**
  String get internalExpense;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @chooseTypeFilter.
  ///
  /// In en, this message translates to:
  /// **'Choose type of transaction'**
  String get chooseTypeFilter;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @inOrEx.
  ///
  /// In en, this message translates to:
  /// **'In or ex app'**
  String get inOrEx;

  /// No description provided for @conected.
  ///
  /// In en, this message translates to:
  /// **'Conected'**
  String get conected;

  /// No description provided for @lastTransaction.
  ///
  /// In en, this message translates to:
  /// **'Last transaction'**
  String get lastTransaction;

  /// Notification when someone updates an event
  ///
  /// In en, this message translates to:
  /// **'{user} have updated an event {event}'**
  String eventUpdated(Object user, Object event);

  /// Notification when someone creates an event
  ///
  /// In en, this message translates to:
  /// **'{user} have created an event {event}'**
  String eventCreated(Object user, Object event);

  /// Notification when someone deletes an event
  ///
  /// In en, this message translates to:
  /// **'{user} have deleted an event {event}'**
  String eventDeleted(Object user, Object event);

  /// Notification when someone restores a deleted expense
  ///
  /// In en, this message translates to:
  /// **'{user} have restored an expense {expense}'**
  String expenseRestored(Object user, Object expense);

  /// Notification when someone deletes an expense
  ///
  /// In en, this message translates to:
  /// **'{user} have deleted an expense {expense}'**
  String expenseDeleted(Object user, Object expense);

  /// Notification when someone updates an expense
  ///
  /// In en, this message translates to:
  /// **'{user} have updated an expense {expense}'**
  String expenseUpdated(Object user, Object expense);

  /// Notification when someone creates an expense
  ///
  /// In en, this message translates to:
  /// **'{user} have created an expense {expense}'**
  String expenseCreated(Object user, Object expense);

  /// Notification when someone accepts your friend request
  ///
  /// In en, this message translates to:
  /// **'{user} accepted your friend request'**
  String friendAccepted(Object user);

  /// Notification when someone sends a friend request with a message
  ///
  /// In en, this message translates to:
  /// **'{user} has sent you a friend request. message: {message}'**
  String friendRequestNoti(Object user, Object message);

  /// Notification when you receive a friend request
  ///
  /// In en, this message translates to:
  /// **'You have received a friend request from {user}'**
  String friendRequestToMe(Object user);

  /// Notification when group leader changes
  ///
  /// In en, this message translates to:
  /// **'{user} is new leader of group {group}'**
  String leaderChanged(Object user, Object group);

  /// Notification when someone updates a group
  ///
  /// In en, this message translates to:
  /// **'{user} have updated a group {group}'**
  String groupUpdated(Object user, Object group);

  /// Notification when user deposits money
  ///
  /// In en, this message translates to:
  /// **'You have deposited {amount} {currency}'**
  String deposit(Object amount, Object currency);

  /// No description provided for @enterMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter message...'**
  String get enterMessage;

  /// No description provided for @partnerTyping.
  ///
  /// In en, this message translates to:
  /// **'Partner is typing...'**
  String get partnerTyping;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @messageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Message is deleted'**
  String get messageDeleted;

  /// No description provided for @edited.
  ///
  /// In en, this message translates to:
  /// **'Message is Edited'**
  String get edited;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
