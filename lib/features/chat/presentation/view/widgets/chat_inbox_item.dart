import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/features/chat/domain/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInboxItem extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  const ChatInboxItem({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          width: 50.r,
          height: 50.r,
          decoration: BoxDecoration(
            color: ColorManager.lightGrey.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            image: chat.supplier.image != null && chat.supplier.image!.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(chat.supplier.image!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: chat.supplier.image == null || chat.supplier.image!.isEmpty
              ? Icon(Icons.person, color: ColorManager.primary, size: 28.sp)
              : null,
        ),
        title: Text(
          chat.supplier.name ?? 'Supplier',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.blue,
          ),
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                chat.lastMessage ?? 'لا توجد رسائل',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: ColorManager.greyTextColor,
                ),
              ),
            ),
            if (chat.lastMessageTime != null) ...[
              SizedBox(width: 8.w),
              Text(
                chat.lastMessageTime!,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: ColorManager.greyTextColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ],
        ),
        trailing: chat.unreadCount > 0
            ? Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: ColorManager.gold,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${chat.unreadCount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
                color: ColorManager.lightGrey,
              ),
      ),
    );
  }
}
