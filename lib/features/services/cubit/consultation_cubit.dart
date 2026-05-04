import 'dart:io';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:dio/dio.dart';
import 'package:al_bahrawi/features/services/models/consultation_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationCubit extends Cubit<BaseState<dynamic>> {
  ConsultationCubit() : super(const BaseState<dynamic>());

  Future<void> requestConsultation({
    required int serviceId,
    required String type,
    required String description,
    File? file,
  }) async {
    emit(state.copyWith(status: Status.loading));

    final Map<String, dynamic> data = {
      'service_id': serviceId,
      'consultation_type': type,
      'description': description,
    };

    if (file != null) {
      data['file'] = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(data);

    final result = await DioHelper.postData<dynamic>(
      url: EndPoints.requestConsultation,
      data: formData,
      fromJson: (json) => json,
    );

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            status: Status.failure,
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

  Future<void> getConsultations() async {
    emit(state.copyWith(status: Status.loading));

    final result = await DioHelper.getData<ConsultationsResponseModel>(
      url: EndPoints.requestConsultation,
      fromJson: ConsultationsResponseModel.fromJson,
    );

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            status: Status.failure,
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
