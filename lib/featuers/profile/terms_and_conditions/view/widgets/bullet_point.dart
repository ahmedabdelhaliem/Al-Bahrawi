import 'package:base_project/common/helper/spacer.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BulletPoint extends StatelessWidget {
  final String content;

  const BulletPoint({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Container(
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorManager.black.withValues(alpha: 0.6),
            ),
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: Text(
            content,
            style: getRegularStyle(
              fontSize: 14.sp,
              color: ColorManager.black.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
