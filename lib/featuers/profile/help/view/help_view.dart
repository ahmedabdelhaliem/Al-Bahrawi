import 'package:base_project/common/helper/spacer.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/custom_app_bar.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:base_project/common/widgets/default_form_field.dart';
import 'package:base_project/featuers/profile/help/view/widgets/contact_info_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpView extends StatefulWidget {
  const HelpView({super.key});

  @override
  State<HelpView> createState() => _HelpViewState();
}

class _HelpViewState extends State<HelpView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: CustomAppBar(title: AppStrings.helpCenter.tr()),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            sliver: const SliverToBoxAdapter(child: ContactInfoCard()),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                DefaultFormField(
                  controller: nameController,
                  hintText: AppStrings.yourName.tr(),
                  borderRadius: 30.r,
                  fillColor: ColorManager.white,
                  verticalPadding: 16.h,
                ),
                verticalSpace(16),
                DefaultFormField(
                  controller: emailController,
                  hintText: AppStrings.yourEmail.tr(),
                  borderRadius: 30.r,
                  fillColor: ColorManager.white,
                  verticalPadding: 16.h,
                ),
                verticalSpace(16),
                DefaultFormField(
                  controller: phoneController,
                  hintText: AppStrings.yourPhone.tr(),
                  borderRadius: 30.r,
                  fillColor: ColorManager.white,
                  verticalPadding: 16.h,
                ),
                verticalSpace(16),
                DefaultFormField(
                  controller: messageController,
                  hintText: AppStrings.yourMessage.tr(),
                  borderRadius: 30.r,
                  fillColor: ColorManager.white,
                  maxLines: 5,
                  verticalPadding: 16.h,
                ),
                verticalSpace(32),
                DefaultButtonWidget(
                  // text: AppStrings.send.tr(),
                  onPressed: () {
                    // Handle contact form submission
                  },
                  radius: 30.r,
                  color: ColorManager.primary,
                  textColor: ColorManager.white,
                  height: 56.h,
                  child: Center(
                    child: Text(
                      AppStrings.send.tr(),
                      style: getMediumStyle(
                        fontSize: 14,
                        color: ColorManager.white,
                      ),
                    ),
                  ),
                ),
                verticalSpace(40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
