import 'package:al_bahrawi/features/auth/forget_password/view/forget_password_view.dart';
import 'package:al_bahrawi/features/auth/login/view/login_view.dart';
import 'package:al_bahrawi/features/auth/reset_password/view/reset_password_success_view.dart';
import 'package:al_bahrawi/features/auth/reset_password/view/reset_password_view.dart';
import 'package:al_bahrawi/features/auth/signup/view/signup_success_view.dart';
import 'package:al_bahrawi/features/auth/signup/view/signup_view.dart';
import 'package:al_bahrawi/features/auth/verify_otp/view/verify_otp_view.dart';
import 'package:al_bahrawi/features/bottom_nav_bar/view/bottom_nav_bar_view.dart';
import 'package:al_bahrawi/features/chat/presentation/view/chat_inbox_view.dart';
import 'package:al_bahrawi/features/chat/presentation/view/chat_view.dart';
import 'package:al_bahrawi/features/images/view/images_view.dart';
import 'package:al_bahrawi/features/lawyer_attendance/view/lawyer_attendance_view.dart';
import 'package:al_bahrawi/features/lawyer_attendance/view/lawyer_checkout_view.dart';
import 'package:al_bahrawi/features/lawyer_dashboard/view/lawyer_dashboard_view.dart';
import 'package:al_bahrawi/features/notifications/view/notifications_view.dart';
import 'package:al_bahrawi/features/on_boarding/view/on_boarding_view.dart';
import 'package:al_bahrawi/features/profile/help/view/help_view.dart';
import 'package:al_bahrawi/features/profile/main%20profile/view/about_us_view.dart';
import 'package:al_bahrawi/features/profile/main%20profile/view/cases_record_view.dart';
import 'package:al_bahrawi/features/profile/main%20profile/view/personal_data_view.dart';
import 'package:al_bahrawi/features/profile/technical_support/common%20question/view/common_question_view.dart';
import 'package:al_bahrawi/features/profile/technical_support/main%20%20technical%20support/view/contact_us_view.dart';
import 'package:al_bahrawi/features/profile/technical_support/main%20%20technical%20support/view/technical_support_view.dart';
import 'package:al_bahrawi/features/profile/terms_and_conditions/view/terms_and_conditions_view.dart';
import 'package:al_bahrawi/features/services/view/booking_success_view.dart';
import 'package:al_bahrawi/features/services/view/request_consultation_view.dart';
import 'package:al_bahrawi/features/services/view/service_details_view.dart';
import 'package:al_bahrawi/features/splash/view/language_view.dart';
import 'package:al_bahrawi/features/splash/view/splash_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

abstract class AppRouters {
  static const String root = '/';
  static const String onBoarding = '/onBoarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgetPass = '/forgetPass';
  static const String verifyOtp = '/verifyOtp';
  static const String resetPassword = '/resetPassword';
  static const String resetPasswordSuccess = '/resetPasswordSuccess';
  static const String btmNav = '/btmNav';
  static const String notifications = '/notifications';
  static const String commonQuestion = '/commonQuestion';
  static const String images = '/images';
  static const String signupSuccess = '/signupSuccess';
  static const String signupLocation = '/signupLocation';
  static const String userInformation = '/userInformation';
  static const String technicalSupport = '/technicalSupport';
  static const String settings = '/settings';
  static const String termsAndConditions = '/termsAndConditions';
  static const String help = '/help';
  static const String myAccount = '/myAccount';
  static const String language = '/language';
  static const String serviceDetails = '/serviceDetails';
  static const String requestConsultation = '/requestConsultation';
  static const String bookingSuccess = '/bookingSuccess';
  static const String myCases = '/myCases';
  static const String contactUs = '/contactUs';
  static const String aboutUs = '/aboutUs';
  static const String chatInbox = '/chatInbox';
  static const String chatView = '/chatView';
  static const String lawyerAttendance = '/lawyerAttendance';
  static const String lawyerDashboard = '/lawyerDashboard';
  static const String lawyerCheckout = '/lawyerCheckout';

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: root,
    routes: [
      GoRoute(
        path: root,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: SplashView());
        },
      ),
      GoRoute(
        path: onBoarding,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: OnBoardingView());
        },
      ),
      GoRoute(
        path: login,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CupertinoPage(
            child: LoginView(
              pageIndex: extra?['pageIndex'] ?? 0,
              pop: extra?['pop'] ?? false,
              showLoginFirstToast: extra?['showLoginFirstToast'] ?? false,
            ),
          );
        },
      ),
      GoRoute(
        path: signup,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CupertinoPage(child: SignUpView(isBuyer: extra?["isBuyer"] ?? false));
        },
      ),
      GoRoute(
        path: forgetPass,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: ForgetPasswordView());
        },
      ),
      GoRoute(
        path: verifyOtp,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CupertinoPage(
            child: VerifyOtpView(
              phone: extra?["phone"] ?? '',
              isForgetPassword: extra?["isForgetPassword"] ?? false,
              isSignup: extra?["isSignup"] ?? false,
            ),
          );
        },
      ),
      GoRoute(
        path: resetPassword,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CupertinoPage(child: ResetPasswordView(phone: extra?['phone'] ?? ''));
        },
      ),
      GoRoute(
        path: resetPasswordSuccess,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: ResetPasswordSuccessView());
        },
      ),
      GoRoute(
        path: btmNav,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CupertinoPage(
            child: BottomNavBarView(
              key: extra?['refreshKey'] as Key?,
              pageIndex: extra?['pageIndex'] ?? 0,
            ),
          );
        },
      ),
      GoRoute(
        path: notifications,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: NotificationsView());
        },
      ),
      GoRoute(
        path: images,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CupertinoPage(
            child: ImagesView(
              images: extra?['images'] ?? [],
              initialPage: extra?['initialPage'] ?? 0,
            ),
          );
        },
      ),
      GoRoute(
        path: signupSuccess,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: SignupSuccessView());
        },
      ),
      GoRoute(
        path: termsAndConditions,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: TermsAndConditionsView());
        },
      ),
      GoRoute(
        path: technicalSupport,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: TechnicalSupportView());
        },
      ),
      GoRoute(
        path: commonQuestion,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: CommonQuestionView());
        },
      ),
      GoRoute(
        path: help,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: HelpView());
        },
      ),
      GoRoute(
        path: myAccount,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: PersonalDataView());
        },
      ),
      GoRoute(
        path: language,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: LanguageView());
        },
      ),
      GoRoute(
        path: serviceDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ServiceDetailsView(serviceId: extra?['serviceId'] ?? 0);
        },
      ),
      GoRoute(
        path: requestConsultation,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return RequestConsultationView(serviceId: extra?['serviceId'] ?? 0);
        },
      ),
      GoRoute(path: bookingSuccess, builder: (context, state) => const BookingSuccessView()),
      GoRoute(path: myCases, builder: (context, state) => const CasesRecordView()),
      GoRoute(path: contactUs, builder: (context, state) => const ContactUsView()),
      GoRoute(path: aboutUs, builder: (context, state) => const AboutUsView()),
      GoRoute(path: chatInbox, builder: (context, state) => const ChatInboxView()),
      GoRoute(
        path: chatView,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ChatView(
            chatId: extra['chatId'] as int,
            supplierName: extra['supplierName'] as String,
          );
        },
      ),
      GoRoute(
        path: lawyerAttendance,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: LawyerAttendanceView());
        },
      ),
      GoRoute(
        path: lawyerDashboard,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: LawyerDashboardView());
        },
      ),
      GoRoute(
        path: lawyerCheckout,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: LawyerCheckoutView());
        },
      ),
    ],
  );
}
