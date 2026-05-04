import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/features/profile/main%20profile/model/about_us_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutUsCubit extends Cubit<BaseState<AboutUsModel>> {
  AboutUsCubit() : super(const BaseState<AboutUsModel>());

  Future<void> getAboutUs() async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.getData<AboutUsModel>(
      url: EndPoints.about,
      fromJson: AboutUsModel.fromJson,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, errorMessage: failure.message)),
      (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
