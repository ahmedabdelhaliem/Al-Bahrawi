import 'package:base_project/common/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OffersView extends StatelessWidget {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "العروض",
          style: getBoldStyle(color: Colors.black, fontSize: 18.sp),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20.r),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        children: [
          _buildOfferCard(context, discountText: "خصم 30% لاول رحله"),
          SizedBox(height: 16.h),
          _buildOfferCard(context, discountText: "خصم 50% على الرحله الخامسه"),
        ],
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, {required String discountText}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 30.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0D3073), // Dark blue from the screenshot
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "عروضي",
            style: getRegularStyle(color: Colors.white, fontSize: 12.sp),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Text(
              discountText,
              style: getBoldStyle(color: Colors.white, fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
