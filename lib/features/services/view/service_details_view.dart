import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';

class ServiceDetailsView extends StatelessWidget {
  const ServiceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 24.h),
                      // About Service Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: ColorManager.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.5), width: 0.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              AppStrings.aboutService.tr(),
                              style: getBoldStyle(color: ColorManager.blue, fontSize: 16.sp),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              AppStrings.taxPlanningDesc.tr(),
                              style: getRegularStyle(color: ColorManager.greyText, fontSize: 14.sp),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Benefits List
                      _buildBenefitItem(
                        AppStrings.taxReduction.tr(),
                        AppStrings.taxReductionDesc.tr(),
                        Icons.trending_down,
                      ),
                      _buildBenefitItem(
                        AppStrings.avoidFines.tr(),
                        AppStrings.avoidFinesDesc.tr(),
                        Icons.gavel,
                      ),
                      _buildBenefitItem(
                        AppStrings.periodicReports.tr(),
                        AppStrings.periodicReportsDesc.tr(),
                        Icons.analytics_outlined,
                      ),
                      SizedBox(height: 24.h),
                      // Footer Stats
                      Center(
                        child: Text(
                          AppStrings.taxFilesProcessed.tr(),
                          style: getRegularStyle(color: ColorManager.grey, fontSize: 11.sp),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 120.h), // Extra space to scroll past the floating button
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomAction(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
      child: DefaultButtonWidget(
        text: AppStrings.bookNow.tr(),
        onPressed: () => context.push(AppRouters.requestConsultation),
        color: ColorManager.blue,
        textColor: ColorManager.white,
        height: 55.h,
        radius: 16.r,
        isIcon: true,
        iconBuilder: Icon(Icons.calendar_today_outlined, color: ColorManager.gold, size: 18.w),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 55.h, bottom: 40.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.blue, ColorManager.primary.withValues(alpha: 0.7)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: ColorManager.white),
                onPressed: () => Navigator.pop(context),
              ),
              // Tag
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ColorManager.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: ColorManager.gold.withValues(alpha: 0.5), width: 1),
                ),
                child: Text(
                  AppStrings.taxConsultation.tr(),
                  style: getMediumStyle(color: ColorManager.gold, fontSize: 10.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            AppStrings.taxPlanning.tr(),
            style: getBoldStyle(color: ColorManager.white, fontSize: 26.sp),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                AppStrings.certifiedService.tr(),
                style: getRegularStyle(color: ColorManager.white.withValues(alpha: 0.8), fontSize: 12.sp),
              ),
              SizedBox(width: 6.w),
              Icon(Icons.verified, color: ColorManager.gold, size: 16.w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String title, String desc, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.5), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.arrow_back_ios, color: ColorManager.grey.withValues(alpha: 0.5), size: 12.w),
          const Spacer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: getBoldStyle(color: ColorManager.blue, fontSize: 14.sp),
                ),
                SizedBox(height: 2.h),
                Text(
                  desc,
                  style: getRegularStyle(color: ColorManager.grey, fontSize: 11.sp),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: ColorManager.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ColorManager.gold.withValues(alpha: 0.3), width: 1),
            ),
            child: Icon(icon, color: ColorManager.blue, size: 20.w),
          ),
        ],
      ),
    );
  }
}
