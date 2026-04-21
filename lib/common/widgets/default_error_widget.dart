import 'package:easy_localization/easy_localization.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';


class DefaultErrorWidget extends StatelessWidget {
  final String errorMessage;
  final String? buttonTitle;
  final void Function()? onPressed;
  final bool applyTopHeight;
  const DefaultErrorWidget({super.key, required this.errorMessage, this.onPressed, this.buttonTitle, this.applyTopHeight = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(applyTopHeight)
          SizedBox(height: MediaQuery.sizeOf(context).height*.1,),
          Lottie.asset(JsonAssets.error, height: 80.h),
          SizedBox(height: 15.h,),
          Text(
            errorMessage,
            style: getBoldStyle(fontSize: 13.sp, color: ColorManager.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h,),
          if(onPressed != null)
          DefaultButtonWidget(
            text: buttonTitle??AppStrings.tryAgain.tr(),
            color: ColorManager.greyButtonColor,
            onPressed: onPressed,
            textColor: ColorManager.white,
            elevation: 1,
            horizontalPadding: 70.w,
            isExpanded: false,
            verticalPadding: 8.h,
            fontSize: 12.sp,
          )
        ],
      ),
    );
  }
}
