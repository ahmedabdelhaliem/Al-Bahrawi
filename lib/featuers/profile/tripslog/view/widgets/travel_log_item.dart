import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'travel_code_and_date_time.dart';

class TravelLogItem extends StatelessWidget {
  const TravelLogItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Row: Code and Date/Time
            const TravelCodeAndDateTime(),

            SizedBox(height: 10.h),

            // Middle Section: Route
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Destination (Left side in RTL image)
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الحي الحكومي',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(color: ColorManager.primary, fontSize: 14.sp),
                      ),
                      Text(
                        '10:00 ص',
                        style: getMediumStyle(color: ColorManager.primary, fontSize: 11.sp),
                      ),
                    ],
                  ),
                ),

                // Center logic
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Text(
                        'الى',
                        style: getLightStyle(color: Colors.black54, fontSize: 11.sp),
                      ),
                      Row(
                        children: [
                          Expanded(child: _dottedLine()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Icon(Icons.directions_bus_rounded, color: ColorManager.primary.withValues(alpha: 0.5), size: 12.r),
                          ),
                          Expanded(child: _dottedLine()),
                        ],
                      ),
                    ],
                  ),
                ),

                // Origin (Right side in RTL image)
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'التجمع الخامس',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(color: ColorManager.primary, fontSize: 14.sp),
                      ),
                      Text(
                        '9:00 ص',
                        style: getMediumStyle(color: ColorManager.primary, fontSize: 11.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Subtle Divider
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Divider(height: 1.h, color: ColorManager.greyBorder.withValues(alpha: 0.2)),
            ),

            // Bottom Section: Bus Image and Label
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bus Shape Label + Icon (Left)
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.directions_bus_outlined,
                          color: const Color(0xFF455A64),
                          size: 16.r,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'شكل الباص',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(color: const Color(0xFF455A64), fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bus Interior Image (Right)
                Flexible(
                  child: Container(
                    width: 120.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://img.freepik.com/premium-photo/interior-luxury-modern-bus-night_674594-406.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dottedLine() {
    return Row(
      children: List.generate(
        8,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.5.w),
            height: 2.h,
            width: 2.w,
            decoration: BoxDecoration(
              color: ColorManager.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
