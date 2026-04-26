import 'dart:async';

import 'package:base_project/app/app_constants.dart';
import 'package:base_project/app/app_prefs.dart';
import 'package:base_project/app/di.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/values_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;

  _startDelay() {
    _timer = Timer(AppConstants.splashDuration, _goNext);
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) async {
    debugPrint('message ==================> ${message.data.toString()}');
  }

  _goNext() async {
    context.go(AppRouters.btmNav);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Entrance Animation (Fade + Scale)
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    // Driving Animation (Slide from left)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();

    language = _appPreferences.getAppLanguage();
    userRole = _appPreferences.getRole();
    _startDelay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage(GifsAssets.splashLogoGif), context);
    precacheImage(AssetImage(ImageAssets.logoSplash), context);
    _appPreferences.getLocale().then((locale) {
      if (mounted) context.setLocale(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: ColorManager.primaryGradient,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Decorative background patterns (optional but adds depth)
            Positioned(
              bottom: -50.h,
              left: -50.w,
              child: Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              top: -30.h,
              right: -30.w,
              child: Container(
                width: 150.w,
                height: 150.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),

            // Animated Bus Logo
            Center(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _animation,
                  child: ScaleTransition(
                    scale: _animation,
                    child: Hero(
                      tag: 'logo',
                      child: Image.asset(
                        ImageAssets.logoSplash,
                        width: 280.w,
                        height: 280.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Slogan or App Name at bottom
            Positioned(
              bottom: 60.h,
              child: FadeTransition(
                opacity: _animation,
                child: Column(
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.white70,
                      strokeWidth: 2,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      AppStrings.loading.tr(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14.sp,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }
}
