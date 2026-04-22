import 'package:base_project/common/helper/spacer.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletBalanceCard extends StatelessWidget {
  final double balance;
  const WalletBalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: ColorManager.primaryGradient,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primary.withValues(alpha: 0.3),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative background circles for premium look
          Positioned(
            right: -20.w,
            top: -20.h,
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            left: 20.w,
            bottom: -30.h,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppStrings.your_balance.tr(),
                  style: getMediumStyle(
                    fontSize: 16.sp,
                    color: ColorManager.white.withValues(alpha: 0.9),
                  ),
                ),
                verticalSpace(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      balance.toStringAsFixed(2),
                      style: getBoldStyle(
                        fontSize: 36.sp,
                        color: ColorManager.white,
                      ),
                    ),
                    horizontalSpace(8),
                    Text(
                      AppStrings.egp.tr(),
                      style: getMediumStyle(
                        fontSize: 18.sp,
                        color: ColorManager.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                verticalSpace(24),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 13.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: ColorManager.primary, size: 24.sp),
                      horizontalSpace(4),
                      Text(
                        AppStrings.chargeBalance.tr(),
                        style: getMediumStyle(
                          fontSize: 16.sp,
                          color: ColorManager.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                // DefaultButtonWidget(
                //   width: 160.w,
                //   height: 48.h,
                //   color: ColorManager.white,
                //   text: AppStrings.chargeBalance.tr(),
                //   textColor: ColorManager.primary,
                //   radius: 50.r,
                //   isIcon: true,
                //   svgPath: 'assets/icons/add.svg',
                //   iconColor: ColorManager.primary,
                //   iconSize: 18.sp,
                //   elevation: 5,
                //   onPressed: () {},
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
