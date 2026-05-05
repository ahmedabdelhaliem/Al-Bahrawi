import 'package:al_bahrawi/app/app_prefs.dart';
import 'package:al_bahrawi/app/di.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_bahrawi/common/resources/values_manager.dart';
import 'package:al_bahrawi/features/auth/login/models/login_model.dart';
import 'package:al_bahrawi/local_notification_and_token.dart';

class VerifyOtpCubit extends Cubit<BaseState<LoginModel>> {
  VerifyOtpCubit() : super(const BaseState<LoginModel>());

  Future<void> verifyOtp(String phone, String otp, bool isForgetPassword) async {
    emit(state.copyWith(status: Status.loading));

    // Fetch FCM token with fallback (same pattern as LoginCubit)
    String? currentFcmToken = fcmToken;
    if (!isForgetPassword && currentFcmToken == null) {
      try {
        currentFcmToken = await FirebaseMessaging.instance.getToken();
        if (currentFcmToken != null) fcmToken = currentFcmToken;
      } catch (e) {
        debugPrint('Failed to fetch FCM Token in OTP: $e');
      }
    }
    debugPrint('FCM Token to be sent with OTP: $currentFcmToken');

    final result = await DioHelper.postData<LoginModel>(url: isForgetPassword ? EndPoints.verifyOTPForgetPassword : EndPoints.verifyOTP, data: {
      "phone": phone,
      "token": otp,
      if(!isForgetPassword) "fcm_token": currentFcmToken
    }, fromJson: LoginModel.fromJson);
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
          (loginModel) async {
            if(!isForgetPassword) {
              await Future.wait<void>([
                instance<AppPreferences>().saveUserName(loginModel.data?.user?.name ?? ''),
                if (loginModel.data?.user?.image != null)
                  instance<AppPreferences>().saveUserImage(loginModel.data!.user!.image!),
                instance<AppPreferences>().setUserId(loginModel.data?.user?.id ?? 0),
                instance<AppPreferences>().setMobile(loginModel.data?.user?.phone ?? ''),
                instance<AppPreferences>().setEmail(loginModel.data?.user?.email ?? ''),
                if (loginModel.data?.token != null)
                  instance<AppPreferences>().saveToken(loginModel.data!.token!),
                if (loginModel.data?.user?.role != null)
                  instance<AppPreferences>().setUserRole((loginModel.data!.user!.role!)),
              ]);
              if(loginModel.data?.user?.role != null) userRole = loginModel.data!.user!.role!;
            }
            emit(state.copyWith(status: Status.success, data: loginModel));
          },
    );
  }
}
