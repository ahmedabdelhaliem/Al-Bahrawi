import 'dart:ui';

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
    // context.read<ChatCubit>().initChat(widget.chatId);
  }

  final List<MessageModel> dummyMessages = [
    MessageModel(
      id: 1,
      senderType: 'user',
      senderId: 1,
      type: 'text',
      body: 'السلام عليكم، عندي استفسار بخصوص الخدمة.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
    ),
    MessageModel(
      id: 2,
      senderType: 'supplier',
      senderId: 2,
      type: 'text',
      body: 'وعليكم السلام ورحمة الله وبركاته، تفضل نحن في خدمتك.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 9)).toIso8601String(),
    ),
    MessageModel(
      id: 3,
      senderType: 'user',
      senderId: 1,
      type: 'text',
      body: 'هل يمكنني تغيير موعد الزيارة؟',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
    ),
  ];

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
        leading:  BackButton(color: ColorManager.black),
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

          ListView.builder(
            controller: _scrollController,
            reverse: true, // Show bottom to top (newest at bottom)
            padding: EdgeInsets.fromLTRB(16.w, 100.h, 16.w, 110.h),
            itemCount: dummyMessages.length,
            itemBuilder: (context, index) {
              // Since it's reversed, we take items from end to start for UI
              final message = dummyMessages.reversed.toList()[index];
              return MessageBubble(
                message: message,
                isMe: message.senderType == 'user',
              );
            },
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ChatInputField(
              onSend: (text, imagePath) {
                // context.read<ChatCubit>().sendMessage(widget.chatId, text, imagePath: imagePath);
                // Force scroll to bottom when user sends a message
                setState(() {
                  dummyMessages.add(
                    MessageModel(
                      id: DateTime.now().millisecondsSinceEpoch,
                      senderType: 'user',
                      senderId: 1,
                      type: imagePath != null ? 'image' : 'text',
                      body: text,
                      attachmentUrl: imagePath, // using local path works for previewing images depending on UI impl
                      createdAt: DateTime.now().toIso8601String(),
                    ),
                  );
                });
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
              },
            ),
          ),
        ],
      ),
    );
  }
}
