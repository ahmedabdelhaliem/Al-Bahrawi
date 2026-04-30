import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';

class LawyerDashboardView extends StatelessWidget {
  const LawyerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            
            SizedBox(height: 20.h),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                AppStrings.casesRecord.tr(),
                style: getBoldStyle(
                  color: ColorManager.blue,
                  fontSize: 24.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            SizedBox(height: 20.h),
            
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                itemCount: 4, // Dummy count
                itemBuilder: (context, index) {
                  return _buildCaseCard(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile & Tags
          Row(
            children: [
              // Avatar
              Stack(
                alignment: Alignment.bottomRight, // Bottom left in RTL
                children: [
                  Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorManager.lightBlueSky, width: 3),
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https://ui-avatars.com/api/?name=Sayed+Galal&background=0D8ABC&color=fff&size=150'), // Placeholder
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: ColorManager.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.verified, color: ColorManager.primary, size: 16.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              // Tags
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTag('${AppStrings.lawyer.tr()} : سيد جلال'),
                  SizedBox(height: 8.h),
                  _buildTag(AppStrings.cases.tr()),
                ],
              ),
            ],
          ),
          
          // Checkout Button
          DefaultButtonWidget(
            onPressed: () {
              GoRouter.of(context).push(AppRouters.lawyerCheckout);
            },
            text: AppStrings.checkout.tr(),
            color: ColorManager.primary,
            height: 35.h,
            width: 80.w,
            radius: 20.r,
            textStyle: getBoldStyle(color: ColorManager.white, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorManager.successGreen.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: getBoldStyle(
          color: ColorManager.successGreen,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _buildCaseCard(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.fillColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppStrings.caseName.tr()} ${index + 1}',
                style: getRegularStyle(
                  color: ColorManager.blackText,
                  fontSize: 14.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: ColorManager.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.grid_view_rounded,
                  color: ColorManager.primary,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          // Dummy description lines
          _buildDummyLine(0.8),
          _buildDummyLine(0.9),
          _buildDummyLine(0.7),
          _buildDummyLine(0.85),
          _buildDummyLine(0.6),
          
          SizedBox(height: 16.h),
          
          Row(
            children: [
              Expanded(
                child: DefaultButtonWidget(
                  onPressed: () {
                    // Navigate to chat
                    GoRouter.of(context).push(AppRouters.chatView, extra: {
                      'chatId': index + 1,
                      'supplierName': 'عميل القضية ${index + 1}',
                    });
                  },
                  text: AppStrings.chat.tr(),
                  color: ColorManager.primary,
                  height: 40.h,
                  radius: 20.r,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: DefaultButtonWidget(
                  onPressed: () {
                    // Call logic
                  },
                  text: AppStrings.call.tr(),
                  color: ColorManager.primary,
                  height: 40.h,
                  radius: 20.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDummyLine(double widthFactor) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      height: 4.h,
      width: ScreenUtil().screenWidth * widthFactor * 0.7,
      decoration: BoxDecoration(
        color: ColorManager.greyTextColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}
