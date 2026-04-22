import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:base_project/app/app_constants.dart';
import 'package:base_project/app/app_prefs.dart';
import 'package:base_project/app/di.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/values_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  _startDelay() {
    _timer = Timer(AppConstants.splashDuration, _goNext);
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

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

    // globalMethods.registerNotification(context);
    // setupInteractedMessage();
    // if(instance<AppPreferences>().isOnBoardingScreenViewed()){
    //     context.go(AppRouters.btmNav,
    //     extra: {'refreshKey': UniqueKey()},
    //     );
    // }else{
    //   context.go(AppRouters.onBoarding);
    // }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
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
      backgroundColor: ColorManager.blue,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset(
              ImageAssets.logoSplash,
              width: 250.w, // Reduced size
              height: 250.w,
            ),
          ),
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
