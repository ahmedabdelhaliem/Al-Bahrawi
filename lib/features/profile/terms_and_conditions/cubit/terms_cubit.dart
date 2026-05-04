import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/features/profile/terms_and_conditions/model/terms_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermsCubit extends Cubit<BaseState<TermsModel>> {
  TermsCubit() : super(const BaseState<TermsModel>());

  Future<void> getTerms() async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.getData<TermsModel>(
      url: EndPoints.terms,
      fromJson: TermsModel.fromJson,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, errorMessage: failure.message)),
      (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
