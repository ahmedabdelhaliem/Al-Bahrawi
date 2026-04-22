import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:base_project/common/widgets/default_form_field.dart';
import 'package:base_project/common/widgets/default_app_bar.dart';

class SignUpLocationView extends StatefulWidget {
  const SignUpLocationView({super.key});

  @override
  State<SignUpLocationView> createState() => _SignUpLocationViewState();
}

class _SignUpLocationViewState extends State<SignUpLocationView> {
  final TextEditingController _workLocationController = TextEditingController();
  final TextEditingController _addressDetailController = TextEditingController();

  @override
  void dispose() {
    _workLocationController.dispose();
    _addressDetailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: const DefaultAppBar(height: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 24.h),
            _buildMapIllustration(),
            SizedBox(height: 24.h),
            Text(
              "اختر موقعك",
              style: getBoldStyle(
                fontSize: 22.sp,
                color: ColorManager.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              "انتقل الموقع الخاص بك للبقاء على اطلاع بما يحدث في منطقتك",
              style: getRegularStyle(
                fontSize: 13.sp,
                color: ColorManager.greyTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            DefaultFormField(
              controller: _workLocationController,
              borderColor: ColorManager.greyBorder,
              hintText: AppStrings.workPlace.tr(),
              title: AppStrings.workPlace.tr(),
              // suffixIcon: Icon(Icons.keyboard_arrow_down, color: ColorManager.grey),
            ),
            SizedBox(height: 16.h),
            DefaultFormField(
              controller: _addressDetailController,
              borderColor: ColorManager.greyBorder,
              hintText: AppStrings.residentialArea.tr(),
              title: AppStrings.residentialArea.tr(),
            ),
            SizedBox(height: 48.h),
            DefaultButtonWidget(
              onPressed: () {
                // In a real flow, this would submit registration
                context.go(AppRouters.signupSuccess);
              },
              text: AppStrings.next.tr(),
              gradient: ColorManager.primaryGradient,
              textColor: ColorManager.white,
              radius: 40.r,
              verticalPadding: 14.h,
            ),
            SizedBox(height: 16.h),
            _loginWidget(),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _loginWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "هل لديك حساب بالفعل؟",
          style: getRegularStyle(fontSize: 13.sp, color: ColorManager.textColor),
        ),
        SizedBox(width: 4.w),
        InkWell(
          onTap: () => context.pop(),
          child: Text(
            "تسجيل الدخول",
            style: getBoldStyle(fontSize: 13.sp, color: ColorManager.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildMapIllustration() {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManager.fillColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simplified Map placeholder logic (Image 2 style)
          Icon(Icons.map_outlined, size: 100.w, color: ColorManager.primary.withValues(alpha: 0.2)),
          Positioned(
             top: 40.h,
             child: Container(
               padding: EdgeInsets.all(8.w),
               decoration: BoxDecoration(
                 color: ColorManager.white,
                 shape: BoxShape.circle,
                 boxShadow: [
                   BoxShadow(
                     color: Colors.black.withValues(alpha: 0.1),
                     blurRadius: 10.r,
                     offset: const Offset(0, 5),
                   )
                 ]
               ),
               child: Icon(Icons.location_on, color: ColorManager.primary, size: 40.w),
             ),
          ),
        ],
      ),
    );
  }
}
