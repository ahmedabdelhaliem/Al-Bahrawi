import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:base_project/common/base/base_state.dart';
import 'package:base_project/common/resources/assets_manager.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:base_project/common/resources/styles_manager.dart';
import 'package:base_project/common/widgets/custom_pull_to_request.dart';
import 'package:base_project/common/widgets/default_app_bar.dart';
import 'package:base_project/common/widgets/default_error_widget.dart';
import 'package:base_project/featuers/notifications/cubit/notifications_cubit.dart';
import 'package:base_project/featuers/notifications/models/notifications_model.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit()..loadFirstNotificationsPage(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0F4FF),
              Color(0xFFF8F9FB),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: DefaultAppBar(
            text: AppStrings.notifications.tr(),
            backgroundColor: ColorManager.primary,
            titleColor: ColorManager.white,
            height: 52.h,
            titleFontSize: 16.sp,
          ),
          body: BlocBuilder<NotificationsCubit, BaseState<NotificationModel>>(
            builder: (context, state) {
              if (state.status == Status.failure) {
                return _DecoratedBody(
                  child: DefaultErrorWidget(errorMessage: state.errorMessage ?? ''),
                );
              }
              if (state.status == Status.loading) {
                return const _LoadingState();
              }
              if (state.items.isEmpty) {
                return const _EmptyState();
              }

              return PullToRefresh(
                enableRefresh: false,
                enableLoadMore: true,
                onLoadMore: () =>
                    context.read<NotificationsCubit>().loadMoreNotificationsPage(),
                builder: (controller) {
                  return _NotificationsList(notifications: state.items);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DecoratedBody extends StatelessWidget {
  const _DecoratedBody({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: child,
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: ColorManager.primary,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            AppStrings.notifications.tr(),
            style: getMediumStyle(
              fontSize: 13.sp,
              color: ColorManager.greyText,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(28.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.white,
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.primary.withValues(alpha: 0.12),
                    blurRadius: 24.r,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                IconAssets.notification,
                width: 40.w,
                height: 40.w,
                colorFilter: ColorFilter.mode(
                  ColorManager.primary.withValues(alpha: 0.85),
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              AppStrings.noData.tr(),
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontSize: 15.sp,
                color: ColorManager.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  const _NotificationsList({required this.notifications});

  final List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(10.w, 12.h, 10.w, 24.h),
      physics: const BouncingScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index == notifications.length - 1 ? 0 : 12.h),
          child: _NotificationCard(
            notification: notifications[index],
            index: index,
          ),
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.index,
  });

  final NotificationModel notification;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isEven = index.isEven;
    final accentColor = isEven
        ? ColorManager.primary
        : ColorManager.azureBlue;

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: ColorManager.greyBorder.withValues(alpha: 0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withValues(alpha: 0.04),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Accent bar
                Container(
                  width: 4.w,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(16.r),
                      bottomStart: Radius.circular(16.r),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon bubble
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle
                          ),
                          child: SvgPicture.asset(
                            IconAssets.notification,
                            width: 18.w,
                            height: 18.w,
                            colorFilter: ColorFilter.mode(
                              accentColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notification.title ?? '',
                                      style: getBoldStyle(
                                        fontSize: 13.sp,
                                        color: ColorManager.blackText,
                                        height: 1.35,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  if (notification.createdAt != null &&
                                      notification.createdAt!.isNotEmpty)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorManager.fillColor,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        notification.createdAt!,
                                        style: getRegularStyle(
                                          fontSize: 10.sp,
                                          color: ColorManager.greyText,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if ((notification.body ?? '').isNotEmpty) ...[
                                SizedBox(height: 5.h),
                                Text(
                                  notification.body ?? '',
                                  style: getRegularStyle(
                                    fontSize: 12.sp,
                                    color: ColorManager.greyTextColor,
                                    height: 1.5,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
