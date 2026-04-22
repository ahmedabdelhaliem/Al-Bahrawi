import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';


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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          // Left Side: Tag
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
            ),
            child: Text(
              'نظام جديد',
              style: getMediumStyle(color: Colors.red, fontSize: 10.sp),
            ),
          ),

          SizedBox(width: 16.w),

          // Right Side: Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'تم اضافة $amount نقطة الى حسابك',
                  style: getBoldStyle(
                    fontSize: 14.sp,
                    color: ColorManager.primary,
                  ),
                  textAlign: TextAlign.end,
                ),
                SizedBox(height: 4.h),
                Text(
                  'تاريخ العملية - $date',
                  style: getMediumStyle(
                    fontSize: 12.sp,
                    color: ColorManager.greyText,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
