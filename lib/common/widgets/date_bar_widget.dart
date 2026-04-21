import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/values_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';

class DateBarWidget extends StatefulWidget{
  final Function(String dateTime, String dayNumber) onDateSelected;
  const DateBarWidget({super.key, required this.onDateSelected});

  @override
  DateBarWidgetState createState() => DateBarWidgetState();
}

class DateBarWidgetState extends State<DateBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  late List<Map<String, dynamic>> dates;

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    final lastDate = DateTime.now().add(const Duration(days: 60));
    final daysCount = lastDate.difference(today).inDays + 1;

    dates = List.generate(daysCount, (index) {
      final date = today.add(Duration(days: index));
      return {
        "day": date.day.toString(),
        "month": date.month.toString().padLeft(2, '0'),
        "weekday": _getWeekdayName(date.weekday),
        "fullDate": date.toString().split(" ")[0].trim(),
      };
    });

    _tabController = TabController(length: dates.length, vsync: this);
    _pageController = PageController();

    final String todayFormatted = today.toString().split(" ")[0].trim();
    log("Initial request for: $todayFormatted");
    widget.onDateSelected(todayFormatted, (dates[0]["weekday"]).toString().split("**")[1]);
  }

  String _getWeekdayName(int weekday) {
    const weekdaysAr = [
      "الإثنين" "**3",
      "الثلاثاء" "**4",
      "الأربعاء"  "**5",
      "الخميس"  "**6",
      "الجمعة"  "**7",
      "السبت"  "**1",
      "الأحد"  "**2",
    ];
    const weekdaysEn = [
      "Monday"  "**3",
      "Tuesday"  "**4",
      "Wednesday"  "**5",
      "Thursday"  "**6",
      "Friday"  "**7",
      "Saturday"  "**1",
      "Sunday"  "**2",
    ];
    return language == "en" ? weekdaysEn[weekday - 1] : weekdaysAr[weekday - 1];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabAlignment: TabAlignment.center,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 3.h,
      padding: EdgeInsets.only(top: 5.h,bottom: 1.5.h),
      controller: _tabController,
      isScrollable: true,
      labelColor: ColorManager.white,
      unselectedLabelColor: ColorManager.white.withOpacity(0.5),
      indicatorColor: ColorManager.white,
      labelStyle: getMediumStyle(
        fontSize: 14.sp,
        color: ColorManager.white,
      ),
      tabs: dates.map((date) {
        return Tab(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${date["month"]!}/${date["day"]!}"),
              Text((date["weekday"]!).toString().split("**")[0]),
            ],
          ),
        );
      }).toList(),
      onTap: (index) {
        final String selectedDate = dates[index]["fullDate"]!;
        final String selectedDay = (dates[index]["weekday"]!).toString().split("**")[1];
        widget.onDateSelected(selectedDate, selectedDay);
      },
    );
  }
}
