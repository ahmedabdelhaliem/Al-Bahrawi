import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:base_project/app/app_prefs.dart';
import 'package:base_project/app/di.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';

class HomeHeaderWidget extends StatelessWidget {
  final VoidCallback onSearchTap;
  
  const HomeHeaderWidget({
    super.key,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final userName = instance<AppPreferences>().getUserName();
    final userImage = instance<AppPreferences>().getUserImage();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            padding: EdgeInsets.all(2.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorManager.primary,
                width: 1.5.w,
              ),
            ),
            child: CircleAvatar(
              radius: 24.r,
              backgroundColor: ColorManager.lightGrey,
              backgroundImage: userImage != null && userImage.isNotEmpty
                  ? NetworkImage(userImage) as ImageProvider
                  : const AssetImage(ImageAssets.profile),
            ),
          ),
          SizedBox(width: 12.w),
          // Greeting Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${AppStrings.hello.tr()} $userName",
                  style: getBoldStyle(
                    color: ColorManager.primary,
                    fontSize: 16.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  AppStrings.searchForMaterials.tr(),
                  style: getRegularStyle(
                    color: ColorManager.greyText,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          // Search Icon Button
          GestureDetector(
            onTap: onSearchTap,
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: ColorManager.primary,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.primary.withValues(alpha: 0.3),
                    blurRadius: 8.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                IconAssets.search,
                colorFilter: const ColorFilter.mode(
                  ColorManager.white,
                  BlendMode.srcIn,
                ),
                width: 20.w,
                height: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
