class EndPoints {
  static const String onBoarding = '/sliders';
  static const String login = '/login';
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
  static const String updateProfile = '/profile/update';
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
}

