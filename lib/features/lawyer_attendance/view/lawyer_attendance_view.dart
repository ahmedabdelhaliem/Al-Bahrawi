import 'package:al_bahrawi/app/app_functions.dart';
import 'package:al_bahrawi/app/app_prefs.dart';
import 'package:al_bahrawi/app/di.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
import 'package:al_bahrawi/features/lawyer_attendance/cubit/lawyer_attendance_cubit.dart';
import 'package:al_bahrawi/features/lawyer_attendance/models/attendance_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class LawyerAttendanceView extends StatefulWidget {
  const LawyerAttendanceView({super.key});

  @override
  State<LawyerAttendanceView> createState() => _LawyerAttendanceViewState();
}

class _LawyerAttendanceViewState extends State<LawyerAttendanceView> {
  late final TextEditingController _nameController;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController(
    text: 'maadi',
  ); // Default for now as per Postman
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final String userName = instance<AppPreferences>().getUserName();
    _nameController = TextEditingController(text: userName);

    // Initialize date and time to current
    final now = DateTime.now();
    _dateController.text = DateFormat('dd-MM-yyyy').format(now);
    _timeController.text = DateFormat('hh : mm a').format(now);
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    print("🔵 Checking location services...");
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❌ Location services disabled.");
      if (mounted) AppFunctions.showsToast("خدمة الموقع غير مفعلة", ColorManager.red, context);
      return;
    }

    print("🔵 Checking location permissions...");
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print("🟡 Permission denied, requesting...");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("❌ Permission denied again.");
        if (mounted) AppFunctions.showsToast("تم رفض إذن الوصول للموقع", ColorManager.red, context);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("❌ Permission denied forever.");
      if (mounted) AppFunctions.showsToast("إذن الموقع مرفوض بشكل دائم", ColorManager.red, context);
      return;
    }

    try {
      print("🔵 Fetching coordinates...");
      Position position = await Geolocator.getCurrentPosition();
      print("📍 Coordinates: ${position.latitude}, ${position.longitude}");

      // Reverse geocoding
      await setLocaleIdentifier("ar");
      print("🔵 Fetching address details...");
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        print("✅ Address Found: ${place.toString()}");
        setState(() {
          _locationController.text = "${place.street}, ${place.subLocality}, ${place.locality}";
        });
      } else {
        print("⚠️ No address found for these coordinates.");
        setState(() {
          _locationController.text = "${position.latitude}, ${position.longitude}";
        });
      }
    } catch (e) {
      print("❌ Location Error: $e");
      if (mounted) AppFunctions.showsToast("حدث خطأ أثناء جلب العنوان", ColorManager.red, context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LawyerAttendanceCubit(),
      child: BlocConsumer<LawyerAttendanceCubit, BaseState<AttendanceModel>>(
        listener: (context, state) {
          if (state.status == Status.failure) {
            AppFunctions.showsToast(state.errorMessage ?? 'Error', ColorManager.red, context);
          }
          if (state.status == Status.success) {
            AppFunctions.showsToast(
              state.data?.message ?? 'Success',
              ColorManager.primary,
              context,
            );
            context.go(AppRouters.lawyerDashboard);
          }
        },
        builder: (context, state) {
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
                            style: getBoldStyle(color: ColorManager.blue, fontSize: 28.sp),
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
                            '${AppStrings.lawyer.tr()} ( ${_nameController.text} )',
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
                    _buildTextField(controller: _nameController, readOnly: true),

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

                    SizedBox(height: 24.h),

                    _buildSectionTitle(AppStrings.notes.tr() ?? "الملاحظات"),
                    SizedBox(height: 8.h),
                    _buildTextField(controller: _notesController, hintText: "اضف ملاحظاتك هنا..."),

                    SizedBox(height: 32.h),

                    // Location button
                    DefaultButtonWidget(
                      onPressed: _getCurrentLocation,
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
                    // Submit button (Check In)
                    DefaultButtonWidget(
                      onPressed: () {
                        context.push(AppRouters.lawyerDashboard);
                        // context.read<LawyerAttendanceCubit>().markAttendance(
                        //   action: "check_in",
                        //   location: _locationController.text,
                        //   notes: _notesController.text,
                        // );
                      },
                      text: AppStrings.signIn.tr(),
                      color: ColorManager.primary,
                      height: 55.h,
                      isLoading: state.status == Status.loading,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: getBoldStyle(color: ColorManager.black, fontSize: 16.sp),
      textAlign: TextAlign.right, // For RTL
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    bool readOnly = false,
    TextAlign textAlign = TextAlign.start,
    String? hintText,
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
          hintText: hintText,
          hintStyle: getRegularStyle(color: Colors.grey, fontSize: 12.sp),
        ),
      ),
    );
  }
}
