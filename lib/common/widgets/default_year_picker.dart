import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';

class DefaultYearPicker extends StatefulWidget {
  const DefaultYearPicker({super.key, this.onSelectedYear, this.selectedYear, this.isLastDateAfterNow = false});
  final void Function(int year)? onSelectedYear;
  final int? selectedYear;
  final bool isLastDateAfterNow;

  static Future<void> show(BuildContext context,{
    final void Function(int year)? onSelectedYear,
    final int? selectedYear,
    final bool isLastDateAfterNow = false,
  }) => showDialog(
    context: context,
    builder: (BuildContext context) {
      return DefaultYearPicker(onSelectedYear: onSelectedYear,selectedYear: selectedYear,isLastDateAfterNow: isLastDateAfterNow,);
    },
  );

  @override
  State<DefaultYearPicker> createState() => _DefaultYearPickerState();
}

class _DefaultYearPickerState extends State<DefaultYearPicker> {
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.selectedYear;
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: ColorManager.primary,
          onPrimary: ColorManager.white,
          onSurface: ColorManager.black,
          surface: ColorManager.white,
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: ColorManager.white,
          headerBackgroundColor: ColorManager.primary,
          headerForegroundColor: ColorManager.white,
          yearStyle: TextStyle(
            color: ColorManager.black,
            fontSize: 15.sp,
          ),
          todayBackgroundColor: WidgetStatePropertyAll(ColorManager.primaryLight),
          todayForegroundColor: WidgetStateProperty.all(_selectedYear == DateTime.now().year ? ColorManager.white : ColorManager.primary),
        ),
      ),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: ColorManager.primary, width: 2.w),
        ),
        title: Text(
          AppStrings.selectYear.tr(),
          style: TextStyle(color: ColorManager.primary),
        ),
        content: SizedBox(
          width: 300.w,
          height: 300.h,
          child: Localizations.override(
            context: context,
            locale: const Locale('en'),
            child: YearPicker(
              firstDate: DateTime(1950),
              lastDate: DateTime.now().add(widget.isLastDateAfterNow ? Duration(days: 3660) : Duration.zero),
              selectedDate: _selectedYear != null
                  ? DateTime(_selectedYear!)
                  : DateTime.now(),
              onChanged: (DateTime dateTime) {
                setState(() {
                  _selectedYear = dateTime.year;
                });
                if(widget.onSelectedYear != null) widget.onSelectedYear!(dateTime.year);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
