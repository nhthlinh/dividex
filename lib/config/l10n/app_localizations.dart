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
  /// **'Email'**
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
  /// **'Email not found. Please try again.'**
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
  /// **'User not found'**
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

  /// No description provided for @expenseUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get expenseUnitLabel;

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
  /// **'Pay'**
  String get pay;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'TERMS OF SERVICE'**
  String get termsOfServiceTitle;

  /// No description provided for @aloboSportsHub.
  ///
  /// In en, this message translates to:
  /// **'ALobo Sports Hub'**
  String get aloboSportsHub;

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
  /// **'Welcome to ALobo Sports Hub (\"Application\", \"Service\", \"we\" or \"ALobo\").'**
  String get welcomeMessage;

  /// No description provided for @agreementText.
  ///
  /// In en, this message translates to:
  /// **'By accessing, downloading, installing or using this application, you agree to comply with and be bound by these terms of service (\"Terms\").'**
  String get agreementText;

  /// No description provided for @disagreementText.
  ///
  /// In en, this message translates to:
  /// **'If you do not agree with any part of these terms, please do not use our service.'**
  String get disagreementText;

  /// No description provided for @serviceDescription.
  ///
  /// In en, this message translates to:
  /// **'2. SERVICE DESCRIPTION'**
  String get serviceDescription;

  /// No description provided for @aloboDescription.
  ///
  /// In en, this message translates to:
  /// **'ALobo Sports Hub is a sports community application that allows users to:'**
  String get aloboDescription;

  /// No description provided for @profileCreation.
  ///
  /// In en, this message translates to:
  /// **'Create personal profiles and share information about sports skills'**
  String get profileCreation;

  /// No description provided for @postContent.
  ///
  /// In en, this message translates to:
  /// **'Post content about sports activities with images, hashtags and friend tagging'**
  String get postContent;

  /// No description provided for @socialInteractions.
  ///
  /// In en, this message translates to:
  /// **'Social interactions through likes, comments, follows and friendships'**
  String get socialInteractions;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search and discover other users by sport, skill and location'**
  String get searchUsers;

  /// No description provided for @createJoinGroups.
  ///
  /// In en, this message translates to:
  /// **'Create and join sports groups'**
  String get createJoinGroups;

  /// No description provided for @organizeEvents.
  ///
  /// In en, this message translates to:
  /// **'Organize and attend sports events'**
  String get organizeEvents;

  /// No description provided for @receiveNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications about related activities'**
  String get receiveNotifications;

  /// No description provided for @earnAchievements.
  ///
  /// In en, this message translates to:
  /// **'Earn achievements in the achievement system'**
  String get earnAchievements;

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
  /// **'You must be 13 years or older to use the service'**
  String get ageRequirement;

  /// No description provided for @accurateInfo.
  ///
  /// In en, this message translates to:
  /// **'Registration information must be accurate, complete and up-to-date'**
  String get accurateInfo;

  /// No description provided for @oneUniqueAccount.
  ///
  /// In en, this message translates to:
  /// **'Each person may only create one unique account'**
  String get oneUniqueAccount;

  /// No description provided for @emailVerification.
  ///
  /// In en, this message translates to:
  /// **'You need to verify your email through OTP code'**
  String get emailVerification;

  /// No description provided for @accountSecurity.
  ///
  /// In en, this message translates to:
  /// **'3.2 Account Security'**
  String get accountSecurity;

  /// No description provided for @passwordProtection.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for protecting your password and login information'**
  String get passwordProtection;

  /// No description provided for @unauthorizedUse.
  ///
  /// In en, this message translates to:
  /// **'Notify us immediately if you detect unauthorized use of your account'**
  String get unauthorizedUse;

  /// No description provided for @noSharingResponsibility.
  ///
  /// In en, this message translates to:
  /// **'We are not responsible for damages due to sharing login information'**
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
  /// **'Access and use the application for personal, non-commercial purposes'**
  String get accessUsePersonal;

  /// No description provided for @createShareContent.
  ///
  /// In en, this message translates to:
  /// **'Create and share content in accordance with these terms'**
  String get createShareContent;

  /// No description provided for @usageRestrictions.
  ///
  /// In en, this message translates to:
  /// **'4.2 Usage Restrictions'**
  String get usageRestrictions;

  /// No description provided for @mayNot.
  ///
  /// In en, this message translates to:
  /// **'You MAY NOT:'**
  String get mayNot;

  /// No description provided for @illegalPurposes.
  ///
  /// In en, this message translates to:
  /// **'Use the service for illegal or unauthorized purposes'**
  String get illegalPurposes;

  /// No description provided for @fakeAccounts.
  ///
  /// In en, this message translates to:
  /// **'Create fake accounts or provide false information'**
  String get fakeAccounts;

  /// No description provided for @spamHarass.
  ///
  /// In en, this message translates to:
  /// **'Spam, harass or abuse other users'**
  String get spamHarass;

  /// No description provided for @copyrightViolation.
  ///
  /// In en, this message translates to:
  /// **'Upload content that violates copyright or intellectual property rights'**
  String get copyrightViolation;

  /// No description provided for @botsScripts.
  ///
  /// In en, this message translates to:
  /// **'Use bots, scripts or automated tools to access the service'**
  String get botsScripts;

  /// No description provided for @hackSabotage.
  ///
  /// In en, this message translates to:
  /// **'Attempt to hack, sabotage the system or collect data illegally'**
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
  /// **'You retain ownership of content you create'**
  String get retainOwnership;

  /// No description provided for @aloboContentRights.
  ///
  /// In en, this message translates to:
  /// **'By posting, you grant ALobo the right to use, display, distribute that content on the platform'**
  String get aloboContentRights;

  /// No description provided for @contentStandards.
  ///
  /// In en, this message translates to:
  /// **'5.2 Content Standards'**
  String get contentStandards;

  /// No description provided for @mustNot.
  ///
  /// In en, this message translates to:
  /// **'Posted content MUST NOT:'**
  String get mustNot;

  /// No description provided for @falseInfo.
  ///
  /// In en, this message translates to:
  /// **'Contain false, fraudulent information or spam'**
  String get falseInfo;

  /// No description provided for @violatePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Violate others\' privacy or copyright'**
  String get violatePrivacy;

  /// No description provided for @pornographicContent.
  ///
  /// In en, this message translates to:
  /// **'Contain pornographic, violent or discriminatory content'**
  String get pornographicContent;

  /// No description provided for @unauthorizedAdvertising.
  ///
  /// In en, this message translates to:
  /// **'Include unauthorized advertising or sales'**
  String get unauthorizedAdvertising;

  /// No description provided for @sharePersonalWithoutConsent.
  ///
  /// In en, this message translates to:
  /// **'Share others\' personal information without consent'**
  String get sharePersonalWithoutConsent;

  /// No description provided for @moderationRights.
  ///
  /// In en, this message translates to:
  /// **'5.3 Moderation Rights'**
  String get moderationRights;

  /// No description provided for @reviewRemoveContent.
  ///
  /// In en, this message translates to:
  /// **'We have the right (but not obligation) to review and remove violating content'**
  String get reviewRemoveContent;

  /// No description provided for @contentDeletedNotice.
  ///
  /// In en, this message translates to:
  /// **'Content may be deleted without prior notice'**
  String get contentDeletedNotice;

  /// No description provided for @moderationDecisionsFinal.
  ///
  /// In en, this message translates to:
  /// **'Our moderation decisions are final'**
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
  /// **'We collect and process personal information according to our Privacy Policy, including:'**
  String get collectProcessInfo;

  /// No description provided for @profileInfo.
  ///
  /// In en, this message translates to:
  /// **'Profile information (name, email, avatar)'**
  String get profileInfo;

  /// No description provided for @postInteractions.
  ///
  /// In en, this message translates to:
  /// **'Post content and interactions'**
  String get postInteractions;

  /// No description provided for @locationData.
  ///
  /// In en, this message translates to:
  /// **'Location data (when permitted)'**
  String get locationData;

  /// No description provided for @appUsageInfo.
  ///
  /// In en, this message translates to:
  /// **'Application usage information'**
  String get appUsageInfo;

  /// No description provided for @informationSharing.
  ///
  /// In en, this message translates to:
  /// **'6.2 Information Sharing'**
  String get informationSharing;

  /// No description provided for @infoDisplayedPublicly.
  ///
  /// In en, this message translates to:
  /// **'Your information may be displayed publicly according to privacy settings'**
  String get infoDisplayedPublicly;

  /// No description provided for @noSellToThirdParties.
  ///
  /// In en, this message translates to:
  /// **'We do not sell personal information to third parties'**
  String get noSellToThirdParties;

  /// No description provided for @sharedWithPartners.
  ///
  /// In en, this message translates to:
  /// **'Information may be shared with service partners to operate the application'**
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
  /// **'Basic application features are provided free of charge, including:'**
  String get basicFeaturesFree;

  /// No description provided for @createProfilesPosts.
  ///
  /// In en, this message translates to:
  /// **'Creating profiles and posting content'**
  String get createProfilesPosts;

  /// No description provided for @basicSocialInteractions.
  ///
  /// In en, this message translates to:
  /// **'Basic social interactions'**
  String get basicSocialInteractions;

  /// No description provided for @joinGroupsEvents.
  ///
  /// In en, this message translates to:
  /// **'Joining groups and events'**
  String get joinGroupsEvents;

  /// No description provided for @userSearch.
  ///
  /// In en, this message translates to:
  /// **'User search'**
  String get userSearch;

  /// No description provided for @paidFeatures.
  ///
  /// In en, this message translates to:
  /// **'7.2 Paid Features (if any)'**
  String get paidFeatures;

  /// No description provided for @premiumFeaturesPayment.
  ///
  /// In en, this message translates to:
  /// **'Premium features may require payment'**
  String get premiumFeaturesPayment;

  /// No description provided for @transactionsNotified.
  ///
  /// In en, this message translates to:
  /// **'All transactions will be clearly notified before execution'**
  String get transactionsNotified;

  /// No description provided for @refundPolicyPublished.
  ///
  /// In en, this message translates to:
  /// **'Refund policy will be published separately'**
  String get refundPolicyPublished;

  /// No description provided for @intellectualProperty.
  ///
  /// In en, this message translates to:
  /// **'8. INTELLECTUAL PROPERTY'**
  String get intellectualProperty;

  /// No description provided for @alobosRights.
  ///
  /// In en, this message translates to:
  /// **'8.1 ALobo\'s Rights'**
  String get alobosRights;

  /// No description provided for @appInterfaceLogoOwned.
  ///
  /// In en, this message translates to:
  /// **'The application, interface, logo and materials are owned by ALobo'**
  String get appInterfaceLogoOwned;

  /// No description provided for @copyingProhibited.
  ///
  /// In en, this message translates to:
  /// **'Copying, distributing or creating derivative products is strictly prohibited'**
  String get copyingProhibited;

  /// No description provided for @respectingCopyright.
  ///
  /// In en, this message translates to:
  /// **'8.2 Respecting Copyright'**
  String get respectingCopyright;

  /// No description provided for @respectOthersRights.
  ///
  /// In en, this message translates to:
  /// **'We respect others\' intellectual property rights'**
  String get respectOthersRights;

  /// No description provided for @handleInfringement.
  ///
  /// In en, this message translates to:
  /// **'Will handle copyright infringement complaints according to legal regulations'**
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
  /// **'You may delete your account at any time through application settings'**
  String get deleteAccount;

  /// No description provided for @infoRetainedLaw.
  ///
  /// In en, this message translates to:
  /// **'Some information may be retained as required by law'**
  String get infoRetainedLaw;

  /// No description provided for @terminationByAlobo.
  ///
  /// In en, this message translates to:
  /// **'9.2 Termination by ALobo'**
  String get terminationByAlobo;

  /// No description provided for @suspendTerminateAccounts.
  ///
  /// In en, this message translates to:
  /// **'We have the right to suspend or terminate accounts if:'**
  String get suspendTerminateAccounts;

  /// No description provided for @violatingTerms.
  ///
  /// In en, this message translates to:
  /// **'Violating terms of service'**
  String get violatingTerms;

  /// No description provided for @illegalHarmfulActivities.
  ///
  /// In en, this message translates to:
  /// **'Illegal or harmful activities'**
  String get illegalHarmfulActivities;

  /// No description provided for @lawEnforcementRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests from law enforcement'**
  String get lawEnforcementRequests;

  /// No description provided for @discontinuingService.
  ///
  /// In en, this message translates to:
  /// **'Discontinuing service provision'**
  String get discontinuingService;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'10. DISCLAIMER'**
  String get disclaimer;

  /// No description provided for @asIsService.
  ///
  /// In en, this message translates to:
  /// **'10.1 \"As Is\" Service'**
  String get asIsService;

  /// No description provided for @serviceProvidedAsIs.
  ///
  /// In en, this message translates to:
  /// **'Service is provided \"as is\" and \"as available\"'**
  String get serviceProvidedAsIs;

  /// No description provided for @noGuaranteeOperation.
  ///
  /// In en, this message translates to:
  /// **'No guarantee of continuous, error-free or absolutely secure operation'**
  String get noGuaranteeOperation;

  /// No description provided for @limitationOfLiability.
  ///
  /// In en, this message translates to:
  /// **'10.2 Limitation of Liability'**
  String get limitationOfLiability;

  /// No description provided for @noResponsibilityUserContent.
  ///
  /// In en, this message translates to:
  /// **'ALobo is not responsible for user-generated content'**
  String get noResponsibilityUserContent;

  /// No description provided for @noGuaranteeAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Does not guarantee accuracy of information from other users'**
  String get noGuaranteeAccuracy;

  /// No description provided for @noResponsibilityIndirectDamages.
  ///
  /// In en, this message translates to:
  /// **'Not responsible for indirect, incidental or consequential damages'**
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
  /// **'Disputes will be resolved through good faith negotiation first.'**
  String get resolveThroughNegotiation;

  /// No description provided for @applicableLaw.
  ///
  /// In en, this message translates to:
  /// **'11.2 Applicable Law'**
  String get applicableLaw;

  /// No description provided for @termsGovernedByLaw.
  ///
  /// In en, this message translates to:
  /// **'These terms are governed by the laws of Vietnam.'**
  String get termsGovernedByLaw;

  /// No description provided for @courtJurisdiction.
  ///
  /// In en, this message translates to:
  /// **'11.3 Court Jurisdiction'**
  String get courtJurisdiction;

  /// No description provided for @competentCourtsResolve.
  ///
  /// In en, this message translates to:
  /// **'Competent courts in Vietnam will resolve disputes that cannot be reconciled.'**
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
  /// **'We have the right to update these terms at any time'**
  String get updateTerms;

  /// No description provided for @notificationsSent.
  ///
  /// In en, this message translates to:
  /// **'Notifications will be sent through the application or registered email'**
  String get notificationsSent;

  /// No description provided for @acceptingChanges.
  ///
  /// In en, this message translates to:
  /// **'12.2 Accepting Changes'**
  String get acceptingChanges;

  /// No description provided for @continuedUseMeansAgreement.
  ///
  /// In en, this message translates to:
  /// **'Continued use of the service after updates means you agree to the new terms'**
  String get continuedUseMeansAgreement;

  /// No description provided for @disagreeStopUse.
  ///
  /// In en, this message translates to:
  /// **'If you disagree, please stop using the service'**
  String get disagreeStopUse;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'13. CONTACT INFORMATION'**
  String get contactInformation;

  /// No description provided for @questionsContact.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about these terms, please contact:'**
  String get questionsContact;

  /// No description provided for @aloboTeam.
  ///
  /// In en, this message translates to:
  /// **'ALobo Sports Hub Team'**
  String get aloboTeam;

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
  /// **'If any term is deemed invalid, the remaining terms remain in effect.'**
  String get invalidTerm;

  /// No description provided for @entireAgreement.
  ///
  /// In en, this message translates to:
  /// **'14.2 Entire Agreement'**
  String get entireAgreement;

  /// No description provided for @entireAgreementText.
  ///
  /// In en, this message translates to:
  /// **'These terms constitute the entire agreement between you and ALobo regarding use of the service.'**
  String get entireAgreementText;

  /// No description provided for @thankYouMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using ALobo Sports Hub - Where Sports Communities Connect!'**
  String get thankYouMessage;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: {date}'**
  String lastUpdated(Object date);
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
