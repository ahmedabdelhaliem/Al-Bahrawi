import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:base_project/featuers/home/view/widgets/transport_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/featuers/my_trips/view/booking_summary_view.dart';

class TripDetailsView extends StatelessWidget {
  const TripDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header
              SliverPersistentHeader(
                pinned: true,
                delegate: TransportHeaderDelegate(title: "", showBackButton: true),
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Basic Info (with padding)
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "خط السواح",
                                    style: getBoldStyle(color: ColorManager.textColor, fontSize: 20.sp),
                                  ),
                                  Text(
                                    "أ-ب-ع 1265",
                                    style: getMediumStyle(color: ColorManager.greyText, fontSize: 14.sp),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  _buildTabButton("تفاصيل", isSelected: true),
                                  SizedBox(width: 8.w),
                                  _buildTabButton("مواعيد"),
                                  SizedBox(width: 8.w),
                                  _buildTabButton("اسعار"),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Divider(color: ColorManager.greyBorder),
                          SizedBox(height: 10.h),

                          _buildDetailItem("اسم الشركة:", "شركة السواح"),
                          _buildDetailItem("نوع الباص:", "High S"),
                          Row(
                            children: [
                              Expanded(child: _buildDetailItem("اسم المشرف:", "محمود أحمد")),
                              Text(
                                "تواصل معي",
                                style: getBoldStyle(color: Colors.blue, fontSize: 12.sp),
                              ),
                            ],
                          ),
                          _buildDetailItem("عدد المقاعد الفارغة:", "2 مقعد"),
                          _buildDetailItem("عدد المحطات في الخط:", "15 خط"),
                          _buildDetailItem(
                            "الاتجاه:",
                            "الدائري... العين السخنه... السويس... الدائري الاقليمي... كوبري اكتوبر",
                          ),
                          SizedBox(height: 10.h),
                          Divider(color: ColorManager.greyBorder),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),

                    // Section 2: Seat Images (Zero horizontal padding for the container)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "شكل المقاعد:",
                        style: getBoldStyle(color: ColorManager.textColor, fontSize: 16.sp),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: List.generate(
                          4,
                          (index) => Container(
                            width: 130.w,
                            height: 95.h,
                            margin: EdgeInsets.only(
                              right: 12.w,
                              left: index == 0 ? 16.w : 0,
                              bottom: 10.h,
                              top: 5.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(color: ColorManager.primary.withValues(alpha: 0.1), width: 1.w),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorManager.textColor.withValues(alpha: 0.08),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 4.h),
                                  spreadRadius: 1,
                                ),
                              ],
                              image: const DecorationImage(
                                image: AssetImage(ImageAssets.bus), // Placeholder
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Section 3: Times (with padding)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "مواعيد:",
                            style: getBoldStyle(color: ColorManager.textColor, fontSize: 16.sp),
                          ),
                          SizedBox(height: 12.h),
                          ...List.generate(5, (index) => _buildTimeItem("06:00 AM", "مدينة نصر")),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Section 4: Prices (with padding)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "اسعار:",
                            style: getBoldStyle(color: ColorManager.textColor, fontSize: 16.sp),
                          ),
                          SizedBox(height: 12.h),
                          _buildPriceItem("صباحي", "100 جنيه"),
                          _buildPriceItem("مسائي", "100 جنيه"),
                          _buildPriceItem("يومي", "200 جنيه"),
                          _buildPriceItem("أسبوع", "150 جنيه"),
                          _buildPriceItem("شهري", "900 جنيه", hasOffer: true),
                        ],
                      ),
                    ),
                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ],
          ),

          // Floating Button
          Positioned(
            bottom: 20.h,
            left: 40.w,
            right: 40.w,
            child: DefaultButtonWidget(
              text: "حجز مقعد",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookingSummaryView()),
                );
              },
              gradient: ColorManager.primaryGradient,
              textColor: ColorManager.white,
              radius: 30.r,
              height: 50.h,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isSelected ? ColorManager.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isSelected ? ColorManager.primary : ColorManager.greyBorder),
      ),
      child: Text(
        text,
        style: getMediumStyle(
          color: isSelected ? ColorManager.white : ColorManager.greyText,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label ",
              style: getBoldStyle(color: ColorManager.textColor, fontSize: 13.sp),
            ),
            TextSpan(
              text: value,
              style: getMediumStyle(color: ColorManager.textColor, fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeItem(String time, String location) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorManager.primary.withValues(alpha: 0.3), width: 1.w)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorManager.primary, width: 2.5.w),
                ),
                child: Icon(
                  Icons.near_me_rounded, 
                  size: 12.r, 
                  color: ColorManager.primary,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                location,
                style: getMediumStyle(color: ColorManager.textColor, fontSize: 14.sp),
              ),
            ],
          ),

          // Time on the left (second child in RTL)
          Text(
            time,
            style: getBoldStyle(color: ColorManager.textColor, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceItem(String label, String price, {bool hasOffer = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: getMediumStyle(color: ColorManager.textColor, fontSize: 14.sp),
              ),
              if (hasOffer) ...[
                SizedBox(width: 10.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    "20% off",
                    style: getBoldStyle(color: Colors.red, fontSize: 10.sp),
                  ),
                ),
              ],
            ],
          ),
          Text(
            price,
            style: getBoldStyle(color: ColorManager.textColor, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
