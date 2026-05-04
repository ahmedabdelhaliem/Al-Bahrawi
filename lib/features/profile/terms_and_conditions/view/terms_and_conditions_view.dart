import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/shimmer_container_widget.dart';
import 'package:al_bahrawi/features/profile/terms_and_conditions/cubit/terms_cubit.dart';
import 'package:al_bahrawi/features/profile/terms_and_conditions/model/terms_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TermsCubit()..getTerms(),
      child: Scaffold(
        backgroundColor: const Color(0xffF9FAFB),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<TermsCubit, BaseState<TermsModel>>(
                builder: (context, state) {
                  if (state.status == Status.loading) {
                    return _buildShimmerContent();
                  }

                  if (state.status == Status.failure) {
                    return Center(
                        child: Text(
                            state.errorMessage ?? AppStrings.unKnownError.tr()));
                  }

                  final terms = state.data?.data;

                  return SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: ColorManager.gold.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.description_outlined,
                                    color: ColorManager.gold, size: 20.w),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  terms?.title ?? AppStrings.terms.tr(),
                                  style: getBoldStyle(
                                      color: ColorManager.blue, fontSize: 16.sp),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          if (terms?.banner != null) ...[
                            Container(
                              width: double.infinity,
                              height: 160.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ColorManager.blue.withValues(alpha: 0.05),
                                    ColorManager.primary.withValues(alpha: 0.1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                    color: ColorManager.primary.withValues(alpha: 0.1),
                                    width: 1),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(20.w),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.r),
                                        child: Image.network(
                                          terms!.banner!,
                                          fit: BoxFit.contain,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return ShimmerContainerWidget(
                                                height: 160.h,
                                                width: double.infinity);
                                          },
                                          errorBuilder: (_, __, ___) => Icon(
                                              Icons.image_not_supported_outlined,
                                              color: ColorManager.grey,
                                              size: 40.w),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: -20,
                                    top: -20,
                                    child: CircleAvatar(
                                      radius: 40.r,
                                      backgroundColor: ColorManager.gold.withValues(alpha: 0.05),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),
                          ],
                          Text(
                            terms?.description ?? "",
                            style: getRegularStyle(
                                color: ColorManager.textColor,
                                fontSize: 14.sp,
                                height: 1.8),
                            textAlign: TextAlign.right,
                          ),
                          if (terms?.updatedAt != null) ...[
                            SizedBox(height: 30.h),
                            Divider(color: ColorManager.grey.withValues(alpha: 0.1)),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "آخر تحديث: ${terms!.updatedAt}",
                                  style: getRegularStyle(
                                      color: ColorManager.grey, fontSize: 11.sp),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShimmerContainerWidget(height: 35.h, width: 35.w, radios: 17.r),
                SizedBox(width: 12.w),
                ShimmerContainerWidget(height: 20.h, width: 150.w),
              ],
            ),
            SizedBox(height: 30.h),
            ShimmerContainerWidget(height: 150.h, width: double.infinity, radios: 12.r),
            SizedBox(height: 20.h),
            ShimmerContainerWidget(height: 15.h, width: double.infinity),
            SizedBox(height: 10.h),
            ShimmerContainerWidget(height: 15.h, width: double.infinity),
            SizedBox(height: 10.h),
            ShimmerContainerWidget(height: 15.h, width: 250.w),
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
          colors: [
            ColorManager.blue,
            ColorManager.primary.withValues(alpha: 0.7)
          ],
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
                icon:
                    const Icon(Icons.arrow_back_ios, color: ColorManager.white),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                AppStrings.terms.tr(),
                style: getBoldStyle(color: ColorManager.white, fontSize: 22.sp),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ],
      ),
    );
  }
}
