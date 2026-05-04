import 'package:al_bahrawi/common/widgets/shimmer_container_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';

import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/features/services/cubit/service_details_cubit.dart';
import 'package:al_bahrawi/features/services/models/services_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceDetailsView extends StatelessWidget {
  final int serviceId;
  const ServiceDetailsView({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceDetailsCubit()..getServiceDetails(serviceId),
      child: BlocBuilder<ServiceDetailsCubit, BaseState<ServiceDetailsModel>>(
        builder: (context, state) {
          final service = state.data?.data;
          final isLoading = state.status == Status.loading;

          if (state.status == Status.failure && service == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage ?? AppStrings.unKnownError.tr()),
                    SizedBox(height: 10.h),
                    ElevatedButton(
                      onPressed: () => context.read<ServiceDetailsCubit>().getServiceDetails(serviceId),
                      child: Text(AppStrings.tryAgain.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: ColorManager.white,
            body: Stack(
              children: [
                Column(
                  children: [
                    _buildHeader(context, service, isLoading),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 24.h),
                            // About Service Card
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: ColorManager.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.5), width: 0.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    AppStrings.aboutService.tr(),
                                    style: getBoldStyle(color: ColorManager.blue, fontSize: 16.sp),
                                  ),
                                  SizedBox(height: 12.h),
                                  isLoading 
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            ShimmerContainerWidget(height: 15.h, width: double.infinity),
                                            SizedBox(height: 8.h),
                                            ShimmerContainerWidget(height: 15.h, width: double.infinity),
                                          ],
                                        )
                                      : Text(
                                          service?.description ?? '',
                                          style: getRegularStyle(color: ColorManager.greyText, fontSize: 14.sp),
                                          textAlign: TextAlign.right,
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),
                            // Goals List from API
                            if (isLoading)
                               ...List.generate(3, (index) => _buildGoalShimmer())
                            else if (service?.goals != null && service!.goals!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "أهداف الخدمة",
                                    style: getBoldStyle(color: ColorManager.blue, fontSize: 16.sp),
                                  ),
                                  SizedBox(height: 12.h),
                                  ...service.goals!.map((goal) => _buildBenefitItem(
                                    goal.name ?? '',
                                    goal.title ?? '',
                                    Icons.check_circle_outline,
                                  )),
                                ],
                              ),
                            
                            SizedBox(height: 24.h),
                            // Footer Stats
                            Center(
                              child: Text(
                                AppStrings.taxFilesProcessed.tr(),
                                style: getRegularStyle(color: ColorManager.grey, fontSize: 11.sp),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 120.h), // Extra space to scroll past the floating button
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomAction(context, isLoading),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, bool isLoading) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
      child: DefaultButtonWidget(
        text: AppStrings.bookNow.tr(),
        onPressed: isLoading ? null : () => context.push(AppRouters.requestConsultation, extra: {'serviceId': serviceId}),
        color: ColorManager.blue,
        textColor: ColorManager.white,
        height: 55.h,
        radius: 16.r,
        isIcon: true,
        iconBuilder: Icon(Icons.calendar_today_outlined, color: ColorManager.gold, size: 18.w),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ServiceModel? service, bool isLoading) {
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
              // Dynamic Tag (Service Type)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ColorManager.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: ColorManager.gold.withValues(alpha: 0.5), width: 1),
                ),
                child: isLoading 
                    ? ShimmerContainerWidget(height: 10.h, width: 60.w, radios: 10.r)
                    : Text(
                        service?.serviceType?.name ?? '',
                        style: getMediumStyle(color: ColorManager.gold, fontSize: 10.sp),
                      ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          isLoading 
              ? ShimmerContainerWidget(height: 30.h, width: 200.w)
              : Text(
                  service?.name ?? '',
                  style: getBoldStyle(color: ColorManager.white, fontSize: 26.sp),
                  textAlign: TextAlign.right,
                ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isLoading 
                  ? ShimmerContainerWidget(height: 12.h, width: 100.w)
                  : Text(
                      AppStrings.certifiedService.tr(),
                      style: getRegularStyle(color: ColorManager.white.withValues(alpha: 0.8), fontSize: 12.sp),
                    ),
              SizedBox(width: 6.w),
              Icon(Icons.verified, color: ColorManager.gold, size: 16.w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Row(
        children: [
          ShimmerContainerWidget(height: 12.h, width: 12.w, radios: 4.r),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerContainerWidget(height: 14.h, width: 100.w),
              SizedBox(height: 4.h),
              ShimmerContainerWidget(height: 10.h, width: 150.w),
            ],
          ),
          SizedBox(width: 12.w),
          ShimmerContainerWidget(height: 40.h, width: 40.w, radios: 12.r),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String title, String desc, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.5), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.arrow_back_ios, color: ColorManager.grey.withValues(alpha: 0.5), size: 12.w),
          const Spacer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: getBoldStyle(color: ColorManager.blue, fontSize: 14.sp),
                ),
                SizedBox(height: 2.h),
                Text(
                  desc,
                  style: getRegularStyle(color: ColorManager.grey, fontSize: 11.sp),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: ColorManager.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ColorManager.gold.withValues(alpha: 0.3), width: 1),
            ),
            child: Icon(icon, color: ColorManager.blue, size: 20.w),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Column(
        children: [
          // Header Shimmer
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 55.h, bottom: 40.h, left: 20.w, right: 20.w),
            decoration: BoxDecoration(
              color: ColorManager.lightGrey.withValues(alpha: 0.1),
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
                    ShimmerContainerWidget(height: 35.h, width: 35.w, radios: 10.r),
                    ShimmerContainerWidget(height: 25.h, width: 80.w, radios: 20.r),
                  ],
                ),
                SizedBox(height: 30.h),
                ShimmerContainerWidget(height: 30.h, width: 200.w),
                SizedBox(height: 10.h),
                ShimmerContainerWidget(height: 15.h, width: 120.w),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 24.h),
                  // About Card Shimmer
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ShimmerContainerWidget(height: 20.h, width: 100.w),
                        SizedBox(height: 12.h),
                        ShimmerContainerWidget(height: 15.h, width: double.infinity),
                        SizedBox(height: 8.h),
                        ShimmerContainerWidget(height: 15.h, width: double.infinity),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  ShimmerContainerWidget(height: 20.h, width: 120.w),
                  SizedBox(height: 15.h),
                  // List Items Shimmer
                  ...List.generate(3, (index) => Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: ColorManager.greyBorder.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        ShimmerContainerWidget(height: 15.h, width: 15.w, radios: 4.r),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ShimmerContainerWidget(height: 15.h, width: 120.w),
                            SizedBox(height: 6.h),
                            ShimmerContainerWidget(height: 10.h, width: 180.w),
                          ],
                        ),
                        SizedBox(width: 12.w),
                        ShimmerContainerWidget(height: 40.h, width: 40.w, radios: 12.r),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
