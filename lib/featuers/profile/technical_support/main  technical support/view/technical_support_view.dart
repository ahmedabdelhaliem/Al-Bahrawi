import 'package:base_project/common/helper/spacer.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/widgets/custom_app_bar.dart';
import 'package:base_project/featuers/profile/technical_support/main%20%20technical%20support/view/widgets/support_action_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TechnicalSupportView extends StatelessWidget {
  const TechnicalSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppStrings.technicalSupport.tr()),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          children: [
            SupportActionButton(
              title: AppStrings.contactWhatsApp.tr(),
              iconPath: IconAssets.whatsapp,
              isWhatsApp: true,
              onTap: () {
                // Handle WhatsApp
              },
            ),
            verticalSpace(20),
            SupportActionButton(
              title: AppStrings.faqs.tr(),
              iconPath: IconAssets.faqs,
              onTap: () {
                context.push(AppRouters.commonQuestion);
                // Handle FAQs
              },
            ),
            verticalSpace(20),
            SupportActionButton(
              title: AppStrings.chatWithUs.tr(),
              iconPath: IconAssets.message,
              onTap: () {
                // Handle Chat
              },
            ),
            verticalSpace(20),
            SupportActionButton(
              title: AppStrings.writeSuggestion.tr(),
              iconPath: IconAssets.writeSuggest,
              onTap: () {
                // Handle Suggestion
              },
            ),
          ],
        ),
      ),
    );
  }
}
