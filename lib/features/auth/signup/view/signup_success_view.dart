import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignupSuccessView extends StatelessWidget {
  const SignupSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => context.go(AppRouters.login),
            icon: const Icon(Icons.arrow_forward, color: Colors.grey),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            const Spacer(flex: 3),
            // Success Badge with Decorative Dots
            SizedBox(
              width: 180.w,
              height: 180.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative dots
                  Positioned(
                    top: 20.h,
                    right: 20.w,
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: const BoxDecoration(
                        color: ColorManager.successGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40.h,
                    left: 10.w,
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: const BoxDecoration(
                        color: ColorManager.successGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40.h,
                    right: 10.w,
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: const BoxDecoration(
                        color: ColorManager.successGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Outer transparent green circle
                  Container(
                    width: 140.w,
                    height: 140.w,
                    decoration: BoxDecoration(
                      color: ColorManager.successGreen.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: const BoxDecoration(
                        color: ColorManager.successGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.verified_user_outlined,
                        // color: ColorManager.blue.withValues(alpha: 0.8),
                        size: 30.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            // Success Title
            Text(
              AppStrings.accountCreatedSuccessfully,
              style: getBoldStyle(fontSize: 22.sp, color: ColorManager.textColor),
              textAlign: TextAlign.center,
            ).tr(),
            SizedBox(height: 12.h),
            // Success Subtitle
            Text(
              "يمكنك الآن تسجيل الدخول باستخدام الحساب الشخصي الخاص بك",
              style: getRegularStyle(fontSize: 14.sp, color: ColorManager.grey),
              textAlign: TextAlign.center,
            ).tr(),
            const Spacer(flex: 3),
            // Return to Login Button
            DefaultButtonWidget(
              onPressed: () {
                context.go(AppRouters.login);
              },
              text: "العودة لتسجيل الدخول",
              color: ColorManager.primary,
              textColor: ColorManager.white,
              radius: 12.r,
              verticalPadding: 14.h,
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
