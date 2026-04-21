import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/values_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';

class DefaultTabBarWidget extends StatefulWidget {
  final List<String> tabTitles;
  final List<Widget> tabViews;
  final double tabWidth;
  final Function(int index)? onSelectedTab;
  const DefaultTabBarWidget({super.key, required this.tabTitles, required this.tabViews, required this.tabWidth, this.onSelectedTab,});

  @override
  State<DefaultTabBarWidget> createState() => _DefaultTabBarWidgetState();
}

class _DefaultTabBarWidgetState extends State<DefaultTabBarWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabTitles.length,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tabBar(),
          Flexible(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  alignment: language == "en" ? Alignment.centerRight : Alignment.centerLeft,
                  child: child,
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_currentIndex),
                child: widget.tabViews[_currentIndex],
              ),
            ),
          ),

          // AnimatedCrossFade(
          //   firstChild: widget.tabViews[_currentIndex],
          //   secondChild: widget.tabViews[_currentIndex],
          //   crossFadeState: _currentIndex == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          //   duration: Duration(milliseconds: 300),
          // ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: ColorManager.greyBorder)),
        boxShadow: [
            BoxShadow(
              color: ColorManager.greyBorder.withValues(alpha: 0.2),
              blurRadius: 5.r,
              spreadRadius: 3.r,
               offset: Offset(0, 4.h)
            ),
        ],
      ),
      child: TabBar(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          dividerColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          labelPadding: EdgeInsetsDirectional.symmetric(horizontal: 5.w),
          onTap: (value) {
            _currentIndex = value;
            if(widget.onSelectedTab != null) widget.onSelectedTab!(_currentIndex);
            setState(() {});
          },
          tabs: List.generate(widget.tabTitles.length, (index) => _tabItem(text: widget.tabTitles[index], isSelected: _currentIndex == index),),
      ),
    );
  }

  Widget _tabItem({
    required String text,
    required bool isSelected,
  })
  {
    return AnimatedContainer(
        width: widget.tabWidth,
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
        decoration: BoxDecoration(
            color: isSelected ? ColorManager.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: ColorManager.primary,
            )),
        child: Text(
          text,
          style: getBoldStyle(
              fontSize: 12.sp,
              color: isSelected ? ColorManager.white : ColorManager.primary),
          textAlign: TextAlign.center,
        ));
  }

}
