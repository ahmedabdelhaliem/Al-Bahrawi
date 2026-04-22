import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingSelectorField extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final VoidCallback onTap;

  const BookingSelectorField({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: ColorManager.primary, width: .5.w),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withValues(alpha: 0.02),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Leading Icon with soft background
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: ColorManager.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.black.withValues(alpha: 0.02),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Icon(leadingIcon, color: ColorManager.primary, size: 20.r),
              ),

              // Text and Dropdown Arrow grouped at the end
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: getBoldStyle(color: ColorManager.primary, fontSize: 11.sp),
                  ),
                  SizedBox(width: 8.w),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: ColorManager.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
