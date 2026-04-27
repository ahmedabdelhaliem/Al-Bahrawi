import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:base_project/common/resources/strings_manager.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.notifications.tr()),
      ),
      body: const Center(
        child: Icon(Icons.notifications_none, size: 100, color: Colors.grey),
      ),
    );
  }
}
