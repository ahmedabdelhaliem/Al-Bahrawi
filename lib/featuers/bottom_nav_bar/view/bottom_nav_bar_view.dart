import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:base_project/app/app_functions.dart';
import 'package:base_project/app/app_prefs.dart';
import 'package:base_project/app/di.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/values_manager.dart';
import 'package:base_project/featuers/auth/signup/models/signup_model.dart';
import 'package:base_project/featuers/home/view/home_view.dart';
import 'package:base_project/featuers/profile/main%20profile/view/profile_view.dart';

class BottomNavBarView extends StatefulWidget {
  final int pageIndex;
  final bool showSuccessDialog;
  const BottomNavBarView({
    super.key,
    this.pageIndex = 0,
    this.showSuccessDialog = false,
  });

  @override
  State<BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<BottomNavBarView> {
  int _selectedIndex = 0;
  final List<Widget> _views = <Widget>[
    const HomeView(),
    const HomeView(),
    const HomeView(),
    const ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    if (instance<AppPreferences>().getToken().isNotEmpty) {
      if (userRole == UserRole.captain) {
        FirebaseMessaging.instance.subscribeToTopic("sellers");
      } else {
        FirebaseMessaging.instance.subscribeToTopic("buyers");
      }
    }
    _selectedIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _views[_selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: ColorManager.greyBorder)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08))],
        ),
        child: BottomNavigationBar(
          backgroundColor: ColorManager.white,
          elevation: 4,
          currentIndex: _selectedIndex,
          onTap: (index) {
            if ((index == 2 || (index == 1 && userRole == UserRole.captain)) &&
                instance<AppPreferences>().getToken().isEmpty) {
              AppFunctions.showsToast(
                AppStrings.loginFirst.tr(),
                ColorManager.red,
                context,
              );
              context.push(AppRouters.login, extra: {"pageIndex": index});
              return;
            }
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
          selectedLabelStyle: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                IconAssets.home,
                width: 20.w,
                height: 20.h,
                color: ColorManager.greyTextColor,
              ),
              activeIcon: SvgPicture.asset(
                IconAssets.home,
                width: 20.w,
                height: 20.h,
                color: ColorManager.primary,
              ),
              label: AppStrings.home.tr(),
            ),
            if (userRole == UserRole.passenger)
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  IconAssets.brands,
                  width: 20.w,
                  height: 20.h,
                  color: ColorManager.greyTextColor,
                ),
                activeIcon: SvgPicture.asset(
                  IconAssets.brands,
                  width: 20.w,
                  height: 20.h,
                  color: ColorManager.primary,
                ),
                label: AppStrings.brands.tr(),
              ),
            if (userRole == UserRole.passenger)
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  IconAssets.auctions,
                  width: 20.w,
                  height: 20.h,
                  color: ColorManager.greyTextColor,
                ),
                activeIcon: SvgPicture.asset(
                  IconAssets.auctions,
                  width: 20.w,
                  height: 20.h,
                  color: ColorManager.primary,
                ),
                label: AppStrings.myAuctions.tr(),
              ),
            if (userRole == UserRole.captain)
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  IconAssets.add,
                  width: 20.w,
                  height: 20.h,
                  color: ColorManager.greyTextColor,
                ),
                activeIcon: SvgPicture.asset(
                  IconAssets.add,
                  width: 20.w,
                  height: 20.h,
                  color: ColorManager.primary,
                ),
                label: AppStrings.addAnnouncement.tr(),
              ),
            if (userRole == UserRole.captain)
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  IconAssets.myAuctions,
                  width: 18.w,
                  height: 18.h,
                  color: ColorManager.greyTextColor,
                ),
                activeIcon: SvgPicture.asset(
                  IconAssets.myAuctions,
                  width: 18.w,
                  height: 18.h,
                  color: ColorManager.primary,
                ),
                label: AppStrings.myAnnouncements.tr(),
              ),

            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                IconAssets.profile,
                width: 20.w,
                height: 20.h,
                color: ColorManager.greyTextColor,
              ),
              activeIcon: SvgPicture.asset(
                IconAssets.profile,
                width: 20.w,
                height: 20.h,
                color: ColorManager.primary,
              ),
              label: AppStrings.profile.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
