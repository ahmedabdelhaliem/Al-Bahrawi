import 'package:base_project/common/helper/spacer.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/widgets/svg_icon.dart';
import 'package:base_project/featuers/profile/main%20profile/model/profile_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AccountActionButton extends StatelessWidget {
  final ProfileModel model;
  const AccountActionButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(model.route, extra: {'title': model.title});
      },
      splashColor: ColorManager.azureBlue,
      borderRadius: BorderRadius.circular(50.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          border: Border.all(color: ColorManager.grey.withValues(alpha: .3)),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          children: [
            SvgIcon(url: model.icon),
            horizontalSpace(16),
            Text(
              model.title.tr(),
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorManager.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
