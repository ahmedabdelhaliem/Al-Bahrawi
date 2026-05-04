import 'dart:async';

import 'package:al_bahrawi/app/app_constants.dart';
import 'package:al_bahrawi/app/app_prefs.dart';
import 'package:al_bahrawi/app/di.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/assets_manager.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/values_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:al_bahrawi/local_notification_and_token.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  late Timer _timer;
  
  late AnimationController _mainController;
  late AnimationController _glowController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _glowOpacity;
  late Animation<Offset> _nameSlide;
  late Animation<double> _nameFade;

  _startDelay() {
    _timer = Timer(AppConstants.splashDuration, _goNext);
  }

  Future<void> setupInteractedMessage() async {
    globalMethods.registerNotification(context);
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
    if (_appPreferences.getToken().isNotEmpty) {
      context.go(AppRouters.btmNav);
    } else {
      context.go(AppRouters.language);
    }
  }

  @override
  void initState() {
    super.initState();
    
    // Main Animation Controller
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Glow Pulse Controller
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Logo Animations
    _logoScale = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
    );
    _logoFade = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    // Glow Animation
    _glowOpacity = Tween<double>(begin: 0.1, end: 0.4).animate(_glowController);

    // Name Animations (Delayed)
    _nameFade = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    );
    _nameSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
    ));

    _mainController.forward();
    setupInteractedMessage();

    _startDelay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
        decoration: BoxDecoration(
          color: ColorManager.white,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Glow behind logo
            AnimatedBuilder(
              animation: _glowOpacity,
              builder: (context, child) {
                return Container(
                  width: 300.w,
                  height: 300.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.primary.withValues(alpha: _glowOpacity.value * 0.2),
                        blurRadius: 100,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                );
              },
            ),

            // Animated Logo
            Center(
              child: FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      ImageAssets.logoSplash,
                      width: 250.w,
                      height: 250.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            // App Name at the bottom
            Positioned(
              bottom: 80.h,
              child: FadeTransition(
                opacity: _nameFade,
                child: SlideTransition(
                  position: _nameSlide,
                  child: Column(
                    children: [
                      Text(
                        AppStrings.myCarAuction.tr(),
                        style: getBoldStyle(
                          fontSize: 26.sp,
                          color: ColorManager.primary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: 50.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorManager.primary,
                              ColorManager.primary.withValues(alpha: 0.5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _mainController.dispose();
    _glowController.dispose();
    super.dispose();
  }
}
