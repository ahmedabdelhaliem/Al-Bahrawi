import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_project/common/base/base_model.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/network/dio_helper.dart';
import 'package:base_project/common/network/end_points.dart';

class ContactUsCubit extends Cubit<BaseState<BaseModel>> {
  ContactUsCubit() : super(const BaseState<BaseModel>());

  Future<void> contactUs({
    required String name,
    required String phone,
    required String email,
    required String subject,
    required String message,
  }) async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.postData(url: EndPoints.contactUs, data: {
      'name': name,
      'phone': phone,
      'email': email,
      'subject': subject,
      'message': message,
    }, fromJson: BaseModel.fromJson);
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, errorMessage: failure.message, failure: failure)),
      (baseModel) => emit(state.copyWith(status: Status.success, data: baseModel)),
    );
  }
} 
