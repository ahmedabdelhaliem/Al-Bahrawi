import 'package:base_project/common/helper/spacer.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:base_project/common/widgets/svg_icon.dart';
import 'package:base_project/featuers/profile/tripslog/view/widgets/travel_code_and_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TravelLogItem extends StatelessWidget {
  const TravelLogItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: ColorManager.greyBorder),
          boxShadow: [
            BoxShadow(
              color: ColorManager.greyBorder.withValues(alpha: 0.1),
              blurRadius: 10.r,
              offset: Offset(0, 5.h),
            ),
          ],
        ),

        child: Column(
          children: [
            TravelCodeAndDateTime(),
            verticalSpace(10),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'التجمع الخامس',
                      style: getMediumStyle(
                        fontSize: 16.sp,
                        color: ColorManager.primary,
                      ),
                    ),
                    Text(
                      ' الى',
                      style: getLightStyle(
                        fontSize: 16.sp,
                        color: ColorManager.black,
                      ),
                    ),
                    Text(
                      'الحي الحكومي',
                      style: getMediumStyle(
                        fontSize: 16.sp,
                        color: ColorManager.primary,
                      ),
                    ),
                  ],
                ),
                verticalSpace(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '9:00 ص',
                      style: getMediumStyle(
                        fontSize: 16.sp,
                        color: ColorManager.primary,
                      ),
                    ),
                    Text(
                      ' الى',
                      style: getLightStyle(
                        fontSize: 16.sp,
                        color: ColorManager.black,
                      ),
                    ),
                    Text(
                      '10:00 م',
                      style: getMediumStyle(
                        fontSize: 16.sp,
                        color: ColorManager.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            verticalSpace(10),
            Divider(thickness: 1, color: ColorManager.greyBorder),
            horizontalSpace(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgIcon(url: IconAssets.bus, color: ColorManager.primary),
                    horizontalSpace(5),
                    DefaultButtonWidget(
                      width: 120,

                      color: ColorManager.yellow,
                      text: 'متبقي 3 مقاعد',
                      onPressed: () {},
                    ),
                  ],
                ),

                Text(
                  '50 جنية مصري',
                  style: getMediumStyle(
                    fontSize: 14.sp,
                    color: ColorManager.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
