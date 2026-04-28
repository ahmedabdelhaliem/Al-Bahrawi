import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DefaultButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final double width;
  final double? height;
  final double? fontSize;
  final bool withBorder;
  final bool isUnderLine;
  final bool isIcon;
  final bool isText;
  final bool isLoading;
  final bool textFirst;
  final String svgPath;
  final Color? color;
  final Gradient? gradient;
  final Color? underLineColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? borderColor;
  final double? radius;
  final double? iconSize;
  final double? horizontalPadding;
  final double? verticalPadding;
  final TextStyle? textStyle;
  final bool isTextCenter;
  final double? textHeight;
  final Widget? verticalWidget;
  final Widget? child;
  final double? elevation;
  final Widget? iconBuilder;
  final bool isExpanded;
  final Color? overlayColor;
  final Color? loadingColor;

  const DefaultButtonWidget({
    super.key,
    this.onPressed,
    this.text = '',
    this.width = double.infinity,
    this.withBorder = false,
    this.isIcon = false,
    this.svgPath = '',
    this.color,
    this.gradient,
    this.isText = true,
    this.height,
    this.textColor,
    this.iconColor,
    this.radius,
    this.horizontalPadding,
    this.verticalPadding,
    this.borderColor,
    this.isUnderLine = false,
    this.fontSize,
    this.underLineColor,
    this.iconSize,
    this.textFirst = false,
    this.textStyle,
    this.isLoading = false,
    this.isTextCenter = true,
    this.textHeight,
    this.verticalWidget,
    this.child,
    this.elevation,
    this.iconBuilder,
    this.isExpanded = true,
    this.overlayColor,
    this.loadingColor,
  });

  const DefaultButtonWidget.arrowIcon({
    super.key,
    this.onPressed,
    this.text = '',
    this.width = double.infinity,
    this.withBorder = false,
    this.svgPath = '',
    this.color,
    this.gradient,
    this.height,
    this.textColor,
    this.iconColor,
    this.radius,
    this.borderColor,
    this.isUnderLine = false,
    this.fontSize,
    this.underLineColor,
    this.iconSize,
    this.textStyle,
    this.isLoading = false,
    this.isTextCenter = true,
    this.textHeight,
    this.verticalWidget,
    this.child,
    this.elevation,
    this.isExpanded = true,
    this.overlayColor,
    this.loadingColor,
  }) : iconBuilder = const CircleAvatar(
         radius: 20,
         backgroundColor: ColorManager.white,
         child: Icon(Icons.arrow_forward),
       ),
       isIcon = true,
       isText = true,
       textFirst = true,
       verticalPadding = 5,
       horizontalPadding = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: gradient == null
            ? (isLoading ? ColorManager.greyBorder : (color ?? ColorManager.primary))
            : null,
        gradient: isLoading ? null : gradient,
        borderRadius: BorderRadius.circular(radius ?? 12.sp),
        border: withBorder
            ? Border.all(color: borderColor ?? ColorManager.green)
            : null,
        boxShadow: (elevation ?? 3) > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: elevation ?? 3,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(radius ?? 12.sp),
          overlayColor: WidgetStatePropertyAll(
            overlayColor ??
                (withBorder
                    ? ColorManager.primary.withOpacity(.1)
                    : ColorManager.white.withOpacity(.3)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding ?? 8.h,
              horizontal: horizontalPadding ?? 10.w,
            ),
            child:
                child ??
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (verticalWidget != null) verticalWidget!,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isIcon && !textFirst) _svgIcon(),
                        if (isIcon && isText) SizedBox(width: 10.w),
                        if (isText)
                          isLoading
                              ? SizedBox(
                                  height: 20.w,
                                  width: 20.w,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: loadingColor ?? Colors.white,
                                    ),
                                  ),
                                )
                              : Flexible(
                                  fit: isExpanded
                                      ? FlexFit.tight
                                      : FlexFit.loose,
                                  child: Text(
                                    text,
                                    textAlign: isTextCenter
                                        ? TextAlign.center
                                        : null,
                                    style:
                                        textStyle ??
                                        getBoldStyle(
                                          fontSize: fontSize ?? 13.sp,
                                          color:
                                              textColor ?? ColorManager.white,
                                          height: textHeight,
                                        ),
                                  ),
                                ),
                        if (isIcon && textFirst) SizedBox(width: 10.w),
                        if (isIcon && textFirst) _svgIcon(),
                      ],
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget _svgIcon() {
    return iconBuilder ??
        SvgPicture.asset(
          svgPath,
          height: iconSize ?? 22.h,
          width: iconSize ?? 22.w,
          fit: BoxFit.fill,
          color: iconColor,
        );
  }
}
