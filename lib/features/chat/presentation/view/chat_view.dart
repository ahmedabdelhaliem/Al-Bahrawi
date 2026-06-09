import 'dart:ui';

import 'package:al_bahrawi/app/di.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/features/chat/domain/model/message_model.dart';
import 'package:al_bahrawi/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:al_bahrawi/features/chat/presentation/view/widgets/chat_input_field.dart';
import 'package:al_bahrawi/features/chat/presentation/view/widgets/chat_shimmer.dart';
import 'package:al_bahrawi/features/chat/presentation/view/widgets/message_bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatView extends StatefulWidget {
  final int chatId;
  final String supplierName;

  const ChatView({super.key, required this.chatId, required this.supplierName});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final chatCubit = context.read<ChatCubit>();
      chatCubit.paginationHandler.fetchData(
        (page, limit, [params]) => chatCubit.getChatMessages(chatId: widget.chatId, page: page),
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ColorManager.white.withValues(alpha: 0.8),
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        leading: BackButton(color: ColorManager.black),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: ColorManager.primary.withValues(alpha: 0.1),
              child: Icon(Icons.person_rounded, color: ColorManager.primary, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.supplierName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Pattern (Subtle Local Alternative or Fallback)
          Positioned.fill(
            child: Container(
              color: ColorManager.bg,
              child: Opacity(
                opacity: 0.02,
                child: Icon(Icons.grid_4x4, size: 400.sp, color: ColorManager.primary),
              ),
            ),
          ),

          BlocBuilder<ChatCubit, BaseState<MessageModel>>(
            builder: (context, state) {
              if (state.status == Status.loading && state.items.isEmpty) {
                return const ChatShimmer();
              }

              if (state.items.isEmpty) {
                return Center(
                  child: Text(
                    AppStrings.startChatNow.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorManager.grey,
                    ),
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                reverse: true, // Show bottom to top (newest at bottom)
                padding: EdgeInsets.fromLTRB(16.w, 100.h, 16.w, 110.h),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final message = state.items[index];
                  return MessageBubble(
                    message: message,
                    isMe: message.senderType == 'user',
                  );
                },
              );
            },
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ChatInputField(
              onSend: (text, imagePath) {
                context.read<ChatCubit>().sendMessage(widget.chatId, text, imagePath: imagePath);
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
              },
            ),
          ),
        ],
      ),
    );
  }
}
