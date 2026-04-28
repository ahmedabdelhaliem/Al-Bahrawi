import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesView extends StatefulWidget {
  const ServicesView({super.key});

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  int _selectedFilter = 0;
  final List<String> _filters = [
    AppStrings.all,
    AppStrings.tax,
    AppStrings.accounting,
    AppStrings.companyFormation,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchAndFilters(),
            _buildServicesList(),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 55.h, bottom: 65.h, left: 20.w, right: 20.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.ourServices.tr(),
                      style: getBoldStyle(color: ColorManager.white, fontSize: 26.sp),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      AppStrings.servicesSubtitle.tr(),
                      style: getRegularStyle(
                        color: ColorManager.white.withValues(alpha: 0.9),
                        fontSize: 13.sp,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Transform.translate(
      offset: Offset(0, -30.h),
      child: Column(
        children: [
          // White Card containing the Search field
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Grey Search Field
                Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextField(
                    textAlign: TextAlign.right,
                    style: getRegularStyle(color: ColorManager.blue, fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: AppStrings.searchForService.tr(),
                      hintStyle: getRegularStyle(
                        color: ColorManager.grey.withValues(alpha: 0.6),
                        fontSize: 14.sp,
                      ),
                      prefixIcon: Icon(Icons.search, color: ColorManager.grey, size: 22.w),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true, // For RTL feel
                  child: Row(
                    children: List.generate(_filters.length, (index) {
                      bool isSelected = _selectedFilter == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedFilter = index),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected ? ColorManager.blue : ColorManager.fillColor,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            _filters[index].tr(),
                            style: getBoldStyle(
                              color: isSelected ? ColorManager.white : ColorManager.grey,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            AppStrings.availableService.tr(),
            style: getRegularStyle(color: ColorManager.grey, fontSize: 12.sp),
          ),
          SizedBox(height: 16.h),
          _buildServiceCard(
            AppStrings.taxConsultation.tr(),
            "ضريبي",
            AppStrings.taxConsultationShortDesc.tr(),
            Icons.percent,
            const Color(0xffE8F5E9),
            const Color(0xff2E7D32),
          ),
          _buildServiceCard(
            "الخدمات المحاسبية",
            "محاسبة",
            AppStrings.accountingShortDesc.tr(),
            Icons.menu_book,
            const Color(0xffE8F5E9),
            const Color(0xff2E7D32),
          ),
          _buildServiceCard(
            "تأسيس الشركات",
            "تأسيس",
            AppStrings.companyFormationShortDesc.tr(),
            Icons.business,
            const Color(0xffE8F5E9),
            const Color(0xff2E7D32),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    String title,
    String category,
    String desc,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.arrow_back_ios, color: ColorManager.grey, size: 12.w),
          const Spacer(),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  category,
                  style: getRegularStyle(
                    color: ColorManager.grey.withValues(alpha: 0.6),
                    fontSize: 9.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  title,
                  style: getBoldStyle(color: ColorManager.blue, fontSize: 14.sp),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 2.h),
                Text(
                  desc,
                  style: getRegularStyle(color: ColorManager.grey, fontSize: 11.sp),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12.r)),
            child: Icon(icon, color: iconColor, size: 24.w),
          ),
        ],
      ),
    );
  }
}
