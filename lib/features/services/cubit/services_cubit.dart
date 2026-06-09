import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/features/services/models/services_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicesCubit extends Cubit<BaseState<ServicesModel>> {
  ServicesCubit() : super(const BaseState<ServicesModel>());

  Future<void> getServices({int? serviceTypeId, String? search}) async {
    emit(state.copyWith(status: Status.loading));

    final Map<String, dynamic> query = {};
    if (serviceTypeId != null && serviceTypeId != 0) {
      query['service_type_id'] = serviceTypeId;
    }
    if (search != null && search.isNotEmpty) {
      query['search'] = search;
    }

    final result = await DioHelper.getData<ServicesModel>(
      url: EndPoints.services,
      query: query,
      fromJson: ServicesModel.fromJson,
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
          // Extract unique service types on initial load (when no serviceTypeId query filter is set)
          List<ServiceTypeModel> serviceTypes = [];
          if (serviceTypeId == null && (search == null || search.isEmpty)) {
            final seenIds = <int>{};
            final list = success.data ?? [];
            for (var service in list) {
              final type = service.serviceType;
              if (type != null && type.id != null && !seenIds.contains(type.id)) {
                seenIds.add(type.id!);
                serviceTypes.add(type);
              }
            }
          } else {
            // Keep existing categories if currently filtering
            serviceTypes = List<ServiceTypeModel>.from(state.metadata['serviceTypes'] ?? []);
          }

          emit(state.copyWith(
            status: Status.success,
            data: success,
            metadata: {
              ...state.metadata,
              'serviceTypes': serviceTypes,
            },
          ));
        }
      },
    );
  }
}
