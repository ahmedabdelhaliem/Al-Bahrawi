import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String text;
  final bool withLeading;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? titleFontSize;
  final Widget? bottom;
  final double? height;
  final bool centerTitle;
  final double? elevation;
  final Widget? titleWidget;
  final double? leadingWidth;
  const DefaultAppBar({super.key, this.text = '', this.withLeading = true, this.backgroundColor, this.titleColor, this.bottom, this.height, this.titleFontSize, this.centerTitle = false, this.elevation, this.titleWidget, this.leadingWidth});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: height,
      automaticallyImplyLeading: withLeading,
      iconTheme: IconThemeData(color: titleColor??ColorManager.lightBlackText,size: 20.r),
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
      title: titleWidget??(text.isEmpty ? null : Text(text,style: getMediumStyle(fontSize: titleFontSize??15.sp,color: titleColor??ColorManager.black),)),
      // leading: withLeading ? null : const SizedBox.shrink(),
      bottom: bottom != null ? PreferredSize(preferredSize: preferredSize, child: bottom!) : null,
      elevation: 0,
      leadingWidth: leadingWidth,
      shadowColor: ColorManager.greyBorder.withValues(alpha: .4),
      scrolledUnderElevation: elevation??0,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height??50.h);
}
