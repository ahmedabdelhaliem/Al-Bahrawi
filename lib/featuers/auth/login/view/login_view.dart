import 'package:base_project/app/app_functions.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/network/failure.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_app_bar.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:base_project/common/widgets/default_form_field.dart';
import 'package:base_project/featuers/auth/login/cubit/login_cubit.dart';
import 'package:base_project/featuers/auth/login/models/login_model.dart';
import 'package:base_project/featuers/auth/login/view/widgets/auth_logo_widget.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  final int pageIndex;
  final bool pop;
  final bool showLoginFirstToast;
  const LoginView({
    super.key,
    this.pageIndex = 0,
    this.pop = false,
    this.showLoginFirstToast = false,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  String _countryCode = '+20';

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    // _emailController.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showLoginFirstToast && mounted)
        AppFunctions.showsToast(AppStrings.loginFirst.tr(), ColorManager.red, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: DefaultAppBar(height: 0),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          children: [
            SizedBox(height: 40.h),
            const AuthLogoWidget(),
            SizedBox(height: 24.h),
            Text(
              AppStrings.login.tr(),
              style: getBoldStyle(fontSize: 22.sp, color: ColorManager.textColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              AppStrings.enterEmailAndPass.tr(),
              style: getRegularStyle(fontSize: 13.sp, color: ColorManager.greyTextColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            DefaultFormField(
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              fillColor: ColorManager.white,
              borderColor: ColorManager.greyBorder,
              borderRadius: 8.r,
              hintText: AppStrings.enterYourPhoneNumber.tr(),
              title: AppStrings.phoneNumber.tr(),
              prefixIcon: CountryCodePicker(
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
                dialogTextStyle: getBoldStyle(fontSize: 13.sp, color: ColorManager.black),
                showDropDownButton: true,
              ),
            ),
            SizedBox(height: 16.h),
            DefaultFormField(
              controller: _passwordController,
              fillColor: ColorManager.white,
              borderColor: ColorManager.greyBorder,
              borderRadius: 8.r,
              hintText: AppStrings.password.tr(),
              title: AppStrings.password.tr(),
              obscureText: true,
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  context.push(AppRouters.forgetPass);
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: Text(
                    AppStrings.forgotPassword.tr(),
                    style: getSemiBoldStyle(fontSize: 12.sp, color: ColorManager.primary),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            _loginButton(context),
            SizedBox(height: 24.h),
            _signupWidget(),
            SizedBox(height: 16.h),
            // _guestWidget(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, BaseState<LoginModel>>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          context.go(
            AppRouters.btmNav,
            extra: {"refreshKey": UniqueKey(), "pageIndex": widget.pageIndex},
          );

          // if (state.status == Status.failure) {
          //   AppFunctions.showsToast(state.errorMessage!, ColorManager.red, context);
          //   if (state.failure is ActiveAccountFailure) {
          //     context.push(
          //       AppRouters.verifyOtp,
          //       extra: {
          //         'phone': _countryCode + _phoneController.text.trim(),
          //         // 'email': _emailController.text,
          //         'isForgetPassword': false,
          //       },
          //     );
          //   }
          // }
          // if (state.status == Status.success) {
          //   if (widget.pop) {
          //     context.pop();
          //   } else {
          //     context.go(
          //       AppRouters.btmNav,
          //       extra: {"refreshKey": UniqueKey(), "pageIndex": widget.pageIndex},
          //     );
          //   }
          // }
        },
        builder: (context, state) {
          return DefaultButtonWidget(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                context.read<LoginCubit>().login(
                  _countryCode + _phoneController.text.trim(),
                  // _emailController.text,
                  _passwordController.text.trim(),
                );
              }
            },
            text: AppStrings.login.tr(),
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

  Widget _signupWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.dontHaveAccount.tr(),
          style: getRegularStyle(fontSize: 12.sp, color: ColorManager.greyTextColor),
        ),
        SizedBox(width: 4.w),
        InkWell(
          onTap: () {
            context.push(AppRouters.signup);
          },
          borderRadius: BorderRadius.circular(7.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Text(
              AppStrings.signupNow.tr(),
              style: getSemiBoldStyle(fontSize: 13.sp, color: ColorManager.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _guestWidget() {
    return DefaultButtonWidget(
      elevation: 0,
      text: AppStrings.continueAsAGuest.tr(),
      color: ColorManager.white,
      isIcon: true,
      isText: true,
      isExpanded: false,
      textFirst: true,
      radius: 8.r,
      withBorder: true,
      borderColor: ColorManager.greyBorder.withValues(alpha: 0.3),
      iconBuilder: Icon(Icons.arrow_forward_ios_rounded, color: ColorManager.primary, size: 12.r),
      textStyle: getSemiBoldStyle(fontSize: 12.sp, color: ColorManager.primary),
      onPressed: () => context.push(AppRouters.btmNav, extra: {"refreshKey": UniqueKey()}),
    );
  }
}
