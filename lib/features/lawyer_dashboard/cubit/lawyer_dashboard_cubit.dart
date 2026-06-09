import 'package:al_bahrawi/app/pagination_helper.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/either.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/common/network/failure.dart';
import 'package:al_bahrawi/features/lawyer_dashboard/models/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LawyerDashboardCubit extends Cubit<BaseState<TaskModel>> {
  LawyerDashboardCubit() : super(const BaseState<TaskModel>()) {
    paginationHandler = PaginationHandler<TaskModel, LawyerDashboardCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  late final PaginationHandler<TaskModel, LawyerDashboardCubit> paginationHandler;

  Future<void> loadFirstTasksPage() async {
    await paginationHandler.loadFirstPage(
      (page, limit, [params]) => getTasks(page: page),
    );
  }

  Future<void> loadMoreTasksPage() async {
    await paginationHandler.fetchData(
      (page, limit, [params]) => getTasks(page: page),
    );
  }

  Future<Either<Failure, List<TaskModel>>> getTasks({required int page}) async {
    final result = await DioHelper.getData<TaskResponse>(
      url: EndPoints.lawyerTasks,
      query: {"page": page},
      fromJson: TaskResponse.fromJson,
    );
    return result.fold(
      (failure) => Left(failure),
      (success) => Right(success.data),
    );
  }
}
