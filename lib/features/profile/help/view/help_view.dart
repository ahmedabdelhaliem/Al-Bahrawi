import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.help.tr()),
      ),
      body: Center(
        child: Text(AppStrings.help.tr()),
      ),
    );
  }
}
