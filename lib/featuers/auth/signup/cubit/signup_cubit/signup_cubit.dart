import 'package:dio/dio.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/network/dio_helper.dart';
import 'package:base_project/common/network/end_points.dart';
import 'package:base_project/featuers/auth/signup/models/signup_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCubit extends Cubit<BaseState<SignupModel>> {
  SignupCubit() : super(const BaseState<SignupModel>());

  Future<void> signup({
      required String name,
      required String email,
      required String phone,
      required String password,
      required String passwordConfirmation,
      required UserRole userRole,
      String? imagePath,
      int? countryId,
      int? cityId,
      String? workPlace,
      String? address,
      String? pickupPoint,
      int? governorateId,
      int? districtId,
}) async {
    emit(state.copyWith(status: Status.loading));

    FormData data = FormData.fromMap({
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "accept_terms": "1",
      "role": userRole == UserRole.captain ? 'seller' : 'buyer',
      if(imagePath != null) "image": await MultipartFile.fromFile(imagePath),
      if(countryId != null) "country_id": countryId,
      if(cityId != null) "city_id": cityId,
      if(workPlace != null) "work_place": workPlace,
      if(address != null) "address": address,
      if(pickupPoint != null) "pickup_point": pickupPoint,
      if(governorateId != null) "governorate_id": governorateId,
      if(districtId != null) "district_id": districtId,
    });



    final result = await DioHelper.postData<SignupModel>(url: EndPoints.signup,
        data: data, fromJson: SignupModel.fromJson);
    result.fold(
          (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message)),
          (success) => emit(state.copyWith(status: Status.success,data: success)),
    );
  }
}