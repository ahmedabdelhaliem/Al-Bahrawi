import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_project/app/app_prefs.dart';
import 'package:base_project/app/di.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/network/dio_helper.dart';
import 'package:base_project/common/network/end_points.dart';
import 'package:base_project/features/auth/signup/models/signup_model.dart';

class ProfileCubit extends Cubit<BaseState<SignupModel>> {
  ProfileCubit() : super(const BaseState<SignupModel>());

  Future<void> fetchProfile() async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.getData<SignupModel>(url: EndPoints.profile, fromJson: SignupModel.fromJson);
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, errorMessage: failure.message, failure: failure)),
      (profile) {
        if(profile.user?.name != null) instance<AppPreferences>().saveUserName(profile.user!.name!);
        if(profile.user?.phone != null) instance<AppPreferences>().setMobile(profile.user!.phone!);
        if(profile.user?.image != null) instance<AppPreferences>().saveUserImage(profile.user!.image!);
        return emit(state.copyWith(status: Status.success, data: profile));
      },
    );
  }
} 
