class MessageModel {
  final dynamic id;
  final String? senderType;
  final dynamic senderId;
  final String? senderName;
  final String type;
  final String? body;
  final String? attachmentUrl;
  final String createdAt;

  const MessageModel({
    required this.id,
    this.senderType,
    this.senderId,
    this.senderName,
    required this.type,
    this.body,
    this.attachmentUrl,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderType: json['sender_type'] as String?,
      senderId: json['sender_id'],
      senderName: json['sender_name'] as String?,
      type: json['type'] as String,
      body: json['body'] as String?,
      attachmentUrl: json['attachment_url'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_type': senderType,
      'sender_id': senderId,
      'sender_name': senderName,
      'type': type,
      'body': body,
      'attachment_url': attachmentUrl,
      'created_at': createdAt,
    };
  }
}

class CreateChatResponse {
  final int chatId;

  const CreateChatResponse({
    required this.chatId,
  });

  factory CreateChatResponse.fromJson(Map<String, dynamic> json) {
    return CreateChatResponse(
      chatId: (json['chat_id'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
    };
  }
}
