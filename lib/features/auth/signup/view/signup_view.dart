import 'package:base_project/app/app_functions.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/custom_shimmer_widget.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:base_project/common/widgets/default_dropdown_menu_widget.dart';
import 'package:base_project/common/widgets/default_form_field.dart';
import 'package:base_project/features/auth/login/view/widgets/auth_logo_widget.dart';
import 'package:base_project/features/auth/signup/cubit/country_and_city_cubit/country_and_city_cubit.dart';
import 'package:base_project/features/auth/signup/cubit/signup_cubit/signup_cubit.dart';
import 'package:base_project/features/auth/signup/models/countries_cities_model.dart';
import 'package:base_project/features/auth/signup/models/signup_model.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignUpView extends StatefulWidget {
  final bool isBuyer;
  const SignUpView({super.key, this.isBuyer = false});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _workPlaceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pickupPointController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  CountryModel? _selectedCountry;
  CityModel? _selectedCity;
  String? _selectedWorkplace;

  String? _selectedImagePath;
  String _countryCode = '+20';
  UserRole? _userRole;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _workPlaceController.dispose();
    _addressController.dispose();
    _pickupPointController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isBuyer) _userRole = UserRole.passenger;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthLogoWidget(),
                    SizedBox(height: 20.h),

                    // Full Name
                    _fieldLabel("الاسم الكامل"),
                    DefaultFormField(
                      controller: _fullNameController,
                      fillColor: ColorManager.white,
                      borderColor: ColorManager.greyBorder,
                      borderRadius: 12.r,
                      hintText: "ادخل الاسم بالكامل",
                      prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                    ),

                    SizedBox(height: 15.h),

                    // Email
                    _fieldLabel("البريد الالكتروني"),
                    DefaultFormField(
                      controller: _workPlaceController,
                      fillColor: ColorManager.white,
                      borderColor: ColorManager.greyBorder,
                      borderRadius: 12.r,
                      hintText: "ادخل البريد الالكتروني",
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                    ),

                    SizedBox(height: 15.h),

                    // Phone Field
                    _fieldLabel("رقم الهاتف"),
                    DefaultFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      fillColor: ColorManager.white,
                      borderColor: ColorManager.greyBorder,
                      borderRadius: 12.r,
                      hintText: "ادخل رقم الهاتف",
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 12.w),
                          const Icon(Icons.phone_outlined, color: Colors.grey),
                          CountryCodePicker(
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            onChanged: (value) {
                              if (value.dialCode != null) _countryCode = value.dialCode!;
                            },
                            initialSelection: 'EG',
                            favorite: const ['EG', 'SA'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            dialogTextStyle: getBoldStyle(
                              fontSize: 13.sp,
                              color: ColorManager.black,
                            ),
                            showDropDownButton: true,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Text(
                        "يرجى ادخال رقم هاتف فعال لمساعدتنا في التواصل معك",
                        style: getRegularStyle(fontSize: 10.sp, color: Colors.red),
                        textAlign: TextAlign.right,
                      ),
                    ),

                    SizedBox(height: 15.h),

                    // Password
                    _fieldLabel("كلمة السر"),
                    DefaultFormField(
                      controller: _passwordController,
                      fillColor: ColorManager.white,
                      borderColor: ColorManager.greyBorder,
                      borderRadius: 12.r,
                      hintText: "ادخل كلمة السر",
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.grey),
                    ),

                    SizedBox(height: 15.h),

                    // Confirm Password
                    _fieldLabel("تأكيد كلمة السر"),
                    DefaultFormField(
                      controller: _confirmPasswordController,
                      fillColor: ColorManager.white,
                      borderColor: ColorManager.greyBorder,
                      borderRadius: 12.r,
                      hintText: "ادخل كلمة السر",
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.grey),
                    ),

                    SizedBox(height: 25.h),

                    // Signup Button
                    _signupButton(context),

                    SizedBox(height: 15.h),

                    // Login Footer
                    _loginWidgetRedesigned(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: getBoldStyle(fontSize: 14.sp, color: const Color(0xff4a5677)),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _image() {
    return Center(
      child: InkWell(
        onTap: () async {
          // Placeholder for picking logic
        },
        child: Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            color: ColorManager.fillColor.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.5), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined, color: ColorManager.greyTextColor, size: 38.w),
              SizedBox(height: 4.h),
              Text(
                AppStrings.uploadImage.tr(),
                style: getRegularStyle(fontSize: 11.sp, color: ColorManager.greyTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // StatefulBuilder _chooseUserType() {
  //   return StatefulBuilder(
  //     builder: (context, setState) {
  //       return Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           Expanded(
  //             child: DefaultRadioButton(
  //               selected: _userRole == UserRole.passenger,
  //               title: AppStrings.customer.tr(), // Using customer string for passenger
  //               onTap: () {
  //                 _userRole = UserRole.passenger;
  //                 setState(() {});
  //               },
  //               containerBorderColor: ColorManager.greyBorder,
  //               backgroundColor: _userRole == UserRole.passenger
  //                   ? ColorManager.primary
  //                   : ColorManager.white,
  //               borderColor: _userRole == UserRole.passenger
  //                   ? ColorManager.white
  //                   : ColorManager.grey,
  //               fillColor: _userRole == UserRole.passenger ? ColorManager.white : null,
  //               titleStyle: getSemiBoldStyle(
  //                 fontSize: 14.sp,
  //                 color: _userRole == UserRole.passenger ? ColorManager.white : ColorManager.black,
  //               ),
  //             ),
  //           ),
  //           SizedBox(width: 15.w),
  //           Expanded(
  //             child: DefaultRadioButton(
  //               selected: _userRole == UserRole.captain,
  //               title: AppStrings.captain.tr(),
  //               onTap: () {
  //                 _userRole = UserRole.captain;
  //                 setState(() {});
  //               },
  //               containerBorderColor: ColorManager.greyBorder,
  //               backgroundColor: _userRole == UserRole.captain
  //                   ? ColorManager.primary
  //                   : ColorManager.white,
  //               borderColor: _userRole == UserRole.captain ? ColorManager.white : ColorManager.grey,
  //               fillColor: _userRole == UserRole.captain ? ColorManager.white : null,
  //               titleStyle: getSemiBoldStyle(
  //                 fontSize: 14.sp,
  //                 color: _userRole == UserRole.captain ? ColorManager.white : ColorManager.black,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _signupButton(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: BlocConsumer<SignupCubit, BaseState<SignupModel>>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == Status.failure) {
            AppFunctions.showsToast(state.errorMessage ?? '', ColorManager.red, context);
          }
          if (state.status == Status.success) {
            context.go(
              AppRouters.verifyOtp,
              extra: {'phone': (state.data?.user?.phone ?? ''), 'isForgetPassword': false},
            );
          }
        },
        builder: (context, state) {
          return DefaultButtonWidget(
            onPressed: () {
              context.go(
                AppRouters.verifyOtp,
                extra: {
                  'phone': '01234567890',
                  'isForgetPassword': false,
                  'isSignup': true,
                },
              );
              // if (_userRole == null) {
              //   AppFunctions.showsToast(AppStrings.chooseUserType.tr(), ColorManager.red, context);
              // }
              // if ((_formKey.currentState?.validate() ?? false) && (_userRole != null)) {
              //   context.read<SignupCubit>().signup(
              //         name: _fullNameController.text.trim(),
              //         email: "", // Email removed from UI as per design
              //         phone: _countryCode + _phoneController.text.trim(),
              //         password: _passwordController.text.trim(),
              //         passwordConfirmation: _confirmPasswordController.text.trim(),
              //         imagePath: _selectedImagePath,
              //         cityId: _selectedCity?.id,
              //         countryId: _selectedCountry?.id,
              //         userRole: _userRole!,
              //         workPlace: _workPlaceController.text.trim(),
              //         address: _addressController.text.trim(),
              //         pickupPoint: _pickupPointController.text.trim(),
              //         governorateId: _selectedCountry?.id, // Temporary mapping if needed
              //         districtId: _selectedCity?.id, // Temporary mapping if needed
              //       );
              // }
            },
            text: AppStrings.signupNow.tr(),
            textColor: ColorManager.white,
            radius: 12.r,
            verticalPadding: 16.h,
            isLoading: state.status == Status.loading,
          );
        },
      ),
    );
  }

  Widget _loginWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyHaveAccount.tr(),
          style: getLightStyle(fontSize: 12.sp, color: ColorManager.textColor),
        ),
        SizedBox(width: 3.w),
        InkWell(
          onTap: () {
            context.push(AppRouters.login);
          },
          child: Text(
            AppStrings.login.tr(),
            style: getSemiBoldStyle(fontSize: 13.sp, color: ColorManager.primary),
          ),
        ),
      ],
    );
  }

  Widget _terms() {
    return Wrap(
      children: [
        Text(
          AppStrings.byCreatingAccountYouAgreeWith.tr(),
          style: getLightStyle(fontSize: 10.sp, color: ColorManager.textColor),
        ),
        SizedBox(width: 3.w),
        InkWell(
          onTap: () {
            // AppFunctions.navigateTo(
            //     context, const PrivacyPolicyView(infoType: InfoType.terms));
          },
          child: Text(
            AppStrings.terms.tr(),
            style: getBoldStyle(fontSize: 11.sp, color: ColorManager.primary),
          ),
        ),
      ],
    );
  }

  Widget _countriesAndCitiesWidget() {
    return BlocProvider(
      create: (context) => CountriesCitiesCubit()..getCountriesCities(),
      child: BlocBuilder<CountriesCitiesCubit, BaseState<CountriesCitiesModel>>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status == Status.loading || state.status == Status.initial) {
            return const CustomShimmerWidget();
          } else if (state.status == Status.success) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          DefaultDropdownMenuWidget<CountryModel>(
                            onSelected: (value) {
                              setState(() {
                                _selectedCountry = value;
                                _selectedCity = null;
                              });
                            },
                            items: state.data?.data ?? [],
                            hintText: AppStrings.selectCountry.tr(),
                            selectedValue: _selectedCountry,
                            title: AppStrings.governorate.tr(),
                            titleStyle: getRegularStyle(
                              fontSize: 13.sp,
                              color: ColorManager.greyTextColor,
                            ),
                            optionTitle: (item) => item?.name ?? '',
                            searchOptionTitle: (item) => item?.name ?? '',
                            borderColor: Colors.transparent,
                            fillColor: Colors.transparent,
                            borderRadius: 0,
                          ),
                          _buildUnderline(),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        children: [
                          DefaultDropdownMenuWidget<CityModel>(
                            onSelected: (value) {
                              setState(() {
                                _selectedCity = value;
                              });
                            },
                            items: _selectedCountry?.cities ?? [],
                            title: AppStrings.district.tr(),
                            titleStyle: getRegularStyle(
                              fontSize: 13.sp,
                              color: ColorManager.greyTextColor,
                            ),
                            hintText: AppStrings.selectCity.tr(),
                            selectedValue: _selectedCity,
                            optionTitle: (item) => item?.name ?? '',
                            searchOptionTitle: (item) => item?.name ?? '',
                            borderColor: Colors.transparent,
                            fillColor: Colors.transparent,
                            borderRadius: 0,
                          ),
                          _buildUnderline(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return InkWell(
              onTap: () => context.read<CountriesCitiesCubit>().getCountriesCities(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(state.errorMessage ?? "")),
                  SizedBox(width: 5.w),
                  const Icon(Icons.refresh, color: ColorManager.primary),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildUnderline() {
    return Container(height: 1, width: double.infinity, color: ColorManager.greyBorder);
  }

  Widget _agreementWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: getRegularStyle(fontSize: 12.sp, color: ColorManager.textColor),
          children: [
            TextSpan(text: AppStrings.byContinuingYouAgreeToOur.tr()),
            TextSpan(
              text: AppStrings.termsOfService.tr(),
              style: getBoldStyle(fontSize: 12.sp, color: ColorManager.primary),
            ),
            TextSpan(text: AppStrings.and.tr()),
            TextSpan(
              text: AppStrings.ourPrivacyPolicy.tr(),
              style: getBoldStyle(fontSize: 12.sp, color: ColorManager.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginWidgetRedesigned() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyHaveAccount.tr(),
          style: getRegularStyle(fontSize: 13.sp, color: ColorManager.textColor),
        ),
        SizedBox(width: 4.w),
        InkWell(
          onTap: () => context.pop(),
          child: Text(
            AppStrings.login.tr(),
            style: getBoldStyle(fontSize: 13.sp, color: ColorManager.primary),
          ),
        ),
      ],
    );
  }
}
