class FirebaseChatConfig {
  final String customToken;
  final String databaseUrl;
  final int purchaseOrderId;
  final String messagesPath;

  const FirebaseChatConfig({
    required this.customToken,
    required this.databaseUrl,
    required this.purchaseOrderId,
    required this.messagesPath,
  });

  factory FirebaseChatConfig.fromJson(Map<String, dynamic> json) {
    return FirebaseChatConfig(
      customToken: json['firebase_custom_token'] as String,
      databaseUrl: json['firebase_database_url'] as String,
      purchaseOrderId: (json['purchase_order_id'] as num).toInt(),
      messagesPath: json['firebase_messages_path'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firebase_custom_token': customToken,
      'firebase_database_url': databaseUrl,
      'purchase_order_id': purchaseOrderId,
      'firebase_messages_path': messagesPath,
    };
  }
}
