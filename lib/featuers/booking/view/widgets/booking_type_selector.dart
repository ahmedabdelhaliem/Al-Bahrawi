import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/featuers/booking/model/booking_summary_model.dart';

class BookingTypeSelector extends StatefulWidget {
  final ValueChanged<BookingType> onTypeChanged;

  const BookingTypeSelector({super.key, required this.onTypeChanged});

  @override
  State<BookingTypeSelector> createState() => _BookingTypeSelectorState();
}

class _BookingTypeSelectorState extends State<BookingTypeSelector> {
  BookingType _selectedType = BookingType.morning;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "أنواع الحجز:",
            style: getBoldStyle(color: ColorManager.primary, fontSize: 16.sp),
          ),
          SizedBox(height: 12.h),
          ...BookingType.values.map((type) => _buildRadioItem(type)),
        ],
      ),
    );
  }

  Widget _buildRadioItem(BookingType type) {
    final isSelected = _selectedType == type;
    String title = "";
    switch (type) {
      case BookingType.morning:
        title = "حجز صباحي";
        break;
      case BookingType.night:
        title = "حجز مسائي";
        break;
      case BookingType.daily:
        title = "حجز يومي (ذهاب وعودة)";
        break;
      case BookingType.monthly:
        title = "حجز شهري";
        break;
    }

    return InkWell(
      onTap: () {
        setState(() => _selectedType = type);
        widget.onTypeChanged(type);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? ColorManager.azureBlue : ColorManager.grey,
                  width: 2.w,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.r,
                        height: 10.r,
                        decoration: const BoxDecoration(
                          color: ColorManager.azureBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: getMediumStyle(
                  color: isSelected ? ColorManager.primary : ColorManager.greyText,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Text(
              "${type.price} جنيه",
              style: getBoldStyle(
                color: isSelected ? ColorManager.azureBlue : ColorManager.greyText,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
