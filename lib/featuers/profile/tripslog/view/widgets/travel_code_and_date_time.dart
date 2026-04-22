import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TravelCodeAndDateTime extends StatelessWidget {
  const TravelCodeAndDateTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '07/07/2025  9:00 ص',
          style: getMediumStyle(fontSize: 12.sp, color: ColorManager.primary),
        ),
        Text(
          '#156555',
          style: getRegularStyle(fontSize: 12.sp, color: ColorManager.primary),
        ),
      ],
    );
  }
}
