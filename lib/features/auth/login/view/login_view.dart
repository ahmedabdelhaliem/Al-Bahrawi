import 'package:al_bahrawi/app/app_functions.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
import 'package:al_bahrawi/common/widgets/default_form_field.dart';
import 'package:al_bahrawi/features/auth/login/cubit/login_cubit.dart';
import 'package:al_bahrawi/features/auth/login/models/login_model.dart';
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
      backgroundColor: const Color(0xfff5f5f5), // Light grey background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome Texts
                    Text(
                      "مرحبا بك",
                      style: getBoldStyle(fontSize: 26.sp, color: const Color(0xff4a5677)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "أنشئ حساباً أو قم بتسجيل الدخول لاستكشاف تطبيقنا",
                      style: getRegularStyle(fontSize: 12.sp, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 30.h),

                    // Login Title
                    Text(
                      "تسجيل الدخول",
                      style: getBoldStyle(fontSize: 18.sp, color: ColorManager.black),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 15.h),

                    // Phone Field Label
                    _fieldLabel("رقم الهاتف"),
                    DefaultFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      fillColor: ColorManager.white,
                      borderColor: ColorManager.greyBorder,
                      borderRadius: 12.r,
                      hintText: "ادخل رقم الهاتف",
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

                    SizedBox(height: 15.h),

                    // Password Field Label
                    _fieldLabel("كلمة المرور"),
                    DefaultFormField(
                      controller: _passwordController,
                      fillColor: ColorManager.white,
                      borderColor: ColorManager.greyBorder,
                      borderRadius: 12.r,
                      hintText: "****",
                      obscureText: true,
                      suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                      prefixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.grey),
                    ),

                    SizedBox(height: 25.h),

                    // Login Button
                    _loginButton(context),

                    SizedBox(height: 12.h),

                    // Remember Me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => context.push(AppRouters.forgetPass),
                          child: Text(
                            "نسيت كلمة المرور ؟",
                            style: getMediumStyle(fontSize: 12.sp, color: ColorManager.primary),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "تذكرني دائماً",
                              style: getMediumStyle(fontSize: 12.sp, color: Colors.grey),
                            ),
                            Checkbox(
                              value: true,
                              onChanged: (v) {},
                              activeColor: ColorManager.primary,
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 15.h),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            "أو",
                            style: getRegularStyle(fontSize: 14.sp, color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Social Buttons
                    _socialButton("تسجيل الدخول بواسطة حساب جوجل", Icons.g_mobiledata, Colors.red),
                    SizedBox(height: 10.h),
                    _socialButton("تسجيل الدخول بواسطة فيسبوك", Icons.facebook, Colors.blue),

                    SizedBox(height: 20.h),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => context.push(AppRouters.signup),
                          child: Text(
                            "انشاء حساب جديد",
                            style: getBoldStyle(fontSize: 14.sp, color: ColorManager.primary),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "لا تمتلك حساب؟",
                          style: getMediumStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      ],
                    ),
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

  Widget _socialButton(String text, IconData icon, Color iconColor) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: getMediumStyle(fontSize: 13.sp, color: const Color(0xff4a5677)),
          ),
          SizedBox(width: 10.w),
          Icon(icon, color: iconColor, size: 28),
        ],
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
