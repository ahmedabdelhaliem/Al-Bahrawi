import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/shimmer_container_widget.dart';
import 'package:al_bahrawi/features/profile/technical_support/common%20question/cubit/faq_cubit.dart';
import 'package:al_bahrawi/features/profile/technical_support/common%20question/model/faq_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class CommonQuestionView extends StatelessWidget {
  const CommonQuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaqCubit()..getFaqs(),
      child: Scaffold(
        backgroundColor: const Color(0xffF9FAFB),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<FaqCubit, BaseState<FaqResponseModel>>(
                builder: (context, state) {
                  if (state.status == Status.loading) {
                    return _buildShimmerList();
                  }

                  if (state.status == Status.failure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.danger, size: 60.sp, color: ColorManager.red),
                          SizedBox(height: 16.h),
                          Text(
                            state.errorMessage ?? AppStrings.unKnownError.tr(),
                            style: getMediumStyle(color: ColorManager.greyTextColor, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    );
                  }

                  final faqs = state.data?.data ?? [];

                  if (faqs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.info_circle, size: 60.sp, color: ColorManager.grey),
                          SizedBox(height: 16.h),
                          Text(
                            AppStrings.noData.tr(),
                            style: getMediumStyle(color: ColorManager.greyTextColor, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    physics: const BouncingScrollPhysics(),
                    itemCount: faqs.length,
                    itemBuilder: (context, index) {
                      return _buildFaqItem(faqs[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 55.h, bottom: 40.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.blue, ColorManager.primary.withValues(alpha: 0.7)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: ColorManager.white),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                AppStrings.faqs.tr(),
                style: getBoldStyle(color: ColorManager.white, fontSize: 22.sp),
              ),
              const SizedBox(width: 48),
            ],
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "نحن هنا للإجابة على استفساراتك",
              style: getRegularStyle(color: ColorManager.white.withValues(alpha: 0.8), fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(FaqModel faq) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          iconColor: ColorManager.gold,
          collapsedIconColor: ColorManager.blue,
          leading: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: ColorManager.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Iconsax.message_question, color: ColorManager.primary, size: 20.sp),
          ),
          title: Text(
            faq.question ?? "",
            style: getBoldStyle(color: ColorManager.blue, fontSize: 14.sp),
          ),
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 20.w, right: 60.w, bottom: 20.h, top: 0),
              child: Text(
                faq.answer ?? "",
                style: getRegularStyle(
                  color: ColorManager.greyTextColor, 
                  fontSize: 13.sp, 
                  height: 1.6
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              ShimmerContainerWidget(height: 40.h, width: 40.w, radios: 12.r),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainerWidget(height: 15.h, width: double.infinity),
                    SizedBox(height: 8.h),
                    ShimmerContainerWidget(height: 10.h, width: 150.w),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

