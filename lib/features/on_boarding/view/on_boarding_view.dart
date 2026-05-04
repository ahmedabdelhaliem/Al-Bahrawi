import 'package:al_bahrawi/app/app_prefs.dart';
import 'package:al_bahrawi/app/di.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/assets_manager.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
import 'package:al_bahrawi/features/on_boarding/cubit/on_boarding_cubit.dart';
import 'package:al_bahrawi/features/on_boarding/model/on_boarding_model.dart';
import 'package:al_bahrawi/features/on_boarding/view/widgets/on_boarding_clipper.dart';
import 'package:al_bahrawi/features/on_boarding/view/widgets/on_boarding_widget.dart';
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

  @override
  void initState() {
    super.initState();
    instance<OnBoardingCubit>().getOnBoarding();
    instance<AppPreferences>().setOnBoardingScreenViewed();
  }

  @override
  Widget build(BuildContext context) {
    _onBoardingCubit = instance<OnBoardingCubit>();
    return BlocProvider(
      create: (context) => _onBoardingCubit,
      child: Scaffold(
        backgroundColor: ColorManager.bg,
        body: BlocBuilder<OnBoardingCubit, BaseState<OnBoardingModel>>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = state.data?.items ?? [];

            if (items.isEmpty) {
              return const SizedBox.shrink();
            }

            return Stack(
              children: [
                // Image Section
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 0.65.sh,
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: onBoardingController,
                    onPageChanged: (int index) {
                      _onBoardingCubit.goNext(index, items.length);
                    },
                    itemBuilder: (context, index) =>
                        OnBoardingWidget(item: items[index]),
                    itemCount: items.length,
                  ),
                ),
                
                // Content Card
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(30.w, 40.h, 30.w, 30.h),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, -10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _indicator(items.length),
                        SizedBox(height: 35.h),
                        
                        // Animated Title & Description
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.1),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                )),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            key: ValueKey<int>(_onBoardingCubit.currentIndex),
                            children: [
                              Text(
                                items[_onBoardingCubit.currentIndex].title ?? '',
                                style: getBoldStyle(fontSize: 20.sp, color: ColorManager.textColor),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15.h),
                              Text(
                                items[_onBoardingCubit.currentIndex].description ?? '',
                                style: getRegularStyle(
                                  fontSize: 15.sp, 
                                  color: ColorManager.greyText,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 45.h),
                        
                        // Navigation Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _onBoardingCubit.isLast 
                              ? Expanded(
                                  child: DefaultButtonWidget(
                                    onPressed: () => context.go(AppRouters.login),
                                    text: AppStrings.requestConsultation.tr(),
                                    textColor: ColorManager.white,
                                    radius: 15.r,
                                    elevation: 4,
                                  ),
                                )
                              : _nextButton(),
                              
                            _skipButton(),
                          ],
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _indicator(int length) {
    return SmoothPageIndicator(
      controller: onBoardingController,
      effect: ExpandingDotsEffect(
        dotColor: ColorManager.greyBorder,
        activeDotColor: ColorManager.primary,
        dotHeight: 4.h,
        dotWidth: 12.w,
        expansionFactor: 1.1,
        spacing: 5.w,
      ),
      count: length,
    );
  }

  _nextButton() {
    return InkWell(
      onTap: () {
        onBoardingController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        width: 55.w,
        height: 55.w,
        decoration: BoxDecoration(
          color: ColorManager.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ColorManager.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back,
          color: ColorManager.white,
          size: 24,
        ),
      ),
    );
  }

  _skipButton() {
    return TextButton(
      onPressed: () => context.go(AppRouters.login),
      child: Text(
        _onBoardingCubit.isLast ? AppStrings.back.tr() : AppStrings.skip.tr(),
        style: getMediumStyle(fontSize: 16.sp, color: ColorManager.greyText),
      ),
    );
  }
}
