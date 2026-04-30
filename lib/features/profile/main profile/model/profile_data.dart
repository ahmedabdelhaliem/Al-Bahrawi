import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import '../model/profile_model.dart';

class ProfileData {
  static List<ProfileModel> profileItems = [
    ProfileModel(
      icon: Iconsax.user,
      title: AppStrings.myAccount,
      route: AppRouters.myAccount,
    ),
    ProfileModel(
      icon: Icons.assignment_outlined,
      title: AppStrings.myCases,
      route: AppRouters.myCases,
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
      icon: Icons.chat_bubble_outline_rounded,
      title: AppStrings.contactUs,
      route: AppRouters.contactUs,
    ),
    ProfileModel(
      icon: Icons.info_outline_rounded,
      title: AppStrings.aboutUs,
      route: AppRouters.aboutUs,
    ),
  ];
}
