import 'package:base_project/common/helper/spacer.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletTransactionItem extends StatelessWidget {
  final String amount;
  final String date;
  const WalletTransactionItem({
    super.key,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: 0.04),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Indicator
          Container(
            margin: EdgeInsets.only(top: 4.h),
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorManager.successGreen,
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.amountTransferredToBalance.tr(args: [amount]),
                  style: getSemiBoldStyle(
                    fontSize: 15.sp,
                    color: ColorManager.textColor,
                  ),
                ),
                verticalSpace(8),
                Row(
                  children: [
                    Text(
                      '${AppStrings.transactionDate.tr()}: ',
                      style: getRegularStyle(
                        fontSize: 12.sp,
                        color: ColorManager.greyText,
                      ),
                    ),
                    Text(
                      date,
                      style: getMediumStyle(
                        fontSize: 12.sp,
                        color: ColorManager.textColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
