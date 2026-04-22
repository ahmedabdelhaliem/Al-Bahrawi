import '../../../../../../common/resources/color_manager.dart';
import '../../../../../../common/resources/styles_manager.dart';
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
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        children: [
          // ── Question pill ──────────────────────────────────────────
          GestureDetector(
            onTap: _toggle,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Chevron Icon on the left
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: ColorManager.primary,
                    size: 24.r,
                  ),
                  // Question text on the right
                  Expanded(
                    child: Text(
                      widget.question,
                      textAlign: TextAlign.end,
                      style: getMediumStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFFB0BEC5), // Light grey text like image
                      ),
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
              margin: EdgeInsets.only(top: 4.h),
              padding: EdgeInsets.all(16.w),
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.5)),
              ),
              child: Text(
                widget.answer,
                textAlign: TextAlign.end,
                style: getRegularStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFFB0BEC5), // Light grey text like image
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
