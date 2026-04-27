import 'package:base_project/app/app_prefs.dart';
import 'package:base_project/app/di.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/default_button_widget.dart';
import 'package:base_project/features/on_boarding/cubit/on_boarding_cubit.dart';
import 'package:base_project/features/on_boarding/model/on_boarding_model.dart';
import 'package:base_project/features/on_boarding/view/widgets/on_boarding_clipper.dart';
import 'package:base_project/features/on_boarding/view/widgets/on_boarding_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  PageController onBoardingController = PageController();
  late OnBoardingCubit _onBoardingCubit;
  List<OnBoardingItemModel> _getMockOnBoardingItems() {
    return [
      OnBoardingItemModel(
        banner: null,
        title: '',
        description: AppStrings.onBoardingDesc1.tr(),
        image: ImageAssets.logo,
      ),
      OnBoardingItemModel(
        banner: null,
        title: AppStrings.onBoardingTitle2.tr(),
        description: AppStrings.onBoardingDesc2.tr(),
        image: ImageAssets.logo,
      ),
      OnBoardingItemModel(
        banner: null,
        title: AppStrings.onBoardingTitle3.tr(),
        description: AppStrings.onBoardingDesc3.tr(),
        image: ImageAssets.logo,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    instance<AppPreferences>().setOnBoardingScreenViewed();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<OnBoardingCubit>(),
      // create: (context) => instance<OnBoardingCubit>()..getOnBoarding(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            ClipPath(
              clipper: OnBoardingClipper(),
              child: Container(
                height: 0.35.sh, // Responsive height (35% of screen height)
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorManager.primary,
                      ColorManager.blue,
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<OnBoardingCubit, BaseState<OnBoardingModel>>(
              builder: (context, state) {
                _onBoardingCubit = instance<OnBoardingCubit>();
                if (state.status == Status.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    if (state.status == Status.failure)
                      Expanded(child: Center(child: Text(state.errorMessage ?? '')))
                    else ...[
                      _onBoardingData(_getMockOnBoardingItems()),
                      SizedBox(height: 16.h),
                      _indicator(_getMockOnBoardingItems().length),
                    ],
                    SizedBox(height: 24.h),
                    _startButton(),
                    SizedBox(height: 24.h),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _onBoardingData(List<OnBoardingItemModel> items) {
    return Expanded(
      flex: 2,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        controller: onBoardingController,
        onPageChanged: (int index) {
          _onBoardingCubit.goNext(index, items.length);
        },
        itemBuilder: (context, index) => OnBoardingWidget(item: items[index]),
        itemCount: items.length,
      ),
    );
  }

  _indicator(int length) {
    return SmoothPageIndicator(
      controller: onBoardingController,
      effect: WormEffect(
        dotColor: ColorManager.lightColor,
        dotHeight: 6.w,
        dotWidth: 6.w,
        spacing: 3.0.w,
        activeDotColor: ColorManager.primary,
      ),
      count: length,
    );
  }

  _startButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: _onBoardingCubit.isLast
          ? DefaultButtonWidget(
              onPressed: () {
                // context.go(AppRouters.btmNav);
                context.go(AppRouters.login);
              },
              text: AppStrings.startNow.tr(),
              gradient: ColorManager.primaryGradient,
              textColor: ColorManager.white,
              radius: 40.r,
              verticalPadding: 16.h,
            )
          : DefaultButtonWidget(
              onPressed: () {
                if (!_onBoardingCubit.isLast) {
                  onBoardingController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                } else {
                  onBoardingController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              text: AppStrings.next.tr(),
              gradient: ColorManager.primaryGradient,
              textColor: ColorManager.white,
              verticalPadding: 16.h,
              radius: 40.r,
            ),
    );
  }

  _skipButton() {
    return DefaultButtonWidget(
      onPressed: () {
        context.go(AppRouters.btmNav);
      },
      text: "\t\t${AppStrings.skip.tr()}",
      elevation: 0,
      radius: 8.r,
      textStyle: getLightStyle(fontSize: 12.sp, color: ColorManager.black),
    );
  }
}
