import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/featuers/booking/model/booking_summary_model.dart';
import 'package:base_project/featuers/booking/view/widgets/booking_header.dart';
import 'package:base_project/featuers/booking/view/widgets/booking_type_selector.dart';
import 'package:base_project/featuers/booking/view/widgets/price_breakdown.dart';
import 'package:base_project/featuers/booking/view/widgets/summary_card.dart';

class BookingSummaryView extends StatefulWidget {
  const BookingSummaryView({super.key});

  @override
  State<BookingSummaryView> createState() => _BookingSummaryViewState();
}

class _BookingSummaryViewState extends State<BookingSummaryView> {
  BookingType _selectedType = BookingType.morning;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: BookingHeader()),
                SliverToBoxAdapter(
                  child: SummaryCard(
                    details: {
                      "الخط": "خط اكتوبر",
                      "الوقت": "07:00 صباحاً",
                      "المحطة": "الحي المتميز",
                      "تاريخ الحجز": "15 سبتمبر 2026",
                      "فئة الباص": "High Standard",
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: BookingTypeSelector(
                    onTypeChanged: (type) {
                      setState(() => _selectedType = type);
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: PriceBreakdown(
                    seatPrice: _selectedType.price,
                    discount: 0.0,
                    bookingFees: 5.0,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              ],
            ),
          ),
          
          // Bottom Buttons
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
            decoration: BoxDecoration(
              color: ColorManager.white,
              boxShadow: [
                BoxShadow(
                  color: ColorManager.black.withValues(alpha: 0.05),
                  blurRadius: 10.r,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Confirm Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    gradient: const LinearGradient(
                      colors: [ColorManager.primary, Color(0xFF043180)],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                    ),
                    child: Text(
                      AppStrings.confirmBooking.tr(),
                      style: getBoldStyle(color: ColorManager.white, fontSize: 16.sp),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ColorManager.red),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                    ),
                    child: Text(
                      AppStrings.cancel.tr(),
                      style: getBoldStyle(color: ColorManager.red, fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
