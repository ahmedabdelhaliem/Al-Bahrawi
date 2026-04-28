import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/common/resources/assets_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/features/on_boarding/model/on_boarding_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<BaseState<OnBoardingModel>> {
  OnBoardingCubit() : super(const BaseState<OnBoardingModel>());

  Future<void> getOnBoarding() async {
    emit(state.copyWith(status: Status.loading));
    final result = await DioHelper.getData<OnBoardingModel>(
      url: EndPoints.onBoarding,
      fromJson: OnBoardingModel.fromJson,
    );
    result.fold(
      (failure) {
        // استخدم بيانات Mock محلية في حالة حدوث خطأ من الـ API
        final mockItems = _getMockOnBoardingItems();
        final localModel = OnBoardingModel(
          code: 200,
          message: 'local_onboarding',
          items: mockItems,
        );
        goNext(0, mockItems.length);
        emit(state.copyWith(status: Status.success, data: localModel));
      },
      (success) {
        // لو الـ API رجّع داتا فاضية، برضه نستخدم الـ Mock
        if (success.items.isEmpty) {
          final mockItems = _getMockOnBoardingItems();
          final localModel = success.copyWith(data: mockItems);
          goNext(0, mockItems.length);
          emit(state.copyWith(status: Status.success, data: localModel));
        } else {
          goNext(0, success.items.length);
          emit(state.copyWith(status: Status.success, data: success));
        }
      },
    );
  }

  bool isLast = false;
  int currentIndex = 0;

  goNext(int index,int length) {
    currentIndex = index;
    emit(UpdateOnBoardingLoadingState());
    if (index == length - 1) {
      isLast = true;
    } else {
      isLast = false;
    }
    emit(UpdateOnBoardingState());
  }

  List<OnBoardingItemModel> _getMockOnBoardingItems() {
    return [
      OnBoardingItemModel(
        banner: null,
        title: AppStrings.onBoardingTitle1.tr(),
        description: AppStrings.onBoardingDesc1.tr(),
        image: ImageAssets.onBoarding1,
      ),
      OnBoardingItemModel(
        banner: null,
        title: AppStrings.onBoardingTitle2.tr(),
        description: AppStrings.onBoardingDesc2.tr(),
        image: ImageAssets.onBoarding2,
      ),
      OnBoardingItemModel(
        banner: null,
        title: AppStrings.onBoardingTitle3.tr(),
        description: AppStrings.onBoardingDesc3.tr(),
        image: ImageAssets.onBoarding3,
      ),
    ];
  }
}
