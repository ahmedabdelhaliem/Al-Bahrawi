import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
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
      height: 180.h,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: ColorManager.primary, // Dark blue from image
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // "نقاطك" Label
          Text(
            'نقاطك', // Hardcoded for now as per image or use tr() if key exists
            style: getBoldStyle(
              fontSize: 18.sp,
              color: Colors.white,
            ),
          ),

          // Balance Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${balance.toStringAsFixed(2)} EGP',
                style: getBoldStyle(
                  fontSize: 32.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
