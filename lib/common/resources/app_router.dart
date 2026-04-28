import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:base_project/features/auth/forget_password/view/forget_password_view.dart';
import 'package:base_project/features/auth/login/view/login_view.dart';
import 'package:base_project/features/auth/reset_password/view/reset_password_view.dart';
import 'package:base_project/features/auth/signup/view/signup_success_view.dart';
import 'package:base_project/features/auth/signup/view/signup_view.dart';
import 'package:base_project/features/auth/verify_otp/view/verify_otp_view.dart';
import 'package:base_project/features/bottom_nav_bar/view/bottom_nav_bar_view.dart';
import 'package:base_project/features/images/view/images_view.dart';
import 'package:base_project/features/notifications/view/notifications_view.dart';
import 'package:base_project/features/on_boarding/view/on_boarding_view.dart';
import 'package:base_project/features/splash/view/splash_view.dart';
import 'package:base_project/features/splash/view/language_view.dart';
import 'package:base_project/features/profile/help/view/help_view.dart';
import 'package:base_project/features/profile/technical_support/common%20question/view/common_question_view.dart';
import 'package:base_project/features/profile/technical_support/main%20%20technical%20support/view/technical_support_view.dart';
import 'package:base_project/features/profile/terms_and_conditions/view/terms_and_conditions_view.dart';
import 'package:base_project/features/profile/main%20profile/view/personal_data_view.dart';

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
          return CupertinoPage(
            child: SignUpView(isBuyer: extra?["isBuyer"] ?? false),
          );
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
          return CupertinoPage(
            child: ResetPasswordView(
              email: extra?['email'] ?? '',
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
      // GoRoute(
      //   path: signupLocation,
      //   pageBuilder: (context, state) {
      //     return const CupertinoPage(child: SignUpLocationView());
      //   },
      // ),
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
    ],
  );
}
