import 'package:base_project/common/helper/spacer.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/svg_icon.dart';
import 'package:base_project/featuers/profile/help/view/widgets/contact_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        image: const DecorationImage(
          image: AssetImage(ImageAssets.helpBg),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primary.withValues(alpha: 0.2),
            blurRadius: 15.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorManager.primary.withValues(alpha: 0.4),
              ColorManager.primary.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            Text(
              AppStrings.contactInfo.tr(),
              style: getBoldStyle(fontSize: 22.sp, color: ColorManager.white),
            ),
            verticalSpace(8),
            Text(
              AppStrings.startChat.tr(),
              style: getMediumStyle(
                fontSize: 14.sp,
                color: ColorManager.white.withValues(alpha: 0.9),
              ),
            ),
            verticalSpace(32),
            ContactItem(
              icon: IconAssets.location,
              text: AppStrings.addressDetail.tr(),
            ),
            verticalSpace(16),
            ContactItem(
              icon: IconAssets.email,
              text: AppStrings.emailDetail.tr(),
            ),
            verticalSpace(32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgIcon(url: IconAssets.discord, color: Colors.white),

                horizontalSpace(24),
                CircleAvatar(
                  radius: 20.r,
                  child: SvgIcon(
                    url: IconAssets.instigram,
                    color: Colors.black,
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
                horizontalSpace(24),
                SvgIcon(url: IconAssets.twetter, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
