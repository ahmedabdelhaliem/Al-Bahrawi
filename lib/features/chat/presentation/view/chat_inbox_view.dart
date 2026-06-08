import 'package:al_bahrawi/app/di.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/widgets/default_app_bar.dart';
import 'package:al_bahrawi/common/widgets/shimmer_container_widget.dart';
import 'package:al_bahrawi/features/chat/domain/model/chat_model.dart';
import 'package:al_bahrawi/features/chat/presentation/cubit/chat_inbox_cubit.dart';
import 'package:al_bahrawi/features/chat/presentation/view/widgets/chat_inbox_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChatInboxView extends StatefulWidget {
  const ChatInboxView({super.key});

  @override
  State<ChatInboxView> createState() => _ChatInboxViewState();
}

class _ChatInboxViewState extends State<ChatInboxView> {
  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              ShimmerContainerWidget(height: 50.r, width: 50.r, radios: 25.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainerWidget(height: 14.h, width: 120.w),
                    SizedBox(height: 8.h),
                    ShimmerContainerWidget(height: 12.h, width: 180.w),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<ChatInboxCubit>()..getChats(),
      child: Scaffold(
        backgroundColor: ColorManager.bg,
        appBar: DefaultAppBar(
          text: AppStrings.chatInbox.tr(),
          backgroundColor: ColorManager.white,
          titleColor: ColorManager.black,
          withLeading: false, // Hidden for bottom nav
        ),
        body: BlocBuilder<ChatInboxCubit, BaseState<ChatModel>>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return _buildShimmerList();
            }

            if (state.status == Status.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage ?? AppStrings.unKnownError.tr()),
                    SizedBox(height: 10.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ChatInboxCubit>().getChats();
                      },
                      child: Text(AppStrings.tryAgain.tr()),
                    ),
                  ],
                ),
              );
            }

            final chats = state.items;

            if (chats.isEmpty) {
              return Center(
                child: Text(AppStrings.noData.tr()),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<ChatInboxCubit>().getChats(),
              color: ColorManager.primary,
              child: ListView.builder(
                padding: EdgeInsets.all(20.w),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ChatInboxItem(
                    chat: chat,
                    onTap: () {
                      context.push(
                        AppRouters.chatView,
                        extra: {
                          'chatId': chat.id,
                          'supplierName': chat.supplier.name ?? 'Chat',
                        },
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
