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
    // 1. Parse body / message safely
    String? messageBody = json['body'] as String? ?? json['message'] as String?;

    // 2. Parse attachmentUrl / file_url safely
    String? fileUrl = json['attachment_url'] as String? ?? json['file_url'] as String?;

    // 3. Parse sender information safely
    dynamic sId = json['sender_id'];
    String? sType = json['sender_type'] as String?;
    String? sName = json['sender_name'] as String?;

    if (json['sender'] is Map) {
      final senderMap = Map<String, dynamic>.from(json['sender'] as Map);
      sId ??= senderMap['id'];
      sType ??= senderMap['user_type'] as String?;
      sName ??= senderMap['name'] as String?;
    }

    return MessageModel(
      id: json['id'],
      senderType: sType,
      senderId: sId,
      senderName: sName,
      type: json['type'] as String? ?? 'text',
      body: messageBody,
      attachmentUrl: fileUrl,
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
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
