import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:base_project/app/app_prefs.dart';
import 'package:base_project/app/di.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/values_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';

class DefaultFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? redText;
  final String? title;
  final Widget? hintWidget;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool? enabled;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final bool disableHelperText;
  final bool? inLeft;
  final int? maxLength;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool withInputFormatter;
  final bool withValidate;
  final bool withOnTapOutSide;
  final bool isUnderLine;
  final bool noBorder;
  final double? borderRadius;
  final String? prefixIconPath;
  final String? suffixIconPath;
  final Color? borderColor;
  final Color? fillColor;
  final int? maxLines;
  final double? verticalPadding;
  final double? horizontalPadding;
  final String? Function(String? value)? validator;
  final String? labelText;
  final TextAlign? textAlign;
  final Widget? prefixIcon;
  final bool readOnly;
  final TextStyle? hintStyle;
  final TextStyle? titleStyle;
  final double? prefixIconSize;
  final double? height;
  final TextStyle? textStyle;
  final bool withRemove;
  final Function()? onRemove;
  final TextDirection? textDirection;
  final TextDirection? hintTextDirection;
  final bool forceBorderColor;
  final AlignmentGeometry? titleTextAlign;
  final bool withElevation;

  const DefaultFormField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.hintText,
    this.enabled,
    this.onTap,
    this.disableHelperText = true,
    this.redText,
    this.onChanged,
    this.inLeft,
    this.maxLength,
    this.focusNode,
    this.autofocus = false,
    this.withInputFormatter = false,
    this.withValidate = true,
    this.withOnTapOutSide = false,
    this.borderRadius,
    this.prefixIconPath,
    this.suffixIconPath,
    this.isUnderLine = false,
    this.borderColor,
    this.fillColor,
    this.maxLines,
    this.verticalPadding,
    this.validator,
    this.noBorder = false,
    this.title,
    this.labelText,
    this.hintWidget,
    this.textAlign,
    this.prefixIcon,
    this.readOnly = false,
    this.hintStyle,
    this.prefixIconSize,
    this.height,
    this.titleStyle,
    this.horizontalPadding,
    this.textStyle,
    this.withRemove = false,
    this.onRemove,
    this.textDirection,
    this.hintTextDirection,
    this.forceBorderColor = false,
    this.titleTextAlign,
    this.withElevation = false,
  });

  @override
  State<DefaultFormField> createState() => _DefaultFormFieldState();
}

