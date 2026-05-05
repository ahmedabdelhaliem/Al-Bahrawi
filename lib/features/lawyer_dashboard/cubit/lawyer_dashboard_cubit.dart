import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/features/lawyer_dashboard/models/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LawyerDashboardCubit extends Cubit<BaseState<TaskResponse>> {
  LawyerDashboardCubit() : super(const BaseState<TaskResponse>());

  Future<void> getTasks({int page = 1}) async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.getData<TaskResponse>(
      url: EndPoints.lawyerTasks,
      query: {"page": page},
      fromJson: TaskResponse.fromJson,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, errorMessage: failure.message)),
      (response) => emit(state.copyWith(status: Status.success, data: response)),
    );
  }
}
