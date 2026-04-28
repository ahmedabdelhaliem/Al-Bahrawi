import 'package:al_bahrawi/common/base/base_model.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResendOtpCubit extends Cubit<BaseState<BaseModel>> {
  ResendOtpCubit() : super(const BaseState<BaseModel>());

  Future<void> resendOtp(String phone, bool isForgetPassword) async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.postData(url: isForgetPassword ? EndPoints.resendOTPForgetPassword : EndPoints.resendOTP, data: {
      "phone": phone
    }, fromJson: BaseModel.fromJson);
    result.fold(
      (l) => emit(state.copyWith(failure: l, status: Status.failure,errorMessage: l.message)),
      (r) => emit(state.copyWith(status: Status.success,data: r)),
    );
  }
}
