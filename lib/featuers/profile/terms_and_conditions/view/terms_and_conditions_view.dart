import 'package:base_project/common/helper/spacer.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/custom_app_bar.dart';
import 'package:base_project/featuers/profile/terms_and_conditions/view/widgets/bullet_point.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: CustomAppBar(title: AppStrings.termsAndConditions.tr()),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(24.h),
                  _buildSectionTitle(AppStrings.termsOfUse.tr()),
                  verticalSpace(12),
                  _buildSectionBody(AppStrings.termsOfUseContent.tr()),
                  verticalSpace(32),

                  _buildSectionTitle(AppStrings.agreementToTerms.tr()),
                  verticalSpace(16),
                  BulletPoint(content: AppStrings.agreementToTermsBullet1.tr()),
                  verticalSpace(12),
                  BulletPoint(content: AppStrings.agreementToTermsBullet2.tr()),
                  verticalSpace(32),

                  _buildSectionTitle(AppStrings.userConduct.tr()),
                  verticalSpace(16),
                  BulletPoint(content: AppStrings.userConductBullet1.tr()),
                  verticalSpace(12),
                  BulletPoint(content: AppStrings.userConductBullet2.tr()),
                  verticalSpace(12),
                  BulletPoint(content: AppStrings.userConductBullet3.tr()),

                  verticalSpace(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: getBoldStyle(fontSize: 18.sp, color: ColorManager.black),
    );
  }

  Widget _buildSectionBody(String content) {
    return Text(
      content,
      style: getRegularStyle(
        fontSize: 14.sp,
        color: ColorManager.black.withValues(alpha: 0.8),
        height: 1.5,
      ),
    );
  }
}
