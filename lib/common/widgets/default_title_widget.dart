import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';

class DefaultTitleWidget extends StatefulWidget {
  final String title;
  final TextStyle? titleStyle;
  final Color? titleColor;
  final double? fontSize;
  final double? horizontalPadding;
  final Function()? onTap;

  const DefaultTitleWidget({
    super.key,
    required this.title,
    this.onTap,
    this.horizontalPadding,
    this.titleStyle,
    this.titleColor,
    this.fontSize,
  });

  @override
  State<DefaultTitleWidget> createState() => _DefaultTitleWidgetState();
}

class _DefaultTitleWidgetState extends State<DefaultTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding ?? 15.w,
      ),
      child: Row(
        children: [
          Text(
            widget.title,
            style:
                widget.titleStyle ??
                getMediumStyle(
                  fontSize: widget.fontSize ?? 15.sp,
                  color: widget.titleColor ?? ColorManager.black,
                ),
          ),
          if (widget.onTap != null) ...[
            Spacer(),
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppStrings.showMore.tr(),
                    recognizer: TapGestureRecognizer()..onTap = widget.onTap,
                    style: getBoldStyle(
                      fontSize: 13.sp,
                      color: ColorManager.primary,
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],

              ),
            ),
          ],
        ],
      ),
    );
  }
}
