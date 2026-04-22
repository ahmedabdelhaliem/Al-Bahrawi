import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';

class CategoryItemWidget extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const CategoryItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 80.w,
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          children: [
            Container(
              height: 60.w,
              width: 60.w,
              decoration: BoxDecoration(
                color: ColorManager.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorManager.primary.withValues(alpha: 0.1),
                  width: 1.w,
                ),
              ),
              child: Center(
                child: icon.endsWith('.svg') 
                  ? SvgPicture.asset(
                      icon,
                      width: 28.w,
                      height: 28.w,
                      colorFilter: const ColorFilter.mode(
                        ColorManager.primary,
                        BlendMode.srcIn,
                      ),
                    )
                  : Image.asset(
                      icon,
                      width: 28.w,
                      height: 28.w,
                    ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: getMediumStyle(
                color: ColorManager.textColor,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
