class ChatSupplier {
  final int id;
  final String? name;
  final String? image;

  const ChatSupplier({
    required this.id,
    this.name,
    this.image,
  });

  factory ChatSupplier.fromJson(Map<String, dynamic> json) {
    return ChatSupplier(
      id: json['id'] as int,
      name: json['name'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}

class ChatModel {
  final int id;
  final String? lastMessage;
  final String? lastMessageTime;
  final int unreadCount;
  final ChatSupplier supplier;

  const ChatModel({
    required this.id,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    required this.supplier,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as int,
      lastMessage: json['last_message'] as String?,
      lastMessageTime: json['last_message_time'] as String?,
      unreadCount: json['unread_count'] as int? ?? 0,
      supplier: ChatSupplier.fromJson(json['supplier'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'unread_count': unreadCount,
      'supplier': supplier.toJson(),
    };
  }
}
