import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CasesRecordView extends StatelessWidget {
  const CasesRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              physics: const BouncingScrollPhysics(),
              itemCount: 3, // Dummy count for now
              itemBuilder: (context, index) => _buildCaseCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 55.h, bottom: 40.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.blue, ColorManager.primary.withValues(alpha: 0.7)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: ColorManager.white),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                AppStrings.myCases.tr(),
                style: getBoldStyle(color: ColorManager.white, fontSize: 22.sp),
              ),
              const SizedBox(width: 48), // Spacer to center the title if needed, but here title is on right
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCaseCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "اسم المحامي",
                      style: getBoldStyle(color: ColorManager.blue, fontSize: 16.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "رقم القضية: #123456",
                      style: getRegularStyle(color: ColorManager.greyText, fontSize: 13.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "تاريخ الاستلام: 20-04-2026",
                      style: getRegularStyle(color: ColorManager.greyText, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: ColorManager.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.grid_view_rounded, color: ColorManager.primary, size: 24.w),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const Divider(height: 1, color: Color(0xffF3F4F6)),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  "معاملة",
                  Icons.description_outlined,
                  ColorManager.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildActionButton(
                  "واتساب",
                  Icons.chat_bubble_outline_rounded,
                  ColorManager.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: getBoldStyle(color: ColorManager.white, fontSize: 13.sp),
          ),
          SizedBox(width: 8.w),
          Icon(icon, color: ColorManager.white, size: 16.w),
        ],
      ),
    );
  }
}
