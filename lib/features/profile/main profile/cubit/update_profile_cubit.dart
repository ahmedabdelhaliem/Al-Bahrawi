import 'package:al_bahrawi/features/auth/login/models/login_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';

class UpdateProfileCubit extends Cubit<BaseState<LoginModel>> {
  UpdateProfileCubit() : super(const BaseState<LoginModel>());

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? image,
  }) async
  {
    emit(state.copyWith(status: Status.loading));

    Map<String, dynamic> dataToSend = {
      'name': name,
      'email': email,
      'phone': phone,
      if(image != null) 'image': await MultipartFile.fromFile(image),
    };

    final result = await DioHelper.postData<LoginModel>(
      url: EndPoints.updateProfile,
      data: FormData.fromMap(dataToSend),
      fromJson: LoginModel.fromJson,
    );
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, errorMessage: failure.message, failure: failure)),
          (loginModel) => emit(state.copyWith(status: Status.success, data: loginModel)),
    );
  }
}
