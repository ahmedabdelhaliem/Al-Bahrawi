import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/featuers/my_trips/view/my_trips_view.dart';
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
  late PageController _pageController;

  final List<Widget> _views = <Widget>[
    const HomeView(),
    const MyTripsView(),
    const ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
    _pageController = PageController(initialPage: _selectedIndex);

    if (instance<AppPreferences>().getToken().isNotEmpty) {
      if (userRole == UserRole.captain) {
        FirebaseMessaging.instance.subscribeToTopic("sellers");
      } else {
        FirebaseMessaging.instance.subscribeToTopic("buyers");
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    // Access allowed to all tabs without login for now
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: _views,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h),
          child: Container(
            height: 65.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.grid_view_rounded, AppStrings.home.tr()),
                _buildNavItem(1, Icons.confirmation_number_rounded, AppStrings.myTrips.tr()),
                _buildNavItem(2, Icons.person_rounded, AppStrings.profile.tr()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: isSelected ? ColorManager.primaryGradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : ColorManager.grey,
              size: 24.r,
            ),
            if (isSelected) ...[
              SizedBox(width: 8.w),
              Text(
                label,
                style: getBoldStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


