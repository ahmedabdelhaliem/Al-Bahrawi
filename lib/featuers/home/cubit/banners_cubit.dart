import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/network/dio_helper.dart';
import 'package:base_project/common/network/end_points.dart';
import 'package:base_project/featuers/home/model/banners_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannersCubit extends Cubit<BaseState<BannersModel>> {
  BannersCubit() : super(const BaseState<BannersModel>());

  Future<void> getBanners() async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.getData(
      url: EndPoints.banners,
      fromJson: BannersModel.fromJson,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message,),),
      (success) => emit(state.copyWith(status: Status.success, data: success)),
    );
  }
}
