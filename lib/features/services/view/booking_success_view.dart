import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';

class BookingSuccessView extends StatelessWidget {
  const BookingSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            // Success Icon with glow effect
            Container(
              padding: EdgeInsets.all(30.w),
              decoration: BoxDecoration(
                color: ColorManager.gold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: ColorManager.gold.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified_rounded,
                  color: ColorManager.gold,
                  size: 80.w,
                ),
              ),
            ),
            SizedBox(height: 40.h),
            // Title
            Text(
              AppStrings.bookingSuccessTitle.tr(),
              style: getBoldStyle(color: ColorManager.blue, fontSize: 24.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            // Description
            Text(
              AppStrings.bookingSuccessDesc.tr(),
              style: getRegularStyle(color: ColorManager.greyText, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 2),
            // Back to Home Button
            DefaultButtonWidget(
              text: AppStrings.backToHome.tr(),
              onPressed: () => context.go(AppRouters.btmNav),
              color: ColorManager.blue,
              textColor: ColorManager.white,
              height: 55.h,
              radius: 16.r,
              isIcon: true,
              iconBuilder: Icon(Icons.home_outlined, color: ColorManager.gold, size: 20.w),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
