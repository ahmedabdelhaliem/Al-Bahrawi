import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';

class SummaryCard extends StatelessWidget {
  final Map<String, String> details;

  const SummaryCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: ColorManager.azureBlue.withValues(alpha: 0.5), width: 1.w),
      ),
      child: Column(
        children: details.entries.map((entry) {
          final isLast = entry.key == details.keys.last;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.value,
                  style: getBoldStyle(color: ColorManager.primary, fontSize: 13.sp),
                ),
                Text(
                  entry.key,
                  style: getRegularStyle(color: ColorManager.greyText, fontSize: 13.sp),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
