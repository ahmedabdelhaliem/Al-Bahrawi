import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/featuers/on_boarding/model/on_boarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingWidget extends StatefulWidget {
  final OnBoardingItemModel item;
  const OnBoardingWidget({super.key, required this.item});

  @override
  State<OnBoardingWidget> createState() => _OnBoardingWidgetState();
}

class _OnBoardingWidgetState extends State<OnBoardingWidget> {
  @override
  Widget build(BuildContext context) {
    final String imagePath = widget.item.image ?? '';

    Widget imageWidget;
    if (imagePath.isEmpty) {
      imageWidget = const SizedBox.shrink();
    } else if (imagePath.startsWith('http')) {
      imageWidget = Image.network(
        imagePath,
        fit: BoxFit.contain,
      );
    } else {
      imageWidget = Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Image.asset(
          ImageAssets.logo,
          fit: BoxFit.contain,
        ),
      );
    }

    return Column(
      children: [
        // Spacer to push content down past the 0.35.sh wavy header
        const Spacer(flex: 7), 
        
        // Logo Section
        Flexible(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: imageWidget,
          ),
        ),
        
        SizedBox(height: 0.02.sh), // Small relative gap
        
        // Text Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.item.title != null && widget.item.title!.isNotEmpty) ...[
                Text(
                  widget.item.title!,
                  style: getBoldStyle(fontSize: 22.sp, color: ColorManager.textColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 0.01.sh),
              ],
              Text(
                widget.item.description ?? '',
                style: getMediumStyle(fontSize: 15.sp, color: ColorManager.greyTextColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        // Bottom Spacer to anchor content near the buttons
        SizedBox(height: 0.1.sh), 
      ],
    );
  }
}
