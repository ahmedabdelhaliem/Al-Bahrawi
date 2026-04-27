import 'package:base_project/app/app_functions.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/custom_shimmer_widget.dart';
import 'package:base_project/common/widgets/default_app_bar.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:base_project/common/widgets/default_dropdown_menu_widget.dart';
import 'package:base_project/common/widgets/default_form_field.dart';
import 'package:base_project/common/widgets/default_radio_button.dart';
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
      appBar: DefaultAppBar(height: 0),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          children: [
            const SizedBox(height: 16),
            Text(
              AppStrings.createNewAccount.tr(),
              style: getBoldStyle(fontSize: 22.sp, color: ColorManager.textColor),
            ),
            SizedBox(height: 4.h),
            Text(
              AppStrings.enterRequiredData.tr(),
              style: getRegularStyle(fontSize: 14.sp, color: ColorManager.greyTextColor),
            ),
            SizedBox(height: 24.h),
            _image(),
            SizedBox(height: 16.h),
            DefaultFormField(
              controller: _fullNameController,
              isUnderLine: true,
              hintText: "محمد أحمد كمال",
              title: AppStrings.fullName.tr(),
              titleStyle: getRegularStyle(fontSize: 13.sp, color: ColorManager.greyTextColor),
              textStyle: getBoldStyle(fontSize: 15.sp, color: ColorManager.textColor),
            ),
            SizedBox(height: 16.h),
            DefaultFormField(
              controller: _phoneController,
              isUnderLine: true,
              keyboardType: TextInputType.phone,
              hintText: "01000022222222",
              title: AppStrings.phoneNumber.tr(),
              titleStyle: getRegularStyle(fontSize: 13.sp, color: ColorManager.greyTextColor),
              textStyle: getBoldStyle(fontSize: 15.sp, color: ColorManager.textColor),
              prefixIcon: CountryCodePicker(
                padding: EdgeInsets.zero,
                onChanged: (value) {
                  if (value.dialCode != null) _countryCode = value.dialCode!;
                },
                initialSelection: 'EG',
                favorite: const ['EG'],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                textStyle: getBoldStyle(fontSize: 15.sp, color: ColorManager.textColor),
              ),
            ),
            SizedBox(height: 16.h),
            DefaultDropdownMenuWidget<String>(
              onSelected: (value) => setState(() => _selectedWorkplace = value),
              items: const ["الداون تاون", "التجمع الخامس", "العاصمة الإدارية"],
              hintText: "اختر جهة العمل",
              title: AppStrings.workPlace.tr(),
              titleStyle: getRegularStyle(fontSize: 13.sp, color: ColorManager.greyTextColor),
              selectedValue: _selectedWorkplace,
              optionTitle: (item) => item ?? '',
              searchOptionTitle: (item) => item ?? '',
              borderColor: Colors.transparent,
              fillColor: Colors.transparent,
              borderRadius: 0,
            ),
            _buildUnderline(),
            SizedBox(height: 16.h),
            _countriesAndCitiesWidget(),
            SizedBox(height: 16.h),
            DefaultFormField(
              controller: _addressController,
              isUnderLine: true,
              hintText: "القاهرة، المنيب",
              title: AppStrings.address.tr(),
              titleStyle: getRegularStyle(fontSize: 13.sp, color: ColorManager.greyTextColor),
              textStyle: getBoldStyle(fontSize: 15.sp, color: ColorManager.textColor),
            ),
            SizedBox(height: 16.h),
            DefaultFormField(
              controller: _pickupPointController,
              isUnderLine: true,
              hintText: "القاهرة، المنيب",
              title: AppStrings.pickupPoint.tr(),
              titleStyle: getRegularStyle(fontSize: 13.sp, color: ColorManager.greyTextColor),
              textStyle: getBoldStyle(fontSize: 15.sp, color: ColorManager.textColor),
            ),
            SizedBox(height: 16.h),
            DefaultFormField(
              controller: _passwordController,
              isUnderLine: true,
              obscureText: true,
              title: AppStrings.password.tr(),
              titleStyle: getRegularStyle(fontSize: 13.sp, color: ColorManager.greyTextColor),
              textStyle: getBoldStyle(fontSize: 15.sp, color: ColorManager.textColor),
            ),
            SizedBox(height: 16.h),
            DefaultFormField(
              controller: _confirmPasswordController,
              isUnderLine: true,
              obscureText: true,
              title: AppStrings.confirmPassword.tr(),
              titleStyle: getRegularStyle(fontSize: 13.sp, color: ColorManager.greyTextColor),
              textStyle: getBoldStyle(fontSize: 15.sp, color: ColorManager.textColor),
            ),
            SizedBox(height: 24.h),
            _agreementWidget(),
            SizedBox(height: 32.h),
            _signupButton(context),
            SizedBox(height: 32.h),
          ],
        ),
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
                "رفع صورة",
                style: getRegularStyle(fontSize: 11.sp, color: ColorManager.greyTextColor),
              ).tr(),
            ],
          ),
        ),
      ),
    );
  }

  StatefulBuilder _chooseUserType() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: DefaultRadioButton(
                selected: _userRole == UserRole.passenger,
                title: AppStrings.customer.tr(), // Using customer string for passenger
                onTap: () {
                  _userRole = UserRole.passenger;
                  setState(() {});
                },
                containerBorderColor: ColorManager.greyBorder,
                backgroundColor: _userRole == UserRole.passenger
                    ? ColorManager.primary
                    : ColorManager.white,
                borderColor: _userRole == UserRole.passenger
                    ? ColorManager.white
                    : ColorManager.grey,
                fillColor: _userRole == UserRole.passenger ? ColorManager.white : null,
                titleStyle: getSemiBoldStyle(
                  fontSize: 14.sp,
                  color: _userRole == UserRole.passenger ? ColorManager.white : ColorManager.black,
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: DefaultRadioButton(
                selected: _userRole == UserRole.captain,
                title: AppStrings.captain.tr(),
                onTap: () {
                  _userRole = UserRole.captain;
                  setState(() {});
                },
                containerBorderColor: ColorManager.greyBorder,
                backgroundColor: _userRole == UserRole.captain
                    ? ColorManager.primary
                    : ColorManager.white,
                borderColor: _userRole == UserRole.captain ? ColorManager.white : ColorManager.grey,
                fillColor: _userRole == UserRole.captain ? ColorManager.white : null,
                titleStyle: getSemiBoldStyle(
                  fontSize: 14.sp,
                  color: _userRole == UserRole.captain ? ColorManager.white : ColorManager.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
              if (_userRole == null)
                AppFunctions.showsToast(AppStrings.chooseUserType.tr(), ColorManager.red, context);
              if ((_formKey.currentState?.validate() ?? false) && (_userRole != null)) {
                context.read<SignupCubit>().signup(
                  name: _fullNameController.text.trim(),
                  email: "", // Email removed from UI as per design
                  phone: _countryCode + _phoneController.text.trim(),
                  password: _passwordController.text.trim(),
                  passwordConfirmation: _confirmPasswordController.text.trim(),
                  imagePath: _selectedImagePath,
                  cityId: _selectedCity?.id,
                  countryId: _selectedCountry?.id,
                  userRole: _userRole!,
                  workPlace: _workPlaceController.text.trim(),
                  address: _addressController.text.trim(),
                  pickupPoint: _pickupPointController.text.trim(),
                  governorateId: _selectedCountry?.id, // Temporary mapping if needed
                  districtId: _selectedCity?.id, // Temporary mapping if needed
                );
              }
            },
            text: AppStrings.signupNow.tr(),
            gradient: ColorManager.primaryGradient,
            textColor: ColorManager.white,
            radius: 40.r,
            verticalPadding: 14.h,
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
            const TextSpan(text: "بمتابعتك، فإنك توافق على "),
            TextSpan(
              text: "شروط الخدمة",
              style: getBoldStyle(fontSize: 12.sp, color: ColorManager.primary),
            ),
            const TextSpan(text: " و "),
            TextSpan(
              text: "سياسة الخصوصية",
              style: getBoldStyle(fontSize: 12.sp, color: ColorManager.primary),
            ),
            const TextSpan(text: " الخاصة بنا."),
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
          "هل لديك حساب بالفعل؟",
          style: getRegularStyle(fontSize: 13.sp, color: ColorManager.textColor),
        ),
        SizedBox(width: 4.w),
        InkWell(
          onTap: () => context.pop(),
          child: Text(
            "تسجيل الدخول",
            style: getBoldStyle(fontSize: 13.sp, color: ColorManager.primary),
          ),
        ),
      ],
    );
  }
}