class _DefaultFormFieldState extends State<DefaultFormField> {
  FocusNode _focusNode = FocusNode();
  bool _isVisible = false;
  Color? _prefixColor;
  void Function(void Function())? _prefixSetState;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    }
    _isVisible = widget.obscureText;
    if (widget.controller.text.isNotEmpty) {
      _prefixColor = ColorManager.primary;
    }
    _focusNode.addListener(() {
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_focusNode.hasFocus || widget.controller.text.isNotEmpty) {
          _prefixColor = ColorManager.primary;
        } else {
          _prefixColor = ColorManager.grey;
        }
        if (_prefixSetState != null) _prefixSetState!(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null)
          Align(
            alignment:
                widget.titleTextAlign ?? AlignmentDirectional.centerStart,
            child: Text(
              widget.title!,
              style:
                  widget.titleStyle ??
                  getRegularStyle(fontSize: 13.sp, color: ColorManager.black),
            ),
          ),
        if (widget.title != null) SizedBox(height: 8.h),
        Directionality(
          textDirection:
              widget.textDirection ??
              (language == "en" ? TextDirection.ltr : TextDirection.rtl),
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              boxShadow: [
                if (widget.withElevation)
                  BoxShadow(
                    color: ColorManager.greyBorder.withValues(alpha: 0.3),
                    blurRadius: 5.r,
                    spreadRadius: 3.r,
                  ),
              ],
            ),
            child: TextFormField(
              readOnly: widget.readOnly,
              textAlign:
                  widget.textAlign ??
                  (language == 'en' ? TextAlign.left : TextAlign.right),
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              enableInteractiveSelection: !widget.readOnly,
              maxLengthEnforcement:
                  MaxLengthEnforcement.truncateAfterCompositionEnds,
              maxLength: widget.maxLength,
              onTap: widget.onTap,
              enabled: widget.enabled,
              keyboardType: widget.keyboardType,
              controller: widget.controller,
              onChanged: (value) {
                if (widget.onChanged != null) widget.onChanged!(value);
                if ((value.isNotEmpty && value.length == 1) || value.isEmpty) {
                  setState(() {});
                }
              },
              textDirection:
                  widget.inLeft ??
                      instance<AppPreferences>().getAppLanguage() == "en"
                  ? ui.TextDirection.ltr
                  : ui.TextDirection.rtl,
              maxLines: _isVisible ? 1 : widget.maxLines,
              inputFormatters: widget.withInputFormatter
                  ? [
                      LengthLimitingTextInputFormatter(widget.maxLength),
                      FilteringTextInputFormatter.digitsOnly,
                    ]
                  : null,
              style:
                  widget.textStyle ??
                  getRegularStyle(fontSize: 12.sp, color: ColorManager.black),
              validator: !widget.withValidate
                  ? null
                  : widget.validator ??
                        (value) {
                          if (value?.isEmpty ?? false) {
                            return widget.redText ??
                                AppStrings.textFieldError.tr();
                          }
                          return null;
                        },
              obscureText: _isVisible,
              selectionHeightStyle: ui.BoxHeightStyle.includeLineSpacingMiddle,
              onTapOutside: (event) {
                _focusNode.unfocus();
                _prefixColor = null;
                if (_prefixSetState != null) _prefixSetState!(() {});
              },
              decoration: InputDecoration(
                counterStyle: getBoldStyle(
                  fontSize: 12.sp,
                  color: ColorManager.black,
                ),
                labelText: widget.labelText,
                labelStyle: TextStyle(
                  color: ColorManager.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: widget.verticalPadding ?? 5.h,
                  horizontal: widget.horizontalPadding ?? 10.w,
                ),
                filled: true,
                fillColor: widget.fillColor,
                helperText: widget.disableHelperText ? null : '',
                errorStyle: getRegularStyle(
                  fontSize: 12.sp,
                  color: ColorManager.red,
                ),
                prefixIcon: widget.prefixIconPath != null
                    ? Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: 10.w,
                          end: 8.w,
                        ),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            _prefixSetState = setState;
                            return SvgPicture.asset(
                              widget.prefixIconPath ?? '',
                              color: widget.prefixIconPath != IconAssets.search
                                  ? null
                                  : _prefixColor,
                              fit: BoxFit.none,
                            );
                          },
                        ),
                      )
                    : widget.prefixIcon,
                prefixIconConstraints: BoxConstraints(minWidth: 30.w),
                suffixIcon: widget.obscureText
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                        icon: Icon(
                          _isVisible ? Icons.visibility : Icons.visibility_off,
                          color: ColorManager.textColor,
                        ),
                      )
                    : widget.suffixIconPath != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: SvgPicture.asset(
                          widget.suffixIconPath!,
                          width: 20.w,
                          height: 20.w,
                          fit: BoxFit.contain,
                        ),
                      )
                    : widget.controller.text.isNotEmpty && widget.withRemove
                    ? InkWell(
                        onTap: () {
                          widget.controller.clear();
                          if (widget.onRemove != null) widget.onRemove!.call();
                          if (widget.onChanged != null)
                            widget.onChanged!.call('');
                          setState(() {});
                        },
                        child: Icon(
                          Icons.close_rounded,
                          size: 22.r,
                          color: ColorManager.grey,
                        ),
                      )
                    : widget.suffixIcon,
                hintText: widget.hintText,
                hintTextDirection:
                    widget.hintTextDirection ??
                    (language == "en" ? TextDirection.ltr : TextDirection.rtl),
                hintStyle:
                    widget.hintStyle ??
                    getRegularStyle(fontSize: 12.sp, color: ColorManager.grey),
                focusedBorder: widget.noBorder
                    ? InputBorder.none
                    : widget.isUnderLine
                    ? UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.borderColor ?? ColorManager.primary,
                        ),
                      )
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius ?? 8.r,
                        ),
                        borderSide: BorderSide(color: _getBorderColor()),
                      ),
                enabledBorder: widget.noBorder
                    ? InputBorder.none
                    : widget.isUnderLine
                    ? UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.borderColor ?? ColorManager.primary,
                        ),
                      )
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius ?? 8.r,
                        ),
                        borderSide: BorderSide(color: _getBorderColor()),
                      ),
                errorBorder: widget.noBorder
                    ? InputBorder.none
                    : widget.isUnderLine
                    ? UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.borderColor ?? ColorManager.red,
                        ),
                      )
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius ?? 8.r,
                        ),
                        borderSide: BorderSide(color: ColorManager.red),
                      ),
                focusedErrorBorder: widget.noBorder
                    ? InputBorder.none
                    : widget.isUnderLine
                    ? UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.borderColor ?? ColorManager.red,
                        ),
                      )
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius ?? 8.r,
                        ),
                        borderSide: const BorderSide(color: ColorManager.red),
                      ),
                disabledBorder: widget.noBorder
                    ? InputBorder.none
                    : widget.isUnderLine
                    ? UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.borderColor ?? ColorManager.grey,
                        ),
                      )
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius ?? 8.r,
                        ),
                        borderSide: BorderSide(
                          color: widget.borderColor ?? ColorManager.grey,
                        ),
                      ),
              ),
            ),
          ),
        ),
        if (widget.hintWidget != null) SizedBox(height: 5.h),
        if (widget.hintWidget != null) widget.hintWidget!,
      ],
    );
  }

  Color _getBorderColor() {
    if (widget.forceBorderColor && widget.borderColor != null) {
      return widget.borderColor!;
    }
    if (_focusNode.hasFocus) {
      return ColorManager.primary;
    } else if (widget.controller.text.isNotEmpty) {
      return ColorManager.primary.withValues(alpha: .5);
    } else {
      return widget.borderColor ?? ColorManager.greyBorder;
    }
  }
}
