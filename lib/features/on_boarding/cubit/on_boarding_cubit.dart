import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/network/dio_helper.dart';
import 'package:base_project/common/network/end_points.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/features/on_boarding/model/on_boarding_model.dart';
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

  goNext(int index,int length) {
    emit(UpdateOnBoardingLoadingState());
    if (index == length - 1) {
      isLast = true;
    } else {
      isLast = false;
    }
    emit(UpdateOnBoardingState());
  }

  List<OnBoardingItemModel> _getMockOnBoardingItems() {
    return const [
      OnBoardingItemModel(
        banner: null,
        title: 'مزايدة من هاتفك',
        description:
            '“ قدّم عروضك في ثوانٍ , تابع المزاد من أي مكان.\n تحكُّم كامل بدون حضور فعلي “',
        image: ImageAssets.onBoarding1,
      ),
      OnBoardingItemModel(
        banner: null,
        title: 'عروض مزايدة شفافة',
        description:
            ' “راقب ارتفاع الأسعار في الوقت الحقيقي\n اطّلع على تفاصيل كل سيارة قبل المزايدة\n اتخذ قرارك بثقة ووضوح  “',
        image: ImageAssets.onBoarding2,
      ),
      OnBoardingItemModel(
        banner: null,
        title: 'شارك في المزادات في أي وقت ومن أي مكان',
        description:
            '“ تابع أحدث المزادات مباشرة وشاهد السيارات المعروضة بوضوح،\n وشارك في المنافسة لحظة بلحظة بسهولة وسرعة “',
        image: ImageAssets.onBoarding3,
      ),
    ];
  }
}
