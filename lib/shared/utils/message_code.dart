class MessageCode {
  // Register
  static const String emailAlreadyExists = 'EMAIL_ALREADY_EXISTS';
  static const String phoneNumberAlreadyExists = 'PHONE_NUMBER_ALREADY_EXISTS';

  // Login
  static const String emailOrPasswordIncorrect = 'EMAIL_OR_PASSWORD_INCORRECT';

  // Change password
  static const String passwordIncorrect = 'PASSWORD_INCORRECT';

  // Create reset password token
  static const String invalidOrExpiredOtp = 'INVALID_OR_EXPIRED_OTP';

  // More
  static const String emailNotFound = 'EMAIL_NOT_FOUND';
  static const String userNotFound = 'USER_NOT_FOUND';

  static const String createIsDenied = 'CREATE_IS_DENIED';
  static const String groupNotFound = 'GROUP_NOT_FOUND';  
  static const String eventNotFound = 'EVENT_NOT_FOUND';
  static const String expenseNotFound = 'EXPENSE_NOT_FOUND';
  static const String updateIsDenied = 'UPDATE_IS_DENIED';
  static const String deleteIsDenied = 'DELETE_IS_DENIED';
  static const String leaveIsDenied = 'LEAVE_IS_DENIED';
  static const String getIsDenied = 'GET_IS_DENIED';

  static const String friendRelationAlreadyExists = 'FRIEND_HAS_RELATION';
  static const String friendRequestNotFound = 'FRIENDSHIP_NOT_FOUND';

  static const String pinNotSet = 'PIN_NOT_SET';
  static const String pinIncorrect = 'PIN_INCORRECT';
}
