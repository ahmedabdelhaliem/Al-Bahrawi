import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import '../../model/profile_model.dart';

class AccountActionButton extends StatelessWidget {
  final ProfileModel model;
  const AccountActionButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(model.route, extra: {'title': model.title});
      },
      borderRadius: BorderRadius.circular(50.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: ColorManager.white,
          border: Border.all(
            color: ColorManager.grey.withValues(alpha: 0.2),
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text on the left
            Text(
              model.title.tr(),
              style: getMediumStyle(
                fontSize: 15.sp,
                color: ColorManager.greyTextColor,
              ),
            ),
            // Icon on the right
            Icon(
              model.icon,
              color: ColorManager.greyTextColor,
              size: 24.r,
            ),
          ],
        ),
      ),
    );
  }
}
