import '../../../../../common/helper/spacer.dart';
import '../../../../../common/resources/app_router.dart';
import '../../../../../common/resources/strings_manager.dart';
import '../../../../../common/widgets/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'widgets/support_action_button.dart';

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
              icon: Icons.chat_bubble_outline_rounded,
              onTap: () {
                // Handle WhatsApp
              },
            ),
            verticalSpace(20),
            SupportActionButton(
              title: AppStrings.faqs.tr(),
              icon: Icons.help_outline_rounded,
              onTap: () {
                context.push(AppRouters.commonQuestion);
              },
            ),
            verticalSpace(20),
            SupportActionButton(
              title: AppStrings.chatWithUs.tr(),
              icon: Icons.chat_bubble_outline_rounded,
              onTap: () {
                // Handle Chat
              },
            ),
            verticalSpace(20),
            SupportActionButton(
              title: AppStrings.writeSuggestion.tr(),
              icon: Icons.list_alt_rounded,
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
