import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_image_widget.dart';

class SpecialOfferBannerWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final VoidCallback onTap;

  const SpecialOfferBannerWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        height: 140.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: ColorManager.primary.withValues(alpha: 0.15),
              blurRadius: 15.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: DefaultImageWidget(
                image: image,
                width: double.infinity,
                height: 140.h,
                fit: BoxFit.cover,
              ),
            ),
            // Gradient Overlay for text readability
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                  colors: [
                    ColorManager.black.withValues(alpha: 0.6),
                    ColorManager.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
            // Promotion Text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getBoldStyle(
                      color: ColorManager.white,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    subtitle,
                    style: getMediumStyle(
                      color: ColorManager.white.withValues(alpha: 0.9),
                      fontSize: 14.sp,
                    ),
                  ),
                  const Spacer(),
                  // "Get it now" button-like text
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: ColorManager.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "احصل عليه الآن", // Get it now in Arabic
                      style: getBoldStyle(
                        color: ColorManager.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
