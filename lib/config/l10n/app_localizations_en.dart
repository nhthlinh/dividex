// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get addExpense => 'Add expense';

  @override
  String get addGroup => 'Add group';

  @override
  String get addEvent => 'Add event';

  @override
  String get error => 'Error, please try again later!';

  @override
  String get success => 'Successfully!';

  @override
  String get otpSentSuccess => 'Email has been sent';

  @override
  String get emailInput => 'Enter your email';

  @override
  String get emailInputDescription => 'We will send a link to your email.';

  @override
  String get passwordInputDescription =>
      'Contain at least 8 characters, including uppercase, lowercase, numbers, and special characters.';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get next => 'Next';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get login => 'Login';

  @override
  String get or => 'Or';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get loginPageToRegister => 'Don\'t have account?';

  @override
  String get register => 'Register';

  @override
  String get otpInputPageTitle => 'Verify your Email';

  @override
  String get otpInputPageDescription => 'We have sent a link to your email.';

  @override
  String get otpInputPageDidntReceiveCode => 'Didn\'t receive email?';

  @override
  String get otpInputPageResend => 'Resend';

  @override
  String get otpInputError1 => 'Email not found. Please try again.';

  @override
  String get resetPassPageTitle => 'Reset Password';

  @override
  String get resetPassPageDescription =>
      'Please enter your new password below.';

  @override
  String get resetPassNewPassHint => 'New Password';

  @override
  String get resetPassConfirmPassHint => 'Confirm New Password';

  @override
  String get save => 'Save';

  @override
  String get resetPassSuccess => 'Password reset successfully!';

  @override
  String get resetPassError => 'Failed to reset password. Please try again.';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmPasswordLabel => 'Confirm your password';

  @override
  String get confirmPasswordInputDescription => 'Enter your password again';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get nameLabel => 'Name';

  @override
  String get registerPageToLogin => 'Already have an account?';

  @override
  String get emailAlreadyExists => 'Email already exists';

  @override
  String get phoneNumberAlreadyExists => 'Phone number already exists';

  @override
  String get emailNotFound => 'Email not found';

  @override
  String get userNotFound => 'User not found';

  @override
  String get noTransaction => 'You have no transactions';

  @override
  String get addFirstTransaction =>
      'Let\'s add your first transaction in group';

  @override
  String get expenseNameLabel => 'Expense\'s name';

  @override
  String get expenseNameHint => 'Ex: Dinner';

  @override
  String get expenseAmountLabel => 'Amount';

  @override
  String get expenseAmountHint => '120.000';

  @override
  String get expenseUnitLabel => 'Unit';

  @override
  String get expenseCategoryLabel => 'Category';

  @override
  String get expenseEventLabel => 'Belong to event';

  @override
  String get expensePayerLabel => 'Payer';

  @override
  String get expenseSplitEquallyLabel => 'Split equally';

  @override
  String get expenseSplitCustomLabel => 'Split custom';

  @override
  String get addConfigLabel => 'Add more config';

  @override
  String get expenseNoteLabel => 'Note';

  @override
  String get expenseDateLabel => 'Date';

  @override
  String get expenseReminderLabel => 'Remind';

  @override
  String get addExpenseImageLabel => 'Add image';

  @override
  String get add => 'Add';

  @override
  String get appTitleHome => 'Home';

  @override
  String get searchTab => 'Search';

  @override
  String get appTitleCommunity => 'Community';

  @override
  String get profileSetting => 'Profile setting';

  @override
  String get settingLanguage => 'Language';

  @override
  String get settingChooseLanguage => 'Select Language for your app';

  @override
  String get settingChooseEng => 'English';

  @override
  String get settingChooseVie => 'Vietnamese';

  @override
  String get settingTheme => 'Theme';

  @override
  String get settingChooseTheme => 'Select Theme for your app';

  @override
  String get settingChooseDark => 'Dark';

  @override
  String get settingChooseLight => 'Light';

  @override
  String get settingTerm => 'Term of use';

  @override
  String get settingSecurity => 'Security';

  @override
  String get securitySettings => 'Security Setting';

  @override
  String get settingChangePass => 'Change password';

  @override
  String get signOut => 'Sign out';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get week => 'Week';

  @override
  String get day => 'Day';

  @override
  String get hour => 'Hour';

  @override
  String get minute => 'Minute';

  @override
  String get justNow => 'Just now';

  @override
  String get ago => 'ago';

  @override
  String get emailInputError1 => 'Email cannot be empty';

  @override
  String get emailInputError2 => 'Invalid email format';

  @override
  String get passInputError1 => 'Password cannot be empty';

  @override
  String get passInputError2 => 'Password cannot be shorter than 8 characters';

  @override
  String get passInputError3 =>
      'Password must contain at least one lowercase letter, one uppercase letter, one number, and one special character';

  @override
  String get passInputError4 => 'Repeated password does not match';

  @override
  String get phoneInputError1 => 'Phone number cannot be empty';

  @override
  String get phoneInputError2 => 'Invalid phone number';

  @override
  String get nameInputError1 => 'Name cannot be empty';

  @override
  String get nameInputError2 =>
      'Name must be more than 2 and less than 50 characters';

  @override
  String get amountInputError1 => 'Total expense cannot be empty';

  @override
  String get amountInputError2 => 'Invalid total expense';

  @override
  String get amountInputError3 => 'Total expense must be greater than 0';

  @override
  String get eventStartError1 => 'Start date cannot be empty';

  @override
  String get eventEndError1 => 'End date cannot be empty';

  @override
  String get eventStartError2 => 'Invalid start date';

  @override
  String get eventEndError2 => 'Invalid end date';

  @override
  String get eventStartAfterEndError => 'Start date cannot be after end date';

  @override
  String get eventEndBeforeStartError => 'End date cannot be before start date';

  @override
  String get less => 'less';

  @override
  String get more => 'more';

  @override
  String get imagePicker1 => 'Choose image from gallery';

  @override
  String get imagePicker2 => 'Take a photo';

  @override
  String get imagePickerError1 => 'Image selection failed, please try again';

  @override
  String get cropImage => 'Edit image';

  @override
  String get termsOfServiceTitle => 'TERMS OF SERVICE';

  @override
  String get aloboSportsHub => 'ALobo Sports Hub';

  @override
  String version(Object versionNumber) {
    return 'Version: $versionNumber';
  }

  @override
  String effectiveDate(Object date) {
    return 'Effective Date: $date';
  }

  @override
  String get acceptanceOfTerms => '1. ACCEPTANCE OF TERMS';

  @override
  String get welcomeMessage =>
      'Welcome to ALobo Sports Hub (\"Application\", \"Service\", \"we\" or \"ALobo\").';

  @override
  String get agreementText =>
      'By accessing, downloading, installing or using this application, you agree to comply with and be bound by these terms of service (\"Terms\").';

  @override
  String get disagreementText =>
      'If you do not agree with any part of these terms, please do not use our service.';

  @override
  String get serviceDescription => '2. SERVICE DESCRIPTION';

  @override
  String get aloboDescription =>
      'ALobo Sports Hub is a sports community application that allows users to:';

  @override
  String get profileCreation =>
      'Create personal profiles and share information about sports skills';

  @override
  String get postContent =>
      'Post content about sports activities with images, hashtags and friend tagging';

  @override
  String get socialInteractions =>
      'Social interactions through likes, comments, follows and friendships';

  @override
  String get searchUsers =>
      'Search and discover other users by sport, skill and location';

  @override
  String get createJoinGroups => 'Create and join sports groups';

  @override
  String get organizeEvents => 'Organize and attend sports events';

  @override
  String get receiveNotifications =>
      'Receive notifications about related activities';

  @override
  String get earnAchievements => 'Earn achievements in the achievement system';

  @override
  String get accountRegistrationSecurity =>
      '3. ACCOUNT REGISTRATION AND SECURITY';

  @override
  String get registrationRequirements => '3.1 Registration Requirements';

  @override
  String get ageRequirement =>
      'You must be 13 years or older to use the service';

  @override
  String get accurateInfo =>
      'Registration information must be accurate, complete and up-to-date';

  @override
  String get oneUniqueAccount =>
      'Each person may only create one unique account';

  @override
  String get emailVerification =>
      'You need to verify your email through OTP code';

  @override
  String get accountSecurity => '3.2 Account Security';

  @override
  String get passwordProtection =>
      'You are responsible for protecting your password and login information';

  @override
  String get unauthorizedUse =>
      'Notify us immediately if you detect unauthorized use of your account';

  @override
  String get noSharingResponsibility =>
      'We are not responsible for damages due to sharing login information';

  @override
  String get useOfService => '4. USE OF SERVICE';

  @override
  String get grantedRights => '4.1 Granted Rights';

  @override
  String get limitedRight =>
      'We grant you a limited, non-exclusive, non-transferable right to:';

  @override
  String get accessUsePersonal =>
      'Access and use the application for personal, non-commercial purposes';

  @override
  String get createShareContent =>
      'Create and share content in accordance with these terms';

  @override
  String get usageRestrictions => '4.2 Usage Restrictions';

  @override
  String get mayNot => 'You MAY NOT:';

  @override
  String get illegalPurposes =>
      'Use the service for illegal or unauthorized purposes';

  @override
  String get fakeAccounts =>
      'Create fake accounts or provide false information';

  @override
  String get spamHarass => 'Spam, harass or abuse other users';

  @override
  String get copyrightViolation =>
      'Upload content that violates copyright or intellectual property rights';

  @override
  String get botsScripts =>
      'Use bots, scripts or automated tools to access the service';

  @override
  String get hackSabotage =>
      'Attempt to hack, sabotage the system or collect data illegally';

  @override
  String get userContent => '5. USER CONTENT';

  @override
  String get contentOwnership => '5.1 Content Ownership';

  @override
  String get retainOwnership => 'You retain ownership of content you create';

  @override
  String get aloboContentRights =>
      'By posting, you grant ALobo the right to use, display, distribute that content on the platform';

  @override
  String get contentStandards => '5.2 Content Standards';

  @override
  String get mustNot => 'Posted content MUST NOT:';

  @override
  String get falseInfo => 'Contain false, fraudulent information or spam';

  @override
  String get violatePrivacy => 'Violate others\' privacy or copyright';

  @override
  String get pornographicContent =>
      'Contain pornographic, violent or discriminatory content';

  @override
  String get unauthorizedAdvertising =>
      'Include unauthorized advertising or sales';

  @override
  String get sharePersonalWithoutConsent =>
      'Share others\' personal information without consent';

  @override
  String get moderationRights => '5.3 Moderation Rights';

  @override
  String get reviewRemoveContent =>
      'We have the right (but not obligation) to review and remove violating content';

  @override
  String get contentDeletedNotice =>
      'Content may be deleted without prior notice';

  @override
  String get moderationDecisionsFinal => 'Our moderation decisions are final';

  @override
  String get privacyDataProtection => '6. PRIVACY AND DATA PROTECTION';

  @override
  String get informationCollection => '6.1 Information Collection';

  @override
  String get collectProcessInfo =>
      'We collect and process personal information according to our Privacy Policy, including:';

  @override
  String get profileInfo => 'Profile information (name, email, avatar)';

  @override
  String get postInteractions => 'Post content and interactions';

  @override
  String get locationData => 'Location data (when permitted)';

  @override
  String get appUsageInfo => 'Application usage information';

  @override
  String get informationSharing => '6.2 Information Sharing';

  @override
  String get infoDisplayedPublicly =>
      'Your information may be displayed publicly according to privacy settings';

  @override
  String get noSellToThirdParties =>
      'We do not sell personal information to third parties';

  @override
  String get sharedWithPartners =>
      'Information may be shared with service partners to operate the application';

  @override
  String get freePaidFeatures => '7. FREE AND PAID FEATURES';

  @override
  String get freeFeatures => '7.1 Free Features';

  @override
  String get basicFeaturesFree =>
      'Basic application features are provided free of charge, including:';

  @override
  String get createProfilesPosts => 'Creating profiles and posting content';

  @override
  String get basicSocialInteractions => 'Basic social interactions';

  @override
  String get joinGroupsEvents => 'Joining groups and events';

  @override
  String get userSearch => 'User search';

  @override
  String get paidFeatures => '7.2 Paid Features (if any)';

  @override
  String get premiumFeaturesPayment => 'Premium features may require payment';

  @override
  String get transactionsNotified =>
      'All transactions will be clearly notified before execution';

  @override
  String get refundPolicyPublished =>
      'Refund policy will be published separately';

  @override
  String get intellectualProperty => '8. INTELLECTUAL PROPERTY';

  @override
  String get alobosRights => '8.1 ALobo\'s Rights';

  @override
  String get appInterfaceLogoOwned =>
      'The application, interface, logo and materials are owned by ALobo';

  @override
  String get copyingProhibited =>
      'Copying, distributing or creating derivative products is strictly prohibited';

  @override
  String get respectingCopyright => '8.2 Respecting Copyright';

  @override
  String get respectOthersRights =>
      'We respect others\' intellectual property rights';

  @override
  String get handleInfringement =>
      'Will handle copyright infringement complaints according to legal regulations';

  @override
  String get serviceTermination => '9. SERVICE TERMINATION';

  @override
  String get terminationByUser => '9.1 Termination by User';

  @override
  String get deleteAccount =>
      'You may delete your account at any time through application settings';

  @override
  String get infoRetainedLaw =>
      'Some information may be retained as required by law';

  @override
  String get terminationByAlobo => '9.2 Termination by ALobo';

  @override
  String get suspendTerminateAccounts =>
      'We have the right to suspend or terminate accounts if:';

  @override
  String get violatingTerms => 'Violating terms of service';

  @override
  String get illegalHarmfulActivities => 'Illegal or harmful activities';

  @override
  String get lawEnforcementRequests => 'Requests from law enforcement';

  @override
  String get discontinuingService => 'Discontinuing service provision';

  @override
  String get disclaimer => '10. DISCLAIMER';

  @override
  String get asIsService => '10.1 \"As Is\" Service';

  @override
  String get serviceProvidedAsIs =>
      'Service is provided \"as is\" and \"as available\"';

  @override
  String get noGuaranteeOperation =>
      'No guarantee of continuous, error-free or absolutely secure operation';

  @override
  String get limitationOfLiability => '10.2 Limitation of Liability';

  @override
  String get noResponsibilityUserContent =>
      'ALobo is not responsible for user-generated content';

  @override
  String get noGuaranteeAccuracy =>
      'Does not guarantee accuracy of information from other users';

  @override
  String get noResponsibilityIndirectDamages =>
      'Not responsible for indirect, incidental or consequential damages';

  @override
  String get disputeResolution => '11. DISPUTE RESOLUTION';

  @override
  String get negotiation => '11.1 Negotiation';

  @override
  String get resolveThroughNegotiation =>
      'Disputes will be resolved through good faith negotiation first.';

  @override
  String get applicableLaw => '11.2 Applicable Law';

  @override
  String get termsGovernedByLaw =>
      'These terms are governed by the laws of Vietnam.';

  @override
  String get courtJurisdiction => '11.3 Court Jurisdiction';

  @override
  String get competentCourtsResolve =>
      'Competent courts in Vietnam will resolve disputes that cannot be reconciled.';

  @override
  String get termsUpdates => '12. TERMS UPDATES';

  @override
  String get rightToModify => '12.1 Right to Modify';

  @override
  String get updateTerms =>
      'We have the right to update these terms at any time';

  @override
  String get notificationsSent =>
      'Notifications will be sent through the application or registered email';

  @override
  String get acceptingChanges => '12.2 Accepting Changes';

  @override
  String get continuedUseMeansAgreement =>
      'Continued use of the service after updates means you agree to the new terms';

  @override
  String get disagreeStopUse =>
      'If you disagree, please stop using the service';

  @override
  String get contactInformation => '13. CONTACT INFORMATION';

  @override
  String get questionsContact =>
      'If you have any questions about these terms, please contact:';

  @override
  String get aloboTeam => 'ALobo Sports Hub Team';

  @override
  String email(Object emailAddress) {
    return 'Email: $emailAddress';
  }

  @override
  String address(Object streetAddress) {
    return 'Address: $streetAddress';
  }

  @override
  String phone(Object phoneNumber) {
    return 'Phone: $phoneNumber';
  }

  @override
  String get otherTerms => '14. OTHER TERMS';

  @override
  String get severability => '14.1 Severability';

  @override
  String get invalidTerm =>
      'If any term is deemed invalid, the remaining terms remain in effect.';

  @override
  String get entireAgreement => '14.2 Entire Agreement';

  @override
  String get entireAgreementText =>
      'These terms constitute the entire agreement between you and ALobo regarding use of the service.';

  @override
  String get thankYouMessage =>
      'Thank you for using ALobo Sports Hub - Where Sports Communities Connect!';

  @override
  String lastUpdated(Object date) {
    return 'Last Updated: $date';
  }
}
