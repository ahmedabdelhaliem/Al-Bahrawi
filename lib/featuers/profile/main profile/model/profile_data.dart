import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/featuers/profile/main%20profile/model/profile_model.dart';

class ProfileData {
  static List<ProfileModel> profileItems = [
    ProfileModel(
      icon: IconAssets.userInformation,
      title: AppStrings.userInformation,
      route: AppRouters.userInformation,
    ),
    ProfileModel(
      icon: IconAssets.file,
      title: AppStrings.tripsLog,
      route: AppRouters.tripsLog,
    ),
    ProfileModel(
      icon: IconAssets.notification,
      title: AppStrings.notifications,
      route: AppRouters.notifications,
    ),
    ProfileModel(
      icon: IconAssets.safty,
      title: AppStrings.termsAndConditions,
      route: AppRouters.termsAndConditions,
    ),
    ProfileModel(
      icon: IconAssets.settings,
      title: AppStrings.settings,
      route: AppRouters.settings,
    ),
    ProfileModel(
      icon: IconAssets.question,
      title: AppStrings.help,
      route: AppRouters.help,
    ),
    ProfileModel(
      icon: IconAssets.wallet,
      title: AppStrings.wallet,
      route: AppRouters.wallet,
    ),
    ProfileModel(
      icon: IconAssets.info,
      title: AppStrings.technicalSupport,
      route: AppRouters.technicalSupport,
    ),
    ProfileModel(
      icon: IconAssets.info,
      title: AppStrings.switchToAdmin,
      route: AppRouters.switchToAdmin,
    ),
  ];
}
