import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/features/home/models/statistics_model.dart';
import 'package:al_bahrawi/features/notifications/models/notifications_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<BaseState<StatisticsModel>> {
  HomeCubit() : super(const BaseState<StatisticsModel>());

  Future<void> getStatistics() async {
    emit(state.copyWith(status: Status.loading));

    final result = await DioHelper.getData<StatisticsModel>(
      url: EndPoints.statistics,
      fromJson: StatisticsModel.fromJson,
    );

    // Fetch the first page of notifications to check for unread notifications
    final notificationsResult = await DioHelper.getData<NotificationsModel>(
      url: "${EndPoints.notifications}?page=1",
      fromJson: NotificationsModel.fromJson,
    );

    bool hasUnread = false;
    notificationsResult.fold(
      (failure) {},
      (success) {
        hasUnread = success.notifications.any((n) => n.readAt == null);
      },
    );

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
            metadata: {'hasUnread': hasUnread},
          ));
        }
      },
      (success) {
        if (!isClosed) {
          emit(state.copyWith(
            status: Status.success,
            data: success,
            metadata: {'hasUnread': hasUnread},
          ));
        }
      },
    );
  }
}
