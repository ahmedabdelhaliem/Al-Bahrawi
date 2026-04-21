import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:base_project/featuers/auth/forget_password/view/forget_password_view.dart';
import 'package:base_project/featuers/auth/login/view/login_view.dart';
import 'package:base_project/featuers/auth/reset_password/view/reset_password_view.dart';
import 'package:base_project/featuers/auth/signup/view/signup_location_view.dart';
import 'package:base_project/featuers/auth/signup/view/signup_success_view.dart';
import 'package:base_project/featuers/auth/signup/view/signup_view.dart';
import 'package:base_project/featuers/auth/verify_otp/view/verify_otp_view.dart';
import 'package:base_project/featuers/bottom_nav_bar/view/bottom_nav_bar_view.dart';
import 'package:base_project/featuers/images/view/images_view.dart';
import 'package:base_project/featuers/notifications/view/notifications_view.dart';
import 'package:base_project/featuers/on_boarding/view/on_boarding_view.dart';
import 'package:base_project/featuers/payment/digital_payment_order_place_screen.dart';
import 'package:base_project/featuers/splash/view/splash_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

abstract class AppRouters {
  static const String root = '/';
  static const String onBoarding = '/onBoarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgetPass = '/forgetPass';
  static const String verifyOtp = '/verifyOtp';
  static const String resetPassword = '/resetPassword';
  static const String btmNav = '/btmNav';
  static const String publishAnnouncement = '/publishAnnouncement';
  static const String digitalPayment = '/digitalPayment';
  static const String notifications = '/notifications';
  static const String images = '/images';
  static const String signupSuccess = '/signupSuccess';
  static const String signupLocation = '/signupLocation';

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
          return CupertinoPage(child: LoginView(
              pageIndex: extra?['pageIndex']??0,
              pop: extra?['pop']??false,
              showLoginFirstToast: extra?['showLoginFirstToast']??false,
          ));
        },
      ),
      GoRoute(
        path: signup,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CupertinoPage(child: SignUpView(isBuyer: extra?["isBuyer"]??false,));
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
          final extra = state.extra as Map<String, dynamic>;
          return CupertinoPage(
            child: VerifyOtpView(
              phone: extra["phone"],
              isForgetPassword: extra["isForgetPassword"],
              isSignup: extra["isSignup"] ?? false,
            ),
          );
        },
      ),
      GoRoute(
        path: resetPassword,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return CupertinoPage(
            child: ResetPasswordView(
              email: extra['email'],
              // otp: extra['otp'],
            ),
          );
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
        path: digitalPayment,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return CupertinoPage(
            child: DigitalPaymentView(
              url: extra['url'],
              pageIndex: extra['pageIndex'] ?? 0,
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
              images: extra?['images']??[],
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
        path: signupLocation,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: SignUpLocationView());
        },
      ),
    ],
  );
}
