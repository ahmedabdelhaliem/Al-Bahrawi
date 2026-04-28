import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';

class DefaultListTile extends StatefulWidget {
  final String? iconPath;
  final String title;
  final String? subTitle;
  final String actionButtonText;
  final void Function()? actionButtonOnPressed;
  final void Function()? onTap;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final double? actionIconSize;
  final bool withUnderLine;
  final bool withTrailing;
  final Color? tileColor;
  final Color? itemsColor;
  final Color? subTitleColor;
  final bool fromNetwork;
  final bool isLoading;
  final Color? borderColor;
  final bool withBorder;
  final TextAlign? subTitleTextAlign;
  final TextAlign? titleTextAlign;

  const DefaultListTile(
      {super.key,
      this.iconPath,
      required this.title,
      this.actionButtonText = '',
      this.actionButtonOnPressed,
      this.titleStyle,
      this.onTap,
      this.actionIconSize,
      this.withUnderLine = false,
      this.withTrailing = true,
      this.tileColor,
      this.fromNetwork = false,
      this.itemsColor,
      this.isLoading = false,
        this.subTitle,
        this.subTitleStyle, this.subTitleColor, this.borderColor, this.withBorder = false, this.subTitleTextAlign, this.titleTextAlign});

  @override
  State<DefaultListTile> createState() => _DefaultListTileState();
}

class _DefaultListTileState extends State<DefaultListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: !widget.withBorder ? null : RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.r),
        side: BorderSide(color: widget.borderColor??ColorManager.greyBorder, width: 1.w),
      ),
      contentPadding: EdgeInsets.zero,
      onTap: widget.onTap,
      tileColor: widget.tileColor,
      leading: widget.fromNetwork
          ? Image.network(
              widget.iconPath ?? '',
              height: 20.h,
              width: 20.w,
              errorBuilder: (context, error, stackTrace) => CircleAvatar(
                backgroundColor: ColorManager.green.withValues(alpha: .3),
                radius: 15.sp,
              ),
            )
          : SvgPicture.asset(
              widget.iconPath ?? '',
              height: 20.w,
              width: 20.w,
              color: widget.itemsColor,
              errorBuilder: (context, error, stackTrace) => CircleAvatar(
                backgroundColor: ColorManager.green.withValues(alpha: .3),
                radius: 15.sp,
              ),
            ),
      minLeadingWidth: 0,
      minTileHeight: 0,
      minVerticalPadding: 0,
      horizontalTitleGap: 10.w,
      title: Text(
        widget.title,
        style: widget.titleStyle ??
            getRegularStyle(
                fontSize: 13.sp,
                color: widget.itemsColor ?? ColorManager.black.withValues(alpha: .7),
            ),
        textAlign: widget.titleTextAlign,
      ),
      subtitle: widget.subTitle == null ? null : Text(
        widget.subTitle!,
        style: widget.subTitleStyle ??
            getRegularStyle(
                fontSize: 13.sp,
                color: widget.subTitleColor ?? ColorManager.greyTextColor.withValues(alpha: .7),
            ),
        textAlign: widget.subTitleTextAlign,
      ),
      trailing: _getTrailingWidget(),
    );
  }

  _getTrailingWidget() {
    if (widget.isLoading) {
      return SizedBox(
          height: 20.w,
          width: 20.w,
          child: Center(
              child: CircularProgressIndicator(
            color: widget.itemsColor ?? ColorManager.primary,
          )));
    }
    if (!widget.withTrailing) {
      return null;
    } else if (widget.actionButtonText.isNotEmpty) {
      return TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.h),
            textStyle:
                TextStyle(decoration: widget.withUnderLine ? TextDecoration.underline : null),
            minimumSize: const Size(0, 0),
          ),
          onPressed: widget.actionButtonOnPressed,
          child: Text(
            widget.actionButtonText,
            style: getBoldStyle(fontSize: 15.sp, color: ColorManager.primary, height: 1.5.h),
          ));
    } else {
      return Icon(
        Icons.arrow_forward_ios_outlined,
        color: widget.itemsColor ?? ColorManager.textColor,
        size: widget.actionIconSize ?? 15.r,
      );
    }
  }
}
