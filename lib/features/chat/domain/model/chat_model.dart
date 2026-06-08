import 'package:intl/intl.dart' as intl;

class ChatSupplier {
  final int id;
  final String? name;
  final String? image;
  final String? userType;

  const ChatSupplier({
    required this.id,
    this.name,
    this.image,
    this.userType,
  });

  factory ChatSupplier.fromJson(Map<String, dynamic> json) {
    return ChatSupplier(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      userType: json['user_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'user_type': userType,
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
    // Determine the last message text safely
    String? lastMsg;
    if (json['last_message'] is String) {
      lastMsg = json['last_message'] as String?;
    } else if (json['last_message'] is Map) {
      final lastMsgMap = Map<String, dynamic>.from(json['last_message'] as Map);
      lastMsg = lastMsgMap['message'] as String? ?? lastMsgMap['body'] as String?;
    }

    // Determine the last message time safely
    String? rawTime = json['last_message_at'] as String?;
    if (rawTime == null && json['last_message'] is Map) {
      final lastMsgMap = Map<String, dynamic>.from(json['last_message'] as Map);
      rawTime = lastMsgMap['created_at'] as String?;
    }
    rawTime ??= json['last_message_time'] as String?;
    
    String? formattedTime;
    if (rawTime != null) {
      try {
        final dateTime = DateTime.parse(rawTime).toLocal();
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));
        final compareDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
        
        if (compareDate == today) {
          formattedTime = intl.DateFormat('hh:mm a').format(dateTime);
        } else if (compareDate == yesterday) {
          formattedTime = 'أمس'; // Arabic for "Yesterday"
        } else {
          formattedTime = intl.DateFormat('dd/MM/yyyy').format(dateTime);
        }
      } catch (_) {
        formattedTime = rawTime;
      }
    }

    // Parse the supplier/participant safely
    ChatSupplier parsedSupplier;
    if (json['participant'] != null) {
      parsedSupplier = ChatSupplier.fromJson(Map<String, dynamic>.from(json['participant'] as Map));
    } else if (json['supplier'] != null) {
      parsedSupplier = ChatSupplier.fromJson(Map<String, dynamic>.from(json['supplier'] as Map));
    } else {
      parsedSupplier = const ChatSupplier(id: 0, name: 'Admin', image: null);
    }

    return ChatModel(
      id: (json['id'] as num).toInt(),
      lastMessage: lastMsg,
      lastMessageTime: formattedTime,
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      supplier: parsedSupplier,
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
