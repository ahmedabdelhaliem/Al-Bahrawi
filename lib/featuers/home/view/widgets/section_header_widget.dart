import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback onViewAllTap;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.tr(),
            style: getBoldStyle(
              color: ColorManager.textColor,
              fontSize: 18.sp,
            ),
          ),
          TextButton(
            onPressed: onViewAllTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              AppStrings.viewAll.tr(),
              style: getMediumStyle(
                color: ColorManager.primary,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
