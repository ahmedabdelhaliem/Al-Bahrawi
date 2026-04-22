import 'package:flutter/material.dart';
import '../../../../common/resources/app_router.dart';
import '../../../../common/resources/strings_manager.dart';
import '../model/profile_model.dart';

class ProfileData {
  static List<ProfileModel> profileItems = [
    ProfileModel(
      icon: Icons.person_outline_rounded,
      title: AppStrings.userInformation,
      route: AppRouters.userInformation,
    ),
    ProfileModel(
      icon: Icons.history_rounded,
      title: AppStrings.tripsLog,
      route: AppRouters.tripsLog,
    ),
    ProfileModel(
      icon: Icons.notifications_none_rounded,
      title: AppStrings.notifications,
      route: AppRouters.notifications,
    ),
    ProfileModel(
      icon: Icons.description_outlined,
      title: AppStrings.termsAndConditions,
      route: AppRouters.termsAndConditions,
    ),
    ProfileModel(
      icon: Icons.help_outline_rounded,
      title: AppStrings.help,
      route: AppRouters.help,
    ),
    ProfileModel(
      icon: Icons.account_balance_wallet_outlined,
      title: AppStrings.wallet,
      route: AppRouters.wallet,
    ),
    ProfileModel(
      icon: Icons.headset_mic_rounded,
      title: AppStrings.technicalSupport,
      route: AppRouters.technicalSupport,
    ),
    ProfileModel(
      icon: Icons.admin_panel_settings_outlined,
      title: AppStrings.switchToAdmin,
      route: AppRouters.switchToAdmin,
    ),
  ];
}
