import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_project/common/base/base_model.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/network/dio_helper.dart';
import 'package:base_project/common/network/end_points.dart';

class UpdateProfileCubit extends Cubit<BaseState<BaseModel>> {
  UpdateProfileCubit() : super(const BaseState<BaseModel>());

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

    final result = await DioHelper.postData<BaseModel>(
      url: EndPoints.updateProfile,
      data: FormData.fromMap(dataToSend),
      fromJson: BaseModel.fromJson,
    );
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, errorMessage: failure.message, failure: failure)),
          (baseModel) => emit(state.copyWith(status: Status.success, data: baseModel)),
    );
  }
}
