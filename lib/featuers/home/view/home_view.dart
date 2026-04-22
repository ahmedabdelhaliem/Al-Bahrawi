import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:base_project/featuers/home/view/widgets/booking_selector_field.dart';
import 'package:base_project/featuers/home/view/widgets/ongoing_trip_card.dart';
import 'package:base_project/featuers/home/view/widgets/transport_header_widget.dart';
import 'package:base_project/featuers/home/view/widgets/custom_selector_bottom_sheet.dart';
import 'package:base_project/featuers/home/view/widgets/transport_date_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  DateTime? _selectedTravelDate;
  String? _selectedGovernorate;
  String? _selectedRoute;
  String? _selectedArea;
  String? _selectedMeetingPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Pinned Aesthetic Header
          SliverPersistentHeader(pinned: true, delegate: TransportHeaderDelegate()),

          // Trip detail card that overlaps the fixed header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
              child: const OngoingTripCard(),
            ),
          ),

          // Selection form
          SliverList(
            delegate: SliverChildListDelegate([
              BookingSelectorField(
                title: _selectedGovernorate ?? AppStrings.chooseGovernorate.tr(),
                leadingIcon: Icons.shield_outlined,
                onTap: () => _openSelector(
                  title: AppStrings.chooseGovernorate.tr(),
                  options: ["القاهرة", "الجيزة", "القليوبية"],
                  onSelected: (val) => setState(() => _selectedGovernorate = val),
                ),
              ),
              BookingSelectorField(
                title: _selectedRoute ?? AppStrings.routeCapital.tr(),
                leadingIcon: Icons.add_road_outlined,
                onTap: () => _openSelector(
                  title: AppStrings.routeCapital.tr(),
                  options: ["مدينه نصر", "الوراق", "شبرا مصر", "معادي", "شيراتون", "الشروق"],
                  onSelected: (val) => setState(() => _selectedRoute = val),
                ),
              ),
              BookingSelectorField(
                title: _selectedArea ?? AppStrings.chooseArea.tr(),
                leadingIcon: Icons.gps_fixed_outlined,
                onTap: () => _openSelector(
                  title: AppStrings.chooseArea.tr(),
                  options: ["التجمع الخامس", "الرحاب", "مدينتي"],
                  onSelected: (val) => setState(() => _selectedArea = val),
                ),
              ),
              BookingSelectorField(
                title: _selectedMeetingPoint ?? AppStrings.chooseMeetingPoint.tr(),
                leadingIcon: Icons.people_outline,
                onTap: () => _openSelector(
                  title: AppStrings.chooseMeetingPoint.tr(),
                  options: ["نقطة 1", "نقطة 2", "نقطة 3"],
                  onSelected: (val) => setState(() => _selectedMeetingPoint = val),
                ),
              ),
              BookingSelectorField(
                title: _selectedTravelDate == null 
                    ? AppStrings.travelDate.tr() 
                    : DateFormat('d MMMM yyyy', 'ar').format(_selectedTravelDate!),
                leadingIcon: Icons.calendar_today_outlined,
                onTap: () => _showDatePicker(context),
              ),
            ]),
          ),

          // Action button
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
            sliver: SliverToBoxAdapter(
              child: DefaultButtonWidget(
                text: AppStrings.view.tr(),
                onPressed: () {},
                gradient: ColorManager.primaryGradient,
                textColor: ColorManager.white,
                radius: 30.r,
                fontSize: 16.sp,
                height: 48.h,
              ),
            ),
          ),

          // Footer spacing
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
    );
  }

  void _openSelector({
    required String title,
    required List<String> options,
    required Function(String) onSelected,
  }) async {
    final String? picked = await CustomSelectorBottomSheet.show(
      context,
      title: title,
      options: options,
    );

    if (picked != null) {
      onSelected(picked);
    }
  }

  void _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final DateTime? picked = await TransportDatePicker.show(
      context,
      initialDate: _selectedTravelDate ?? today,
      firstDate: today,
      lastDate: tomorrow,
    );

    if (picked != null && picked != _selectedTravelDate) {
      setState(() {
        _selectedTravelDate = picked;
      });
    }
  }
}


