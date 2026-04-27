import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:base_project/common/resources/strings_manager.dart';

class TechnicalSupportView extends StatelessWidget {
  const TechnicalSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.technicalSupport.tr()),
      ),
      body: Center(
        child: Text(AppStrings.technicalSupport.tr()),
      ),
    );
  }
}
