import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:base_project/app/app_prefs.dart';
import 'package:base_project/app/di.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/network/dio_helper.dart';
import 'package:base_project/common/network/end_points.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_project/common/resources/values_manager.dart';
import 'package:base_project/features/auth/login/models/login_model.dart';
import 'package:base_project/local_notification_and_token.dart';

class VerifyOtpCubit extends Cubit<BaseState<LoginModel>> {
  VerifyOtpCubit() : super(const BaseState<LoginModel>());

  Future<void> verifyOtp(String phone, String otp, bool isForgetPassword) async {
    emit(state.copyWith(status: Status.loading));
    final result =await DioHelper.postData<LoginModel>(url: isForgetPassword ? EndPoints.verifyOTPForgetPassword : EndPoints.verifyOTP, data: {
      "phone": phone,
      "token": otp,
      if(!isForgetPassword ) "fcm_token": fcmToken
    }, fromJson: LoginModel.fromJson);
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
          (loginModel) async {
            if(!isForgetPassword) {
              await Future.wait([
                instance<AppPreferences>().saveUserName(loginModel.data?.user?.name??''),
                if(loginModel.data?.user?.image != null) instance<AppPreferences>().saveUserImage(loginModel.data!.user!.image!),
                instance<AppPreferences>().setUserId(loginModel.data?.user?.id??0),
                instance<AppPreferences>().setMobile(loginModel.data?.user?.phone??''),
                instance<AppPreferences>().setEmail(loginModel.data?.user?.email??''),
                if(loginModel.data?.token != null) instance<AppPreferences>().saveToken(loginModel.data!.token!),
                if(loginModel.data?.user?.role != null) instance<AppPreferences>().setRole((loginModel.data!.user!.role!)),
              ]);
              if(loginModel.data?.user?.role != null) userRole = loginModel.data!.user!.role!;
              registerUserInFirebase();
            }
            emit(state.copyWith(status: Status.success,data: loginModel));
          },
    );
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
}
