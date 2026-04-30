import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/resources/app_router.dart';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:al_bahrawi/common/widgets/default_app_bar.dart';
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
  @override
  void initState() {
    super.initState();
    // context.read<ChatInboxCubit>().getChats();
  }

  final List<ChatModel> dummyChats = [
    const ChatModel(
      id: 1,
      lastMessage: "أهلاً بك، كيف يمكنني مساعدتك في قضيتك؟",
      lastMessageTime: "10:30 AM",
      unreadCount: 2,
      supplier: ChatSupplier(id: 1, name: "المحامي أحمد البهراوي", image: null),
    ),
    const ChatModel(
      id: 2,
      lastMessage: "تم استلام أوراق القضية، سأتواصل معك قريباً.",
      lastMessageTime: "أمس",
      unreadCount: 0,
      supplier: ChatSupplier(id: 2, name: "المستشار محمد الدسوقي", image: null),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bg,
      appBar: DefaultAppBar(
        text: AppStrings.chatInbox.tr(),
        backgroundColor: ColorManager.white,
        titleColor: ColorManager.black,
        withLeading: false, // Hidden for bottom nav
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: dummyChats.length,
        itemBuilder: (context, index) {
          final chat = dummyChats[index];
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
  }
}
