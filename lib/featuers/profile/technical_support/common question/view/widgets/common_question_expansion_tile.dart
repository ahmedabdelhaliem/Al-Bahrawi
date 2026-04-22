import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonQuestionExpansionTile extends StatefulWidget {
  final String question;
  final String answer;

  const CommonQuestionExpansionTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<CommonQuestionExpansionTile> createState() =>
      _CommonQuestionExpansionTileState();
}

class _CommonQuestionExpansionTileState
    extends State<CommonQuestionExpansionTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          // ── Question pill ──────────────────────────────────────────
          GestureDetector(
            onTap: _toggle,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(color: ColorManager.greyBorder),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.black.withValues(alpha: 0.04),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Arrow on the left (RTL layout: visually left = start)

                  // Question text on the right
                  Text(
                    widget.question,
                    textDirection: TextDirection.rtl,
                    style: getMediumStyle(
                      fontSize: 16.sp,
                      color: ColorManager.textColor,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: _isExpanded
                          ? ColorManager.primary
                          : ColorManager.greyText,
                      size: 22.r,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Answer box (animated) ──────────────────────────────────
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
              padding: EdgeInsets.all(16.w),
              constraints: BoxConstraints(minHeight: 120.h),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: ColorManager.greyBorder),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.black.withValues(alpha: 0.04),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.topRight,
              child: Text(
                widget.answer,
                textDirection: TextDirection.rtl,
                style: getRegularStyle(
                  fontSize: 14.sp,
                  color: ColorManager.greyText,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
