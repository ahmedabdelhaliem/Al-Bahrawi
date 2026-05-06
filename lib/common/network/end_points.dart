class EndPoints {
  static const String onBoarding = '/welcome-screens';
  static const String login = '/login';
  static const String firebaseLogin = '/firebase-login';
  static const String signup = '/register';
  static const String verifyOTP = '/verify-otp';
  static const String resendOTP = '/resend-otp';
  static const String forgetPassword = '/forgot/password';
  static const String verifyOTPForgetPassword = '/forgot/verify-otp';
  static const String resendOTPForgetPassword = '/forgot/resend-otp';
  static const String resetPassword = '/forgot/reset-password';
  static const String banners = '/banners';

  static const String logout = '/logout';
  static const String profile = '/profile';
  static const String updateProfile = '/updateProfile';
  static const String notifications = '/notifications';

  static const String countriesCities = '/country';
  static const String countries = '/countries';
  static String governorates(int countryId) => '/governorates/$countryId';

  static const String privacyPolicy = '/privacy';
  static const String about = '/about-us';
  static const String terms = '/terms';
  static const String faqs = '/faq';
  static const String deleteAccount = '/delete/account';
  static const String contactUs = '/contact';

  // Chat
  static const String chats = '/chats';
  static String firebaseToken(int id) => '/chats/$id/firebase-token';
  static String chatMessages(int id) => '/chats/$id/messages';

  static const String services = '/services';
  static String serviceDetails(int id) => '/services/$id';
  static const String requestConsultation = '/consultation';
  static const String employeeAttendance = '/employee-attendance';
  static const String lawyerTasks = "/tasks";
  static const String statistics = '/statistics';
}

