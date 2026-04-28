import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/features/home/view/home_view.dart';
import 'package:al_bahrawi/features/services/view/services_view.dart';
import 'package:al_bahrawi/features/profile/main%20profile/view/profile_view.dart';

class BottomNavBarView extends StatefulWidget {
  final int pageIndex;
  const BottomNavBarView({
    super.key,
    this.pageIndex = 0,
  });

  @override
  State<BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<BottomNavBarView> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fadeController;

  final List<Widget> _views = <Widget>[
    const HomeView(),
    const ServicesView(),
    const ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _fadeController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: FadeTransition(
        opacity: _fadeController,
        child: IndexedStack(
          index: _selectedIndex,
          children: _views,
        ),
      ),
      bottomNavigationBar: Container(
        height: 100.h,
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 25.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(25.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Sliding background pill using Directional Alignment
                AnimatedAlign(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutBack,
                  alignment: _selectedIndex == 0
                      ? AlignmentDirectional.centerStart
                      : _selectedIndex == 1
                          ? AlignmentDirectional.center
                          : AlignmentDirectional.centerEnd,
                  child: FractionallySizedBox(
                    widthFactor: 0.3,
                    child: Container(
                      height: 45.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ColorManager.blue, ColorManager.primary.withValues(alpha: 0.8)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Navigation Items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavItem(0, Icons.home_outlined, AppStrings.home.tr()),
                    _buildNavItem(1, Icons.grid_view_rounded, AppStrings.services.tr()),
                    _buildNavItem(2, Icons.person_outline, AppStrings.myAccount.tr()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? ColorManager.white : ColorManager.grey,
                size: isSelected ? 22.w : 24.w,
              ),
              if (isSelected) ...[
                SizedBox(height: 2.h),
                Text(
                  label,
                  style: getBoldStyle(
                    color: ColorManager.white,
                    fontSize: 10.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
