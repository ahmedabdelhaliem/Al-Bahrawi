import 'package:go_router/go_router.dart';
import 'package:base_project/app/app_functions.dart';
import 'package:base_project/common/base/base_model.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_app_bar.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:base_project/common/widgets/default_form_field.dart';
import 'package:base_project/features/auth/forget_password/bloc/forget_password_cubit.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/features/auth/login/view/widgets/auth_logo_widget.dart';

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
          backgroundColor: ColorManager.white,
          appBar: const DefaultAppBar(height: 0),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              children: [
                SizedBox(height: 40.h),
                const AuthLogoWidget(),
                SizedBox(height: 32.h),
                Text(
                  AppStrings.forgotPassword.tr(),
                  style: getBoldStyle(
                    fontSize: 22.sp,
                    color: ColorManager.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  AppStrings.enterYourPhoneNumber.tr(),
                  style: getRegularStyle(
                    fontSize: 13.sp,
                    color: ColorManager.greyTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                DefaultFormField(
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  fillColor: ColorManager.white,
                  borderColor: ColorManager.greyBorder,
                  borderRadius: 12.r,
                  hintText: AppStrings.phoneNumber.tr(),
                  title: AppStrings.phoneNumber.tr(),
                ),
                SizedBox(height: 40.h),
                _activeAccountContent(),
              ],
            ),
          ),
        );
      }),
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
            "phone": _phoneController.text.trim(),
            "isForgetPassword": true
          });
        }
      },
      builder: (context, state) {
        return DefaultButtonWidget(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _forgetPasswordBloc.forgetPassword(_phoneController.text.trim());
            }
          },
          text: AppStrings.sendCode.tr(),
          gradient: ColorManager.primaryGradient,
          textColor: ColorManager.white,
          radius: 40.r,
          verticalPadding: 14.h,
          isLoading: state.status == Status.loading,
        );
      },
    );
  }
}
