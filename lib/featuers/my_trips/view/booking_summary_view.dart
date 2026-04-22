import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:base_project/featuers/home/view/widgets/transport_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingSummaryView extends StatefulWidget {
  const BookingSummaryView({super.key});

  @override
  State<BookingSummaryView> createState() => _BookingSummaryViewState();
}

class _BookingSummaryViewState extends State<BookingSummaryView> {
  String _selectedBookingType = "صباحي";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Shared Header
              SliverPersistentHeader(
                pinned: true,
                delegate: TransportHeaderDelegate(title: "", showBackButton: true),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Booking Summary Card
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: ColorManager.primary, width: 1.5.w),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ملخص الحجز:",
                              style: getBoldStyle(color: ColorManager.textColor, fontSize: 16.sp),
                            ),
                            SizedBox(height: 8.h),
                            _buildSummaryRow("الحط:", "خط اكتوبر"),
                            _buildSummaryRow("الوقت:", "07:00 AM"),
                            _buildSummaryRow("المحطة:", "مدينة نصر"),
                            _buildSummaryRow("تاريخ الحجز:", "2026-04-20"),
                            _buildSummaryRow("نوع الباص:", "High Standard"),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Booking Types Section
                      Text(
                        "انواع الحجز:",
                        style: getBoldStyle(color: ColorManager.textColor, fontSize: 16.sp),
                      ),
                      SizedBox(height: 8.h),
                      _buildBookingTypeOption("صباحي", "100 جنيه"),
                      _buildBookingTypeOption("مسائي", "180 جنيه"),
                      _buildBookingTypeOption("يومي", "200 جنيه"),
                      _buildBookingTypeOption("شهري", "900 جنيه"),

                      SizedBox(height: 12.h),
                      Divider(color: Colors.grey.shade300),
                      SizedBox(height: 12.h),

                      // Pricing Details
                      _buildPriceDetailRow("سعر المقعد:", "100 جنيه"),
                      _buildPriceDetailRow("خصم:", "0 جنيه"),
                      _buildPriceDetailRow("رسوم الحجز:", "0 جنيه"),

                      SizedBox(height: 12.h),
                      Divider(color: Colors.grey.shade300),
                      SizedBox(height: 12.h),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "الاجمالي:",
                            style: getBoldStyle(color: ColorManager.textColor, fontSize: 18.sp),
                          ),
                          Text(
                            "100 جنيه",
                            style: getBoldStyle(color: ColorManager.primary, fontSize: 18.sp),
                          ),
                        ],
                      ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Action Buttons
          Positioned(
            bottom: 20.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DefaultButtonWidget(
                    text: "تأكيد الحجز",
                    onPressed: () => _showSuccessDialog(context),
                    gradient: ColorManager.primaryGradient,
                    textColor: ColorManager.white,
                    radius: 30.r,
                    height: 50.h,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: DefaultButtonWidget(
                    text: "الغاء",
                    onPressed: () => Navigator.pop(context),
                    color: ColorManager.white,
                    textColor: ColorManager.primary,
                    withBorder: true,
                    borderColor: ColorManager.primary,
                    radius: 30.r,
                    height: 50.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: Colors.grey, size: 20.r),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: 75.r,
                height: 75.r,
                decoration: const BoxDecoration(
                  color: ColorManager.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check, 
                  color: Colors.white, 
                  size: 45.r,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "تم الحجز بنجاح",
                style: getBoldStyle(color: ColorManager.textColor, fontSize: 18.sp),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getMediumStyle(color: ColorManager.greyText, fontSize: 13.sp),
          ),
          Text(
            value,
            style: getBoldStyle(color: ColorManager.textColor, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingTypeOption(String label, String price) {
    bool isSelected = _selectedBookingType == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedBookingType = label),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 20.r,
                  height: 20.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? ColorManager.primary : ColorManager.greyBorder,
                      width: 2.w,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10.r,
                            height: 10.r,
                            decoration: const BoxDecoration(
                              color: ColorManager.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 10.w),
                Text(
                  label,
                  style: getMediumStyle(color: ColorManager.textColor, fontSize: 14.sp),
                ),
              ],
            ),
            Text(
              price,
              style: getBoldStyle(color: ColorManager.primary, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getBoldStyle(color: ColorManager.greyText, fontSize: 14.sp),
          ),
          Text(
            value,
            style: getBoldStyle(color: ColorManager.textColor, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
