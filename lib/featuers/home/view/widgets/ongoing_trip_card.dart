import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class OngoingTripCard extends StatelessWidget {
  const OngoingTripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: ColorManager.primary, width: 0.5.w),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: 0.05),
            blurRadius: 15.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Status and Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Track Location Button
                GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=30.0444,31.2357',
                    );
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                      // Handle error if needed
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: ColorManager.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.map_outlined, color: ColorManager.primary, size: 18.r),
                        SizedBox(width: 6.w),
                        Text(
                          "تتبع موقعك",
                          style: getBoldStyle(color: ColorManager.primary, fontSize: 13.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                // Line Name
                Text(
                  AppStrings.octoberLine.tr(),
                  style: getBoldStyle(color: const Color(0xFF000000), fontSize: 18.sp),
                ),
              ],
            ),

            // Subtitle: Bus Number
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: EdgeInsets.only(top: 4.h, bottom: 12.h),
                child: Text(
                  "أ-ب-ع 1265",
                  style: getMediumStyle(color: const Color(0xFFB0BEC5), fontSize: 14.sp),
                ),
              ),
            ),

            // Info Rows
            _infoRow(
              icon1: Icons.calendar_month_outlined,
              text1: "15 سبتمبر 2026",
              icon2: Icons.location_on_outlined,
              text2: "مدينة نصر",
            ),
            SizedBox(height: 12.h),
            _infoRow(
              icon1: Icons.directions_bus_outlined,
              text1: "High Standard",
              icon2: Icons.location_on_outlined,
              text2: "مدينة نصر",
            ),

            // Divider
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Divider(height: 1.h, color: const Color(0xFFE3F2FD)),
            ),

            // Footer: Cancel Button and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Cancel Button
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: ColorManager.red, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                  ),
                  child: Text(
                    AppStrings.cancelBooking.tr(),
                    style: getBoldStyle(color: ColorManager.red, fontSize: 12.sp),
                  ),
                ),

                // Price Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.total.tr(),
                      style: getMediumStyle(color: const Color(0xFFB0BEC5), fontSize: 13.sp),
                    ),
                    Text(
                      "100 ${"pound".tr()}",
                      style: getBoldStyle(color: const Color(0xFF0D47A1), fontSize: 14.sp),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon1,
    required String text1,
    required IconData icon2,
    required String text2,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left part: Location/City
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text2,
              style: getMediumStyle(color: Colors.black87, fontSize: 13.sp),
            ),
            SizedBox(width: 6.w),
            Icon(icon2, size: 20.r, color: const Color(0xFF0D47A1)),
          ],
        ),
        // Right part: Date/Standard
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text1,
              style: getMediumStyle(color: Colors.black87, fontSize: 13.sp),
            ),
            SizedBox(width: 6.w),
            Icon(icon1, size: 20.r, color: const Color(0xFF0D47A1)),
          ],
        ),
      ],
    );
  }
}
