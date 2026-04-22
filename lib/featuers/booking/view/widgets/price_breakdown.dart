import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';

class PriceBreakdown extends StatelessWidget {
  final double seatPrice;
  final double discount;
  final double bookingFees;

  const PriceBreakdown({
    super.key,
    required this.seatPrice,
    required this.discount,
    required this.bookingFees,
  });

  @override
  Widget build(BuildContext context) {
    double total = seatPrice - discount + bookingFees;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        children: [
          _buildPriceRow("سعر المقعد", seatPrice),
          _buildPriceRow("خصم بروموكود", -discount, isDiscount: true),
          _buildPriceRow("رسوم الحجز", bookingFees),
          const Divider(height: 30, color: ColorManager.dividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$total ${"pound".tr()}",
                style: getBoldStyle(color: ColorManager.primary, fontSize: 18.sp),
              ),
              Text(
                "الاجمالي",
                style: getBoldStyle(color: ColorManager.primary, fontSize: 16.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double price, {bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${price.abs()} ${"pound".tr()}",
            style: getBoldStyle(
              color: isDiscount ? ColorManager.red : ColorManager.primary,
              fontSize: 14.sp,
            ),
          ),
          Text(
            label,
            style: getRegularStyle(color: ColorManager.greyText, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
