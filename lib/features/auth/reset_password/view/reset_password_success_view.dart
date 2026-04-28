import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';

class ResetPasswordSuccessView extends StatelessWidget {
  const ResetPasswordSuccessView({super.key});

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
            const Spacer(flex: 2),
            // Success Badge Icon
            Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                color: ColorManager.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: ColorManager.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: ColorManager.white,
                  size: 60.w,
                ),
              ),
            ),
            SizedBox(height: 32.h),
            // Success Title
            Text(
              AppStrings.passwordChangedSuccessfully,
              style: getBoldStyle(
                fontSize: 22.sp,
                color: ColorManager.textColor,
              ),
              textAlign: TextAlign.center,
            ).tr(),
            SizedBox(height: 12.h),
            // Success Subtitle
            Text(
              AppStrings.youCanNowLoginWithNewPassword,
              style: getRegularStyle(
                fontSize: 14.sp,
                color: ColorManager.grey,
              ),
              textAlign: TextAlign.center,
            ).tr(),
            const Spacer(flex: 3),
            // Back to Login Button
            DefaultButtonWidget(
              onPressed: () {
                context.go(AppRouters.login);
              },
              text: AppStrings.backToLogin,
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
