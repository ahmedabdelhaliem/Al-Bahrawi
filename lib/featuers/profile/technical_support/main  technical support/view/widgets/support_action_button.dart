import 'package:base_project/common/helper/spacer.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupportActionButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final bool isWhatsApp;

  const SupportActionButton({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.isWhatsApp = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50.r),

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: isWhatsApp
              ? ColorManager.successGreen.withValues(alpha: 0.1)
              : ColorManager.white,
          borderRadius: BorderRadius.circular(50.r),
          border: isWhatsApp
              ? null
              : Border.all(color: ColorManager.greyBorder, width: 1),
        ),
        child: Row(
          children: [
            SvgIcon(
              url: iconPath,
              width: 24.w,
              height: 24.w,
              color: isWhatsApp
                  ? ColorManager.successGreen
                  : ColorManager.black.withValues(alpha: 0.6),
            ),
            horizontalSpace(16),
            Text(
              title,
              style: getMediumStyle(
                fontSize: 16.sp,
                color: isWhatsApp
                    ? ColorManager.successGreen
                    : ColorManager.black.withValues(alpha: 0.6),
              ),
            ),
            horizontalSpace(12),
          ],
        ),
      ),
    );
  }
}
