import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import '../model/profile_model.dart';

class ProfileData {
  static List<ProfileModel> profileItems = [
    ProfileModel(
      icon: Iconsax.user,
      title: AppStrings.myAccount,
      route: AppRouters.myAccount,
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
      icon: Icons.headset_mic_rounded,
      title: AppStrings.technicalSupport,
      route: AppRouters.technicalSupport,
    ),
  ];
}
