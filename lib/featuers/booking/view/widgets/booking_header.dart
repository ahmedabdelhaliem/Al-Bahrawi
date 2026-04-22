import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/common/resources/color_manager.dart';

class BookingHeader extends StatelessWidget {
  const BookingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Rectangular background with gradient
        Container(
          width: double.infinity,
          height: 180.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                ColorManager.primary,
                Color(0xFF043180),
              ],
            ),
          ),
        ),
        // Bus Image and controls
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_back_ios_new, color: ColorManager.primary, size: 18.r),
                      ),
                    ),
                  ],
                ),
              ),
              // Bus image centered
              Center(
                child: Image.network(
                  "https://pngimg.com/uploads/bus/bus_PNG8611.png", // Example bus image
                  height: 100.h,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.directions_bus, size: 70.r, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
