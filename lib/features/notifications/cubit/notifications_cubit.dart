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
    paginationHandler = PaginationHandler<NotificationModel, NotificationsCubit>(
      bloc: this,
      pageSize: 10,
    );
  }

  late final PaginationHandler<NotificationModel, NotificationsCubit> paginationHandler;

  Future<void> loadFirstNotificationsPage() async {
    await paginationHandler.loadFirstPage(
          (page, limit, [params]) => getNotifications(page: page),
    );
  }

  Future<void> loadMoreNotificationsPage() async {
    await paginationHandler.fetchData(
          (page, limit, [params]) => getNotifications(page: page),
    );
  }

  Future<Either<Failure, List<NotificationModel>>> getNotifications({required int page}) async {
    final response = await DioHelper.getData<NotificationsModel>(
      url: "${EndPoints.notifications}?page=$page",
      fromJson: NotificationsModel.fromJson,
    );
    return response.fold(
          (failure)=> Left(failure),
          (success)=> Right(success.notifications),
    );
  }

  /// Mark a single notification as read (optimistic update).
  Future<void> markAsRead(String notificationId) async {
    // Optimistic UI: set read_at to now immediately
    final updatedItems = state.items.map((n) {
      if (n.id == notificationId) {
        return n.copyWithRead(DateTime.now().toIso8601String());
      }
      return n;
    }).toList();
    emit(state.copyWith(items: updatedItems));

    // Fire & forget — call the API in background
    await DioHelper.putData<dynamic>(
      url: EndPoints.markNotificationRead(notificationId),
      data: {},
      fromJson: (json) => json,
    );
  }
}
