import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransportDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const TransportDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  static Future<DateTime?> show(BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return showDialog<DateTime>(
      context: context,
      builder: (context) => TransportDatePicker(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
  }

  @override
  State<TransportDatePicker> createState() => _TransportDatePickerState();
}

class _TransportDatePickerState extends State<TransportDatePicker> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: ColorManager.white,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: Year Month and Nav Arrows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_currentMonth.year} ${DateFormat('MMMM', 'ar').format(_currentMonth)}",
                  style: getBoldStyle(color: ColorManager.black, fontSize: 20.sp),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, size: 20.r, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right, size: 20.r, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // Days Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: _daysInMonth(_currentMonth) + _firstDayOffset(_currentMonth),
              itemBuilder: (context, index) {
                final int dayOffset = _firstDayOffset(_currentMonth);
                if (index < dayOffset) {
                  return const SizedBox.shrink();
                }

                final int day = index - dayOffset + 1;
                final DateTime date = DateTime(_currentMonth.year, _currentMonth.month, day);
                
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final tomorrow = today.add(const Duration(days: 1));

                final bool isSelectable = date.isAtSameMomentAs(today) || date.isAtSameMomentAs(tomorrow);
                
                final bool isSelected = date.year == _selectedDate.year && 
                                       date.month == _selectedDate.month && 
                                       date.day == _selectedDate.day;

                return GestureDetector(
                  onTap: isSelectable ? () {
                    setState(() {
                      _selectedDate = date;
                    });
                    Navigator.pop(context, _selectedDate);
                  } : null,
                  child: Container(
                    margin: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0D47A1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "$day",
                      style: getBoldStyle(
                        color: isSelected 
                            ? ColorManager.white 
                            : (isSelectable ? ColorManager.black : Colors.grey.withValues(alpha: 0.3)),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  int _daysInMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0).day;
  }

  int _firstDayOffset(DateTime month) {
    return DateTime(month.year, month.month, 1).weekday % 7;
  }
}
