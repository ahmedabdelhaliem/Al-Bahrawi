import 'package:al_bahrawi/app/app_prefs.dart';
import 'package:al_bahrawi/app/di.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:al_bahrawi/common/widgets/default_button_widget.dart';
import 'package:al_bahrawi/features/lawyer_dashboard/cubit/lawyer_dashboard_cubit.dart';
import 'package:al_bahrawi/features/lawyer_dashboard/models/task_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LawyerDashboardView extends StatefulWidget {
  const LawyerDashboardView({super.key});

  @override
  State<LawyerDashboardView> createState() => _LawyerDashboardViewState();
}

class _LawyerDashboardViewState extends State<LawyerDashboardView> {
  final LawyerDashboardCubit _cubit = instance<LawyerDashboardCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  AppStrings.casesRecord.tr(),
                  style: getBoldStyle(color: ColorManager.blue, fontSize: 24.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: BlocBuilder<LawyerDashboardCubit, BaseState<TaskResponse>>(
                  builder: (context, state) {
                    if (state.status == Status.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.status == Status.failure) {
                      return Center(child: Text(state.errorMessage ?? 'Error'));
                    }
                    final tasks = state.data?.data ?? [];
                    if (tasks.isEmpty) {
                      return const Center(child: Text('No tasks found'));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return _buildCaseCard(context, tasks[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final String userName = instance<AppPreferences>().getUserName();
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorManager.lightBlueSky, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://ui-avatars.com/api/?name=Sayed+Galal&background=0D8ABC&color=fff&size=150',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: const BoxDecoration(
                          color: ColorManager.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.verified, color: ColorManager.primary, size: 14.sp),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTag('${AppStrings.lawyer.tr()} : $userName'),
                      SizedBox(height: 4.h),
                      _buildTag(AppStrings.cases.tr()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          DefaultButtonWidget(
            onPressed: () {
              context.go(AppRouters.lawyerCheckout);
            },
            text: AppStrings.checkout.tr(),
            color: ColorManager.primary,
            height: 32.h,
            width: 85.w,
            radius: 20.r,
            verticalPadding: 4.h,
            horizontalPadding: 4.w,
            isExpanded: false,
            textStyle: getBoldStyle(color: ColorManager.white, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorManager.successGreen.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: getBoldStyle(color: ColorManager.successGreen, fontSize: 11.sp),
      ),
    );
  }

  Widget _buildCaseCard(BuildContext context, TaskModel task) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.fillColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task.service?.name ?? 'Unknown Service',
                  style: getBoldStyle(color: ColorManager.blackText, fontSize: 16.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(color: ColorManager.white, shape: BoxShape.circle),
                child: Icon(Icons.grid_view_rounded, color: ColorManager.primary, size: 20.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            task.consultation?.description ?? 'No description',
            style: getRegularStyle(color: ColorManager.greyTextColor, fontSize: 13.sp),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildInfoChip(Icons.calendar_today, _formatDate(task.startedAt)),
              SizedBox(width: 12.w),
              _buildInfoChip(Icons.info_outline, task.status),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: DefaultButtonWidget(
                  onPressed: () {
                    context.push(
                      AppRouters.chatView,
                      extra: {
                        'chatId': task.id,
                        'supplierName': task.service?.name ?? 'Task Chat',
                      },
                    );
                  },
                  text: AppStrings.chat.tr(),
                  color: ColorManager.primary,
                  height: 40.h,
                  radius: 20.r,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: DefaultButtonWidget(
                  onPressed: () {
                    // Call logic
                  },
                  text: AppStrings.call.tr(),
                  color: ColorManager.primary,
                  height: 40.h,
                  radius: 20.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: ColorManager.primary),
        SizedBox(width: 4.w),
        Text(
          text,
          style: getSemiBoldStyle(color: ColorManager.primary, fontSize: 11.sp),
        ),
      ],
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
