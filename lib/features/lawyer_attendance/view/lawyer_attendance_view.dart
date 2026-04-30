import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';

class LawyerAttendanceView extends StatefulWidget {
  const LawyerAttendanceView({super.key});

  @override
  State<LawyerAttendanceView> createState() => _LawyerAttendanceViewState();
}

class _LawyerAttendanceViewState extends State<LawyerAttendanceView> {
  final TextEditingController _nameController = TextEditingController(text: 'سيد جلال');
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController(text: '0_8hhskkkkkk');

  @override
  void initState() {
    super.initState();
    // Initialize date and time to current
    final now = DateTime.now();
    _dateController.text = DateFormat('dd-MM-yyyy').format(now);
    _timeController.text = DateFormat('hh : mm a').format(now);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
        iconTheme: IconThemeData(color: ColorManager.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header section
              Center(
                child: Column(
                  children: [
                    Text(
                      AppStrings.lawyer.tr(),
                      style: getBoldStyle(
                        color: ColorManager.blue,
                        fontSize: 28.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppStrings.attendanceRegistration.tr(),
                      style: getBoldStyle(
                        color: ColorManager.greyTextColor.withValues(alpha: 0.5),
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '${AppStrings.lawyer.tr()} ( سيد جلال )',
                      style: getRegularStyle(
                        color: ColorManager.greyTextColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40.h),

              // Form fields
              _buildSectionTitle(AppStrings.name.tr()),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: _nameController,
                readOnly: true,
              ),

              SizedBox(height: 24.h),

              _buildSectionTitle(AppStrings.attendance.tr()),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _dateController,
                      readOnly: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildTextField(
                      controller: _timeController,
                      readOnly: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              // Location button
              DefaultButtonWidget(
                onPressed: () {
                  // TODO: Implement get location logic
                },
                text: AppStrings.myCurrentLocation.tr(),
                color: ColorManager.primary,
                height: 45.h,
                textStyle: getBoldStyle(color: ColorManager.white, fontSize: 16.sp),
              ),
              
              SizedBox(height: 16.h),
              
              // Location coordinates field
              Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: ColorManager.greyBorder),
                ),
                alignment: Alignment.center,
                child: Text(
                  _locationController.text,
                  style: getRegularStyle(
                    color: ColorManager.greyTextColor.withValues(alpha: 0.8),
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 60.h), // Spacer before submit

              // Submit button
              DefaultButtonWidget(
                onPressed: () {
                  GoRouter.of(context).go(AppRouters.lawyerDashboard);
                },
                text: AppStrings.signIn.tr(),
                color: ColorManager.primary,
                height: 55.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: getBoldStyle(
        color: ColorManager.black,
        fontSize: 16.sp,
      ),
      textAlign: TextAlign.right, // For RTL
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    bool readOnly = false,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorManager.greyBorder),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        textAlign: textAlign,
        style: getRegularStyle(
          color: ColorManager.greyTextColor.withValues(alpha: 0.8),
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
