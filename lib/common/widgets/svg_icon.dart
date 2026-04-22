import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final String url;
  final Color? color;
  const SvgIcon({
    super.key,
    this.width,
    this.height,
    required this.url,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      url,
      width: width ?? 24.w,
      height: height ?? 24.h,
      colorFilter: ColorFilter.mode(color ?? Colors.black, BlendMode.srcIn),
    );
  }
}
