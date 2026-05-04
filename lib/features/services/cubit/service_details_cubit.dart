import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/features/services/models/services_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceDetailsCubit extends Cubit<BaseState<ServiceDetailsModel>> {
  ServiceDetailsCubit() : super(const BaseState<ServiceDetailsModel>());

  Future<void> getServiceDetails(int id) async {
    emit(state.copyWith(status: Status.loading));

    final result = await DioHelper.getData<ServiceDetailsModel>(
      url: EndPoints.serviceDetails(id),
      fromJson: ServiceDetailsModel.fromJson,
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
