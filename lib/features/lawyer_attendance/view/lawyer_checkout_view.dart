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

class LawyerCheckoutView extends StatefulWidget {
  const LawyerCheckoutView({super.key});

  @override
  State<LawyerCheckoutView> createState() => _LawyerCheckoutViewState();
}

class _LawyerCheckoutViewState extends State<LawyerCheckoutView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String _currentLocation = "جاري جلب الموقع...";
  final LawyerAttendanceCubit _cubit = instance<LawyerAttendanceCubit>();

  @override
  void initState() {
    super.initState();
    final String userName = instance<AppPreferences>().getUserName();
    _nameController.text = userName;

    // Initialize date and time to current
    final now = DateTime.now();
    _dateController.text = DateFormat('dd-MM-yyyy').format(now);
    _timeController.text = DateFormat('hh : mm a').format(now);

    // Fetch location automatically in background
    _getBackgroundLocation();
  }

  Future<void> _getBackgroundLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition();
      
      // Get address string
      await setLocaleIdentifier("ar");
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (mounted) {
          setState(() {
            _currentLocation = "${place.street}, ${place.subLocality}, ${place.locality}";
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _currentLocation = "${position.latitude}, ${position.longitude}";
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching background location: $e");
      if (mounted) {
        setState(() {
          _currentLocation = "تعذر جلب الموقع";
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
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
              iconTheme:  IconThemeData(color: ColorManager.black),
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
                            AppStrings.checkoutRegistration.tr(),
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
                    _buildTextField(
                      controller: _nameController,
                      readOnly: true,
                    ),

                    SizedBox(height: 24.h),

                    _buildSectionTitle(AppStrings.checkout.tr()), // "الإنصراف"
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

                    SizedBox(height: 20.h),
                    
                    // Show current location status (Optional, just to keep user informed)
                    Text(
                      _currentLocation,
                      style: getRegularStyle(color: ColorManager.greyTextColor, fontSize: 12.sp),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 40.h),

                    // Register button
                    DefaultButtonWidget(
                      onPressed: () {
                        _cubit.markAttendance(
                          action: "check_out",
                          location: _currentLocation == "جاري جلب الموقع..." || _currentLocation == "تعذر جلب الموقع" 
                              ? "N/A" 
                              : _currentLocation,
                        );
                      },
                      text: AppStrings.register.tr(), // "تسجيل"
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
