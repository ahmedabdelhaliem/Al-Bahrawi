import 'package:al_bahrawi/app/app_functions.dart';
import 'package:al_bahrawi/common/base/base_model.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
import 'package:al_bahrawi/common/widgets/default_form_field.dart';
import 'package:al_bahrawi/features/auth/reset_password/bloc/reset_password_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordView extends StatefulWidget {
  final String phone;
  const ResetPasswordView({super.key, required this.phone});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      "تعيين كلمة مرور جديدة",
                      style: getBoldStyle(fontSize: 22.sp, color: const Color(0xff4a5677)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "يرجى إدخال كلمة المرور الجديدة الخاصة بك",
                      style: getRegularStyle(fontSize: 13.sp, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30.h),

                    _fieldLabel("كلمة المرور الجديدة"),
                    DefaultFormField(
                      controller: _passwordController,
                      fillColor: ColorManager.white,
                      borderColor: ColorManager.greyBorder,
                      borderRadius: 12.r,
                      hintText: "ادخل كلمة المرور",
                      obscureText: true,
                      suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                    ),

                    SizedBox(height: 15.h),

                    _fieldLabel("تأكيد كلمة المرور"),
                    DefaultFormField(
                      controller: _confirmPasswordController,
                      fillColor: ColorManager.white,
                      borderColor: ColorManager.greyBorder,
                      borderRadius: 12.r,
                      hintText: "اعد كتابة كلمة المرور",
                      obscureText: true,
                      suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                    ),

                    SizedBox(height: 30.h),
                    _resetPasswordButton(context),

                    SizedBox(height: 15.h),
                    TextButton(
                      onPressed: () => context.go(AppRouters.login),
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

  Widget _resetPasswordButton(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: BlocConsumer<ResetPasswordCubit, BaseState<BaseModel>>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == Status.failure) {
            AppFunctions.showsToast(state.errorMessage!, ColorManager.red, context);
          }
          if (state.status == Status.success) {
            AppFunctions.showsToast(state.data?.message ?? '', ColorManager.successGreen, context);
            context.go(AppRouters.resetPasswordSuccess);
          }
        },
        builder: (context, state) {
          return DefaultButtonWidget(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                context.read<ResetPasswordCubit>().resetPassword(
                      widget.phone,
                      _passwordController.text.trim(),
                      _confirmPasswordController.text.trim(),
                    );
              }
            },
            text: AppStrings.save.tr(),
            textColor: ColorManager.white,
            radius: 12.r,
            verticalPadding: 16.h,
            isLoading: state.status == Status.loading,
          );
        },
      ),
    );
  }
}
