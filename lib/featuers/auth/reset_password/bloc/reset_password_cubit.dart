import 'package:base_project/common/base/base_model.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/network/dio_helper.dart';
import 'package:base_project/common/network/end_points.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<BaseState<BaseModel>> {
  ResetPasswordCubit() : super(const BaseState<BaseModel>());

  Future<void> resetPassword(
    String email,
    String password,
    String passwordConfirmation,
    // String otp,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.postData(
      url: EndPoints.resetPassword,
      data: {
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        // "otp": otp,
      },
      fromJson: BaseModel.fromJson,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
