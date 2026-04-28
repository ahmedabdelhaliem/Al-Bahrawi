import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';

class CommonQuestionView extends StatelessWidget {
  const CommonQuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.faqs.tr()),
      ),
      body: Center(
        child: Text(AppStrings.faqs.tr()),
      ),
    );
  }
}
