import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:base_project/common/resources/strings_manager.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.termsAndConditions.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          AppStrings.termsAndConditions.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
