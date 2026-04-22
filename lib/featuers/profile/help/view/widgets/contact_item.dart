import 'package:base_project/common/helper/spacer.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

class ContactItem extends StatelessWidget {
  final String icon;
  final String text;
  const ContactItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgIcon(url: icon, color: ColorManager.white),
        verticalSpace(8),
        Text(
          text,
          style: getMediumStyle(fontSize: 14.sp, color: ColorManager.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
