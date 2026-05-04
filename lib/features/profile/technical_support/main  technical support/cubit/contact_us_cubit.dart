import 'package:al_bahrawi/common/base/base_model.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUsCubit extends Cubit<BaseState<BaseModel>> {
  ContactUsCubit() : super(const BaseState<BaseModel>());

  Future<void> sendContactMessage({
    required String subject,
    required String message,
  }) async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.postData<BaseModel>(
      url: EndPoints.contactUs,
      data: {
        "subject": subject,
        "message": message,
      },
      fromJson: BaseModel.fromJson,
    );
    result.fold(
      (failure) => emit(state.copyWith(
          status: Status.failure, errorMessage: failure.message)),
      (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
