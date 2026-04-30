import 'dart:io';
import 'dart:ui';
import 'package:al_bahrawi/common/resources/color_manager.dart';
import 'package:al_bahrawi/features/chat/domain/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:cached_network_image/cached_network_image.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final bool isImage = message.type == 'image';
    final bool isOptimistic = message.id.toString().startsWith('temp_');
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
            
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 2.h,
                  bottom: 2.h,
                  left: isMe ? 40.w : 8.w,
                  right: isMe ? 8.w : 40.w,
                ),
                constraints: BoxConstraints(maxWidth: 0.75.sw),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ColorManager.blue,
                            ColorManager.blue.withValues(alpha: 0.85),
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ColorManager.white,
                            ColorManager.fillColor,
                          ],
                        ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.r),
                    topRight: Radius.circular(18.r),
                    bottomLeft: isMe ? Radius.circular(18.r) : Radius.circular(4.r),
                    bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(18.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.white,
                    width: 0.5,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Content
                      if (isImage)
                        Padding(
                          padding: EdgeInsets.all(4.r),
                          child: _buildImageContent(
                            message.attachmentUrl,
                            isOptimistic,
                          ),
                        ),

                      // Text Content
                      if (message.body != null && message.body!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                          child: Text(
                            message.body!,
                            style: TextStyle(
                              color: isMe
                                  ? Colors.white
                                  : Colors.black.withValues(alpha: 0.85),
                              fontSize: 13.5.sp,
                              fontWeight:
                                  isMe ? FontWeight.w500 : FontWeight.normal,
                              height: 1.45,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // Sending Indicator for Optimistic UI
              if (isOptimistic && isMe)
                Positioned(
                  right: 12.w,
                  bottom: 6.h,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: SizedBox(
                      width: 10.w,
                      height: 10.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 1.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          // Timestamp & Status Icon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.createdAt),
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorManager.greyTextColor.withValues(alpha: 0.5),
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    isOptimistic ? Icons.access_time_rounded : Icons.done_all_rounded,
                    size: 12.sp,
                    color: isOptimistic ? ColorManager.greyTextColor.withValues(alpha: 0.3) 
                                       : ColorManager.gold,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 6.h),
        ],
      ),
    );
  }

  Widget _buildImageContent(String? url, bool isOptimistic) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: url == null
              ? Container(
                  height: 200.h,
                  width: 0.78.sw,
                  color: ColorManager.lightGrey.withValues(alpha: 0.2),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : _isLocalPath(url)
                  ? Image.file(
                      File(url),
                      width: 0.78.sw,
                      height: 200.h,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: url,
                      width: 0.78.sw,
                      height: 200.h,
                      placeholder: (context, url) => Container(
                        height: 200.h,
                        width: 0.78.sw,
                        color: ColorManager.lightGrey.withValues(alpha: 0.2),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200.h,
                        width: 0.78.sw,
                        color: ColorManager.lightGrey.withValues(alpha: 0.2),
                        child: const Icon(Icons.error_outline),
                      ),
                      fit: BoxFit.cover,
                    ),
        ),
        if (isOptimistic)
          Container(
            height: 200.h,
            width: 0.78.sw,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  bool _isLocalPath(String path) {
    return path.startsWith('/') || path.startsWith('file://') || !path.startsWith('http');
  }

  String _formatTime(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      return intl.DateFormat('hh:mm a').format(dateTime);
    } catch (_) {
      return '';
    }
  }
}
