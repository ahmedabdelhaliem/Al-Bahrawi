import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/features/profile/technical_support/common%20question/model/faq_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaqCubit extends Cubit<BaseState<FaqResponseModel>> {
  FaqCubit() : super(const BaseState<FaqResponseModel>());

  Future<void> getFaqs() async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.getData<FaqResponseModel>(
      url: EndPoints.faqs,
      fromJson: FaqResponseModel.fromJson,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, errorMessage: failure.message)),
      (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
