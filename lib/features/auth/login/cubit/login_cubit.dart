import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:al_bahrawi/app/app_prefs.dart';
import 'package:al_bahrawi/app/di.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_bahrawi/common/resources/values_manager.dart';
import 'package:al_bahrawi/features/auth/login/models/login_model.dart';
import 'package:al_bahrawi/local_notification_and_token.dart';

class LoginCubit extends Cubit<BaseState<LoginModel>> {
  LoginCubit() : super(const BaseState<LoginModel>());

  Future<void> login(String phone, String password) async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.postData<LoginModel>(
      url: EndPoints.login,
      data: {
        "phone": phone,
        "password": password,
        "fcm_token": fcmToken,
      },
      fromJson: LoginModel.fromJson,
    );
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message));
        }
      },
      (success) => _handleLoginSuccess(success),
    );
  }

  Future<void> firebaseLogin(String idToken) async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.postData<LoginModel>(
      url: EndPoints.firebaseLogin,
      data: {
        "id_token": idToken,
        "device_name": Platform.isAndroid ? "android" : "ios",
        "fcm_token": fcmToken,
      },
      fromJson: LoginModel.fromJson,
    );
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message));
        }
      },
      (success) => _handleLoginSuccess(success),
    );
  }

  void _handleLoginSuccess(LoginModel success) {
    if (success.data?.token != null) instance<AppPreferences>().saveToken(success.data!.token!);
    if (success.data?.user?.name != null) instance<AppPreferences>().saveUserName(success.data!.user!.name!);
    if (success.data?.user?.phone != null) instance<AppPreferences>().setMobile(success.data!.user!.phone!);
    if (success.data?.user?.image != null) instance<AppPreferences>().saveUserImage(success.data!.user!.image!);
    if (success.data?.user?.id != null) instance<AppPreferences>().setUserId((success.data!.user!.id!));
    if (success.data?.user?.role != null) {
      instance<AppPreferences>().setRole((success.data!.user!.role!));
      userRole = instance<AppPreferences>().getRole();
    }
    registerUserInFirebase();
    if (!isClosed) {
      emit(state.copyWith(status: Status.success, data: success));
    }
  }
  }

  Future<void> registerUserInFirebase() async
  {
    await FirebaseFirestore.instance.collection('users').doc(instance<AppPreferences>().getUserId().toString()).set({
      'id': instance<AppPreferences>().getUserId(),
      'name': instance<AppPreferences>().getUserName(),
      'image': instance<AppPreferences>().getUserImage(),
      'phone': instance<AppPreferences>().getMobile(),
    });
  }

