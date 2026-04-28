import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/features/privacy_policy/models/privacy_policy_model.dart';
import 'package:al_bahrawi/features/privacy_policy/view/privacy_policy_view.dart';


class PrivacyPolicyCubit extends Cubit<BaseState<PrivacyPolicyModel>> {
  PrivacyPolicyCubit() : super(const BaseState<PrivacyPolicyModel>());

  Future<void> privacyPolicy({
    required InfoType type,
}) async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.getData(url: type == InfoType.aboutUs ? EndPoints.about : type == InfoType.privacyPolicy ? EndPoints.privacyPolicy : EndPoints.terms, fromJson: PrivacyPolicyModel.fromJson);
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
          (success) => emit(state.copyWith(status: Status.success,data: success)),
    );
  }
}
