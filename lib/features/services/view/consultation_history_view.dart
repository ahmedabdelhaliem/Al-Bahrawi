import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/shimmer_container_widget.dart';
import 'package:al_bahrawi/features/services/cubit/consultation_cubit.dart';
import 'package:al_bahrawi/features/services/models/consultation_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConsultationHistoryView extends StatelessWidget {
  const ConsultationHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConsultationCubit()..getConsultations(),
      child: Scaffold(
        backgroundColor: const Color(0xffF9FAFB),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<ConsultationCubit, BaseState<dynamic>>(
                builder: (context, state) {
                  if (state.status == Status.loading) {
                    return _buildShimmerList();
                  }

                  if (state.status == Status.failure) {
                    return Center(child: Text(state.errorMessage ?? AppStrings.unKnownError.tr()));
                  }

                  final consultations = (state.data as ConsultationsResponseModel?)?.data ?? [];

                  if (consultations.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_edu_outlined,
                            size: 80.w,
                            color: ColorManager.grey.withValues(alpha: 0.3),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            AppStrings.noData.tr(),
                            style: getMediumStyle(color: ColorManager.grey, fontSize: 16.sp),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                    physics: const BouncingScrollPhysics(),
                    itemCount: consultations.length,
                    itemBuilder: (context, index) {
                      return _buildConsultationCard(consultations[index]);
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
                AppStrings.casesRecord.tr(),
                style: getBoldStyle(color: ColorManager.white, fontSize: 22.sp),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationCard(ConsultationModel item) {
    bool isResponded = item.price != null || item.notes != null;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorManager.primary.withValues(alpha: 0.05), width: 1),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat(
                  'yyyy-MM-dd',
                ).format(DateTime.parse(item.createdAt ?? DateTime.now().toString())),
                style: getRegularStyle(color: ColorManager.grey, fontSize: 11.sp),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isResponded
                      ? Colors.green.withValues(alpha: 0.1)
                      : ColorManager.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  isResponded ? "تم الرد" : "قيد المراجعة",
                  style: getBoldStyle(
                    color: isResponded ? Colors.green : ColorManager.gold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            item.serviceName ?? "",
            style: getBoldStyle(color: ColorManager.blue, fontSize: 16.sp),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8.h),
          Text(
            item.description ?? "",
            style: getRegularStyle(color: ColorManager.textColor, fontSize: 13.sp),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
          if (isResponded) ...[
            SizedBox(height: 16.h),
            const Divider(height: 1, color: Color(0xffF3F4F6)),
            SizedBox(height: 16.h),
            if (item.price != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${item.price} ج.م",
                    style: getBoldStyle(color: ColorManager.primary, fontSize: 15.sp),
                  ),
                  Text(
                    "التكلفة المقدرة:",
                    style: getBoldStyle(color: ColorManager.blue, fontSize: 13.sp),
                  ),
                ],
              ),
            if (item.notes != null) ...[
              SizedBox(height: 12.h),
              Text(
                "ملاحظات المستشار:",
                style: getBoldStyle(color: ColorManager.blue, fontSize: 13.sp),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 4.h),
              Text(
                item.notes!,
                style: getRegularStyle(color: ColorManager.greyText, fontSize: 12.sp),
                textAlign: TextAlign.right,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: ColorManager.primary.withValues(alpha: 0.05), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerContainerWidget(height: 15.h, width: 80.w),
                  ShimmerContainerWidget(height: 20.h, width: 60.w, radios: 8.r),
                ],
              ),
              SizedBox(height: 16.h),
              ShimmerContainerWidget(height: 20.h, width: 150.w),
              SizedBox(height: 10.h),
              ShimmerContainerWidget(height: 14.h, width: double.infinity),
              SizedBox(height: 5.h),
              ShimmerContainerWidget(height: 14.h, width: double.infinity),
            ],
          ),
        );
      },
    );
  }
}
