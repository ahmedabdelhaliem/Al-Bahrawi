import 'package:go_router/go_router.dart';
import 'package:al_bahrawi/app/app_functions.dart';
import 'package:al_bahrawi/common/base/base_model.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_app_bar.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
import 'package:al_bahrawi/common/widgets/default_form_field.dart';
import 'package:al_bahrawi/features/auth/forget_password/bloc/forget_password_cubit.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_bahrawi/features/auth/login/view/widgets/auth_logo_widget.dart';
import 'package:country_code_picker/country_code_picker.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({
    super.key,
  });

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  String _countryCode = "+20";
  late ForgetPasswordCubit _forgetPasswordBloc;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: Builder(builder: (context) {
        _forgetPasswordBloc = context.read<ForgetPasswordCubit>();
        return Scaffold(
          backgroundColor: const Color(0xfff5f5f5),
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
                        Text(
                          "نسيت كلمة المرور",
                          style: getBoldStyle(fontSize: 22.sp, color: const Color(0xff4a5677)),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "ادخل رقم هاتفك لتلقي رمز التحقق",
                          style: getRegularStyle(fontSize: 13.sp, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30.h),
                        
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
                        
                        SizedBox(height: 30.h),
                        _activeAccountContent(),
                        
                        SizedBox(height: 15.h),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            "العودة لتسجيل الدخول",
                            style: getBoldStyle(fontSize: 14.sp, color: ColorManager.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
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

  Widget _activeAccountContent() {
    return BlocConsumer<ForgetPasswordCubit, BaseState<BaseModel>>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == Status.failure) {
          AppFunctions.showsToast(
              state.errorMessage ?? '', ColorManager.red, context);
        }
        if (state.status == Status.success) {
          context.push(AppRouters.verifyOtp, extra: {
            "phone": _countryCode + _phoneController.text.trim(),
            "isForgetPassword": true
          });
        }
      },
      builder: (context, state) {
        return DefaultButtonWidget(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _forgetPasswordBloc.forgetPassword(_countryCode + _phoneController.text.trim());
            }
          },
          text: AppStrings.sendCode.tr(),
          textColor: ColorManager.white,
          radius: 12.r,
          verticalPadding: 16.h,
          isLoading: state.status == Status.loading,
        );
      },
    );
  }
}
