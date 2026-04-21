import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';

class SignupSuccessView extends StatelessWidget {
  const SignupSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: ColorManager.successGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: ColorManager.successGreen,
                size: 80.w,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              "تم إنشاء الحساب بنجاح!", // Or use AppStrings if added
              style: getBoldStyle(
                fontSize: 22.sp,
                color: ColorManager.textColor,
              ),
              textAlign: TextAlign.center,
            ).tr(),
            SizedBox(height: 12.h),
            Text(
              "يمكنك الآن الدخول إلى رصيدك ومسار رحلتك بكل سهولة",
              style: getRegularStyle(
                fontSize: 14.sp,
                color: ColorManager.greyTextColor,
              ),
              textAlign: TextAlign.center,
            ).tr(),
            const Spacer(flex: 2),
            DefaultButtonWidget(
              onPressed: () {
                context.go(AppRouters.btmNav);
              },
              text: "الصفحة الرئيسية",
              gradient: ColorManager.primaryGradient,
              textColor: ColorManager.white,
              radius: 40.r,
              verticalPadding: 14.h,
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
