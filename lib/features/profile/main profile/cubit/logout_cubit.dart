import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_bahrawi/common/base/base_model.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';

class LogoutCubit extends Cubit<BaseState<BaseModel>> {
  LogoutCubit() : super(const BaseState<BaseModel>());

  Future<void> logout({bool isDelete = false}) async {
    isDelete ? emit(state.copyWith(status: Status.custom)) : emit(state.copyWith(status: Status.loading));
    final result =
    isDelete ? await DioHelper.deleteData(url: EndPoints.deleteAccount, fromJson: BaseModel.fromJson)
        : await DioHelper.postData(url: EndPoints.logout,data: {}, fromJson: BaseModel.fromJson);
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
      (success) => emit(state.copyWith(status: Status.success)),
    );
  }
} 
