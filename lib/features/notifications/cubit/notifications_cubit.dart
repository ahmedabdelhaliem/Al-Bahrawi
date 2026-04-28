import 'package:al_bahrawi/app/pagination_helper.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/either.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/common/network/failure.dart';
import 'package:al_bahrawi/features/notifications/models/notifications_model.dart';


class NotificationsCubit extends Cubit<BaseState<NotificationModel>> {
  NotificationsCubit()
      : super(const BaseState<NotificationModel>()) {
    _paginationHandler = PaginationHandler<NotificationModel, NotificationsCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  late final PaginationHandler<NotificationModel, NotificationsCubit> _paginationHandler;

  Future<void> loadFirstNotificationsPage() async {
    await _paginationHandler.loadFirstPage(
          (page, limit, [params]) => getNotifications(),
    );
  }

  Future<void> loadMoreNotificationsPage() async {
    await _paginationHandler.fetchData(
          (page, limit, [params]) => getNotifications(),
    );
  }

  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    final response = await DioHelper.getData<NotificationsModel>(
      url: EndPoints.notifications,
      fromJson: NotificationsModel.fromJson,
    );
    return response.fold(
          (failure)=> Left(failure),
          (success)=> Right(success.notifications),
    );
  }
}
