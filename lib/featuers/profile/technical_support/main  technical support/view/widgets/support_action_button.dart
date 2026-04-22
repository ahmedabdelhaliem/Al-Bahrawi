import 'package:base_project/common/helper/spacer.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupportActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isWhatsApp;

  const SupportActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isWhatsApp = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: ColorManager.greyBorder, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text on the left
            Text(
              title,
              style: getMediumStyle(
                fontSize: 16.sp,
                color: ColorManager.black.withValues(alpha: 0.6),
              ),
            ),
            // Icon on the right
            Icon(
              icon,
              size: 24.r,
              color: ColorManager.black.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
