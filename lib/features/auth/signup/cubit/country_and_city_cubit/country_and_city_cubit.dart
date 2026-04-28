import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/features/auth/signup/models/countries_cities_model.dart';

class CountriesCitiesCubit extends Cubit<BaseState<CountriesCitiesModel>> {
  CountriesCitiesCubit() : super(const BaseState<CountriesCitiesModel>());

   Future<void> getCountriesCities() async {
    emit(state.copyWith(status: Status.loading,));

    final result = await DioHelper.getData<CountriesCitiesModel>(
        url: EndPoints.countries,
        fromJson: CountriesCitiesModel.fromJson,
    );
    result.fold(
      (l) => emit(state.copyWith(status: Status.failure,failure: l)),
      (r) => emit(state.copyWith(status: Status.success,data: r)),
    );
  }

}
