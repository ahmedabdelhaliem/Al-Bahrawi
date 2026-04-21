import 'package:base_project/common/base/base_model.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/network/dio_helper.dart';
import 'package:base_project/common/network/end_points.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordCubit extends Cubit<BaseState<BaseModel>> {
  ForgetPasswordCubit() : super(const BaseState<BaseModel>());

  Future<void> forgetPassword(String email) async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.postData(url: EndPoints.forgetPassword, data: {
      "email": email,
    }, fromJson: BaseModel.fromJson);
    result.fold(
            (l) => emit(state.copyWith(failure: l, status: Status.failure, errorMessage: l.message)),
            (r) => emit(state.copyWith(status: Status.success)));
  }
}
