import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/widgets/paginated_list_wrapper.dart';
import 'package:al_bahrawi/features/notifications/cubit/notifications_cubit.dart';
import 'package:al_bahrawi/features/notifications/models/notifications_model.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit()..loadFirstNotificationsPage(),
      child: Scaffold(
        backgroundColor: const Color(0xffF9FAFB),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<NotificationsCubit, BaseState<NotificationModel>>(
                builder: (context, state) {
                  if (state.status == Status.loading && state.items.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == Status.failure && state.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.errorMessage ?? AppStrings.unKnownError.tr()),
                          SizedBox(height: 10.h),
                          ElevatedButton(
                            onPressed: () => context.read<NotificationsCubit>().loadFirstNotificationsPage(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primary,
                            ),
                            child: Text(
                              AppStrings.tryAgain.tr(),
                              style: getBoldStyle(color: ColorManager.white, fontSize: 14.sp),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final notifications = state.items;

                  if (notifications.isEmpty) {
                    return Center(
                      child: Text(
                        AppStrings.noData.tr(),
                        style: getMediumStyle(color: ColorManager.grey, fontSize: 15.sp),
                      ),
                    );
                  }

                  final listItems = _buildListItems(context, notifications);

                  return PaginatedListWrapper(
                    scrollController: _scrollController,
                    paginationHandler: context.read<NotificationsCubit>().paginationHandler,
                    fetchFunction: (page, limit, [params]) => context.read<NotificationsCubit>().getNotifications(page: page),
                    child: RefreshIndicator(
                      onRefresh: () => context.read<NotificationsCubit>().loadFirstNotificationsPage(),
                      color: ColorManager.primary,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                        itemCount: listItems.length,
                        itemBuilder: (context, index) => listItems[index],
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

  List<Widget> _buildListItems(BuildContext context, List<NotificationModel> notifications) {
    final List<Widget> items = [];
    String? lastGroup;

    for (var notification in notifications) {
      final dateStr = notification.createdAt;
      String group = "";
      if (dateStr != null && dateStr.isNotEmpty) {
        try {
          final date = DateTime.parse(dateStr).toLocal();
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final yesterday = today.subtract(const Duration(days: 1));
          final compareDate = DateTime(date.year, date.month, date.day);

          if (compareDate == today) {
            group = AppStrings.today.tr();
          } else if (compareDate == yesterday) {
            group = AppStrings.yesterday.tr();
          } else {
            group = DateFormat('dd MMMM yyyy', context.locale.languageCode).format(date);
          }
        } catch (e) {
          group = "";
        }
      }

      if (group.isNotEmpty && group != lastGroup) {
        items.add(_buildSectionTitle(group));
        lastGroup = group;
      }

      IconData icon = Icons.notifications_active_rounded;
      Color iconColor = ColorManager.white;
      Color bgColor = ColorManager.primary;
      
      final notificationId = notification.id;
      final isUnread = notification.readAt == null;

      VoidCallback onTap = () {
        if (notificationId != null && isUnread) {
          context.read<NotificationsCubit>().markAsRead(notificationId);
        }
        context.push(AppRouters.myCases);
      };

      final metadata = notification.metadata;
      if (metadata != null) {
        final type = metadata['type'];
        if (type == 'new_message') {
          icon = Icons.chat_bubble_outline_rounded;
          iconColor = ColorManager.blue;
          bgColor = ColorManager.blue.withValues(alpha: 0.1);
          final conversationId = int.tryParse(metadata['conversation_id']?.toString() ?? '');
          if (conversationId != null) {
            onTap = () {
              if (notificationId != null && isUnread) {
                context.read<NotificationsCubit>().markAsRead(notificationId);
              }
              context.push(
                AppRouters.chatView,
                extra: {
                  'chatId': conversationId,
                  'supplierName': notification.title ?? AppStrings.chat.tr(),
                },
              );
            };
          }
        }
      }

      items.add(
        _buildNotificationCard(
          title: notification.title ?? "",
          desc: notification.body ?? "",
          icon: icon,
          iconColor: iconColor,
          bgColor: bgColor,
          isUnread: isUnread,
          onTap: onTap,
        ),
      );
    }

    return items;
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
                AppStrings.notifications.tr(),
                style: getBoldStyle(color: ColorManager.white, fontSize: 22.sp),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
      child: Text(
        title,
        style: getBoldStyle(color: ColorManager.blue, fontSize: 14.sp),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required bool isUnread,
    VoidCallback? onTap,
  }) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: ColorManager.primary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.w),
        child: Icon(Icons.delete_outline_rounded,
            color: ColorManager.white, size: 24.w),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isUnread ? ColorManager.primary.withValues(alpha: 0.05) : ColorManager.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: isUnread
                ? Border.all(color: ColorManager.primary.withValues(alpha: 0.15), width: 1)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isUnread) ...[
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: ColorManager.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],
                        Text(
                          title,
                          style:
                              getBoldStyle(color: ColorManager.blue, fontSize: 15.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      desc,
                      style: getRegularStyle(
                          color: ColorManager.greyText, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20.w),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
