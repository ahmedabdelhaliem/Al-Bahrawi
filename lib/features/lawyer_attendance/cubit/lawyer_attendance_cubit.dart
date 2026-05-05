import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/features/lawyer_attendance/models/attendance_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LawyerAttendanceCubit extends Cubit<BaseState<AttendanceModel>> {
  LawyerAttendanceCubit() : super(const BaseState<AttendanceModel>());

  Future<void> markAttendance({
    required String action,
    required String location,
    String notes = "",
  }) async {
    emit(state.copyWith(status: Status.loading));

    final result = await DioHelper.postData<AttendanceModel>(
      url: EndPoints.employeeAttendance,
      data: {
        "action": action,
        "location": location,
        "notes": notes,
      },
      fromJson: AttendanceModel.fromJson,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        errorMessage: failure.message,
      )),
      (success) => emit(state.copyWith(
        status: Status.success,
        data: success,
      )),
    );
  }
}
