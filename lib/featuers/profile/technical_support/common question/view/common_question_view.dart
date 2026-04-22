import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/widgets/custom_app_bar.dart';
import 'package:base_project/featuers/profile/technical_support/common%20question/view/widgets/common_question_expansion_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonQuestionView extends StatelessWidget {
  const CommonQuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppStrings.faqsTitle.tr()),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CommonQuestionExpansionTile(
              question: AppStrings.faqQuestion1.tr(),
              answer: AppStrings.faqAnswer1.tr(),
            ),
          );
        },
      ),
    );
  }
}
