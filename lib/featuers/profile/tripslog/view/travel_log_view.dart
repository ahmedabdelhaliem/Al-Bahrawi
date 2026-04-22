import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/widgets/custom_app_bar.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:base_project/featuers/profile/tripslog/view/widgets/travel_log_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TravelLogView extends StatefulWidget {
  final String title;
  const TravelLogView({super.key, required this.title});

  @override
  State<TravelLogView> createState() => _TravelLogViewState();
}

class _TravelLogViewState extends State<TravelLogView> {
  int _selectedIndex = 0;

  static const List<String> _status = [
    'upcomingTrips',
    'completedTrips',
    'canceledTrips',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: widget.title.tr()),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemBuilder: (context, index) => const TravelLogItem(),
      ),
    );
  }
}
