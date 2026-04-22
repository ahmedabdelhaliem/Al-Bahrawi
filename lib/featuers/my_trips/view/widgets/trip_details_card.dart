import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripDetailsCard extends StatelessWidget {
  final String price;
  final String lineName;
  final String companyName;
  final String city;
  final String busType;
  final String routes;
  final String departureTime;
  final String arrivalTime;
  final bool isSelected;
  final VoidCallback? onTap;

  const TripDetailsCard({
    super.key,
    required this.price,
    required this.lineName,
    required this.companyName,
    required this.city,
    required this.busType,
    required this.routes,
    required this.departureTime,
    required this.arrivalTime,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: 0.04),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Material(
        color: ColorManager.white,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected ? ColorManager.primary : const Color(0xFFE3F2FD),
                width: isSelected ? 1.5.w : 1.w,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Right Side visually (first in RTL): Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildInfoText("شركة: ", companyName),
                      SizedBox(height: 4.h),
                      Text(
                        city,
                        style: getMediumStyle(color: Colors.black87, fontSize: 12.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      _buildInfoText("نوع الباص: ", busType),
                      SizedBox(height: 4.h),
                      _buildInfoText("المحاور الرئيسية: ", routes),
                      SizedBox(height: 4.h),
                      _buildInfoText("ميعاد الخروج من العاصمه: ", departureTime),
                      SizedBox(height: 4.h),
                      _buildInfoText("ميعاد الوصول الى العاصمه: ", arrivalTime),
                    ],
                  ),
                ),
                
                SizedBox(width: 12.w),
                
                // Left Side visually (second in RTL): Price, Bus Image, Line Name
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Price Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6EBFD),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        "$price جنيه",
                        style: getBoldStyle(color: ColorManager.primary, fontSize: 11.sp),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Bus Image
                    Image.asset(
                      ImageAssets.bus,
                      width: 65.w, // Slightly smaller for better fit on all screens
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 6.h),
                    // Line Name
                    Text(
                      lineName,
                      style: getBoldStyle(color: Colors.black87, fontSize: 11.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoText(String title, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: getMediumStyle(color: Colors.black87, fontSize: 12.sp),
          ),
          TextSpan(
            text: value,
            style: getMediumStyle(color: Colors.black87, fontSize: 12.sp),
          ),
        ],
      ),
      softWrap: true,
      textAlign: TextAlign.start,
    );
  }
}
