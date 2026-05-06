import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/features/home/models/statistics_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<BaseState<StatisticsModel>> {
  HomeCubit() : super(const BaseState<StatisticsModel>());

  Future<void> getStatistics() async {
    emit(state.copyWith(status: Status.loading));

    final result = await DioHelper.getData<StatisticsModel>(
      url: EndPoints.statistics,
      fromJson: StatisticsModel.fromJson,
    );

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ));
        }
      },
      (success) {
        if (!isClosed) {
          emit(state.copyWith(
            status: Status.success,
            data: success,
          ));
        }
      },
    );
  }
}
