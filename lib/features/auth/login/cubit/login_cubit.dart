import 'dart:io';
import 'package:al_bahrawi/app/di.dart' as FirebaseFirestore;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:al_bahrawi/app/app_prefs.dart';
import 'package:al_bahrawi/app/di.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_bahrawi/common/resources/values_manager.dart';
import 'package:al_bahrawi/features/auth/login/models/login_model.dart';
import 'package:al_bahrawi/local_notification_and_token.dart';

class LoginCubit extends Cubit<BaseState<LoginModel>> {
  LoginCubit() : super(const BaseState<LoginModel>());

  Future<void> login(String phone, String password) async {
    emit(state.copyWith(status: Status.loading));

    // Fetch the token directly if the global variable is null
    String? currentFcmToken = fcmToken;
    try {
      currentFcmToken ??= await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint("Failed to fetch FCM Token: $e");
    }
    
    debugPrint('FCM Token to be sent with login: $currentFcmToken');

    final result = await DioHelper.postData<LoginModel>(
      url: EndPoints.login,
      data: {
        "phone": phone,
        "password": password,
        "fcm_token": currentFcmToken,
      },
      fromJson: LoginModel.fromJson,
      isPublic: true,
    );
    result.fold(
      (failure) {
        debugPrint('❌ Login Failure: ${failure.message}');
        if (!isClosed) {
          emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message));
        }
      },
      (success) {
        debugPrint('✅ Login Success: ${success.message}');
        _handleLoginSuccess(success);
      },
    );
  }

  Future<void> firebaseLogin(String idToken) async {
    emit(state.copyWith(status: Status.loading));
    
    // Fetch the token directly if the global variable is null
    String? currentFcmToken = fcmToken;
    try {
      currentFcmToken ??= await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint("Failed to fetch FCM Token: $e");
    }

    debugPrint('FCM Token to be sent with Firebase Login: $currentFcmToken');

    final result = await DioHelper.postData<LoginModel>(
      url: EndPoints.firebaseLogin,
      data: {
        "id_token": idToken,
        "device_name": Platform.isAndroid ? "android" : "ios",
        "fcm_token": currentFcmToken,
      },
      fromJson: LoginModel.fromJson,
      isPublic: true,
    );
    result.fold(
      (failure) {
        debugPrint('❌ Firebase Login Failure: ${failure.message}');
        if (!isClosed) {
          emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message));
        }
      },
      (success) {
        debugPrint('✅ Firebase Login Success: ${success.message}');
        _handleLoginSuccess(success);
      },
    );
  }

  void _handleLoginSuccess(LoginModel success) {
    final user = success.data?.user;
    final token = success.data?.token;

    if (token != null) instance<AppPreferences>().saveToken(token);
    if (user != null) {
      if (user.name != null) instance<AppPreferences>().saveUserName(user.name!);
      if (user.phone != null) instance<AppPreferences>().setMobile(user.phone!);
      if (user.image != null) instance<AppPreferences>().saveUserImage(user.image!);
      if (user.id != null) instance<AppPreferences>().setUserId(user.id!);
      if (user.email != null) instance<AppPreferences>().setEmail(user.email!);
      if (user.isOfficeClient != null) instance<AppPreferences>().setIsOfficeClient(user.isOfficeClient!);
      if (user.role != null) {
        instance<AppPreferences>().setUserRole(user.role!);
      }
    }
    if (!isClosed) {
      emit(state.copyWith(status: Status.success, data: success));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.postData<dynamic>(
      url: EndPoints.logout,
      data: {},
      fromJson: (json) => json,
    );

    await instance<AppPreferences>().logout();

    result.fold(
      (failure) {
        if (!isClosed) emit(state.copyWith(status: Status.success));
      },
      (success) {
        if (!isClosed) emit(state.copyWith(status: Status.success));
      },
    );
  }
}
