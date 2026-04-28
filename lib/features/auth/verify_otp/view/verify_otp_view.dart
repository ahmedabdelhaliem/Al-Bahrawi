import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:al_bahrawi/app/app_functions.dart';
import 'package:al_bahrawi/common/base/base_model.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_app_bar.dart';
import 'package:al_bahrawi/features/auth/login/view/widgets/auth_logo_widget.dart';
import 'package:al_bahrawi/features/auth/verify_otp/bloc/resend_otp/resend_otp_cubit.dart';
import 'package:al_bahrawi/features/auth/verify_otp/bloc/verify_otp/verify_otp_bloc.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
import 'package:pinput/pinput.dart';

const int _resendCooldownSeconds = 120;

class VerifyOtpView extends StatefulWidget {
  final String phone;
  final bool isForgetPassword;
  final bool isSignup;

  const VerifyOtpView({
    super.key,
    required this.phone,
    required this.isForgetPassword,
    this.isSignup = false,
  });

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  final TextEditingController _pinController = TextEditingController();
  late VerifyOtpCubit _verifyOtpCubit;
  late ResendOtpCubit _resendOtpCubit;

  int _remainingSeconds = _resendCooldownSeconds;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() => _remainingSeconds = _resendCooldownSeconds);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() => _remainingSeconds = 0);
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  bool get _canResend => _remainingSeconds == 0;

  String get _formattedCountdown {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VerifyOtpCubit()),
        BlocProvider(create: (_) => ResendOtpCubit()),
      ],
      child: Builder(
        builder: (context) {
          _verifyOtpCubit = context.read<VerifyOtpCubit>();
          _resendOtpCubit = context.read<ResendOtpCubit>();
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "تأكيد الرمز",
                          style: getBoldStyle(fontSize: 22.sp, color: const Color(0xff4a5677)),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "أدخل رمز التحقق المرسل إلى",
                          style: getRegularStyle(fontSize: 13.sp, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          widget.phone,
                          style: getBoldStyle(fontSize: 15.sp, color: ColorManager.primary),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: 30.h),
                        _buildOtpField(context),
                        
                        SizedBox(height: 30.h),
                        _buildVerifyListener(),
                        
                        SizedBox(height: 15.h),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            "تعديل رقم الهاتف",
                            style: getBoldStyle(fontSize: 14.sp, color: ColorManager.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtpField(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 60.h,
      textStyle: getBoldStyle(fontSize: 22.sp, color: ColorManager.primary),
      decoration: BoxDecoration(
        color: ColorManager.white,
        border: Border.all(
          color: ColorManager.greyBorder,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: ColorManager.primary, width: 1.5),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Pinput(
          length: 4, // Changed to 4 as per screenshot
          keyboardType: TextInputType.number,
          controller: _pinController,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          separatorBuilder: (index) => SizedBox(width: 16.w),
          onCompleted: (code) {
            _verifyOtpCubit.verifyOtp(
              widget.phone,
              code,
              widget.isForgetPassword,
            );
          },
        ),
      ),
    );
  }

  Widget _buildVerifyListener() {
    return BlocConsumer<VerifyOtpCubit, BaseState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == Status.failure) {
          AppFunctions.showsToast(
            state.errorMessage ?? '',
            ColorManager.red,
            context,
          );
        }
        if (state.status == Status.success) {
          if (widget.isForgetPassword) {
            context.push(
              AppRouters.resetPassword,
              extra: {
                'email': widget.phone,
              },
            );
          } else if (widget.isSignup) {
            context.go(AppRouters.signupLocation);
          } else {
            context.go(AppRouters.btmNav, extra: {"refreshKey": UniqueKey()});
          }
        }
      },
      builder: (context, verifyState) {
        return BlocConsumer<ResendOtpCubit, BaseState<BaseModel>>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == Status.failure) {
              AppFunctions.showsToast(
                state.errorMessage ?? '',
                ColorManager.red,
                context,
              );
            }
            if (state.status == Status.success) {
              AppFunctions.showsToast(
                state.data?.message ?? '',
                ColorManager.successGreen,
                context,
              );
              _startCountdown();
            }
          },
          builder: (context, resendState) {
            return Column(
              children: [
                DefaultButtonWidget(
                  onPressed: () {
                    context.push(AppRouters.signupSuccess);
                    // if (_pinController.text.length == 4) {
                    //   _verifyOtpCubit.verifyOtp(
                    //     widget.phone,
                    //     _pinController.text,
                    //     widget.isForgetPassword,
                    //   );
                    // }
                  },
                  text: AppStrings.verifyCode.tr(),
                  textColor: ColorManager.white,
                  radius: 12.r,
                  verticalPadding: 16.h,
                  isLoading: verifyState.status == Status.loading,
                ),
                SizedBox(height: 24.h),
                _buildResendSection(
                  isLoading: resendState.status == Status.loading,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildResendSection({required bool isLoading}) {
    return _canResend
        ? InkWell(
            onTap: isLoading
                ? null
                : () => _resendOtpCubit.resendOtp(
                      widget.phone,
                      widget.isForgetPassword,
                    ),
            child: Text(
              AppStrings.resendCode.tr(),
              style: getSemiBoldStyle(
                fontSize: 14.sp,
                color: ColorManager.primary,
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.resendIn.tr(),
                style: getRegularStyle(
                  fontSize: 13.sp,
                  color: ColorManager.greyTextColor,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                _formattedCountdown,
                style: getBoldStyle(
                  fontSize: 14.sp,
                  color: ColorManager.primary,
                ),
              ),
            ],
          );
  }
}
