import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:base_project/common/resources/strings_manager.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.home.tr()),
      ),
      body: Center(
        child: Text(AppStrings.welcome.tr()),
      ),
    );
  }
}
