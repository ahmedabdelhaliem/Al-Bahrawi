import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:al_bahrawi/features/chat/domain/model/message_model.dart';

class ChatFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseDatabase? _database;
  StreamSubscription? _messageSubscription;
  final _messageController = StreamController<MessageModel>.broadcast();

  Stream<MessageModel> get messagesStream => _messageController.stream;

  Future<void> init(String customToken, String dbUrl, String path) async {
    try {
      // Auth with custom token
      await _auth.signInWithCustomToken(customToken);
      
      // Init Database
      _database = FirebaseDatabase.instanceFor(app: _auth.app, databaseURL: dbUrl);
      
      // Stop old subscription if any
      await _messageSubscription?.cancel();
      
      // Listen to new messages (limited to last to prevent historical flood)
      _messageSubscription = _database!
          .ref(path)
          .limitToLast(1)
          .onChildAdded
          .listen((event) {
        if (event.snapshot.value != null) {
          try {
            final Map<dynamic, dynamic> data =
                event.snapshot.value as Map<dynamic, dynamic>;
            if (kDebugMode) {
              print("🔥 Firebase Message Received: $data");
            }
            final Map<String, dynamic> convertedData = _convertMap(data);
            final message = MessageModel.fromJson(convertedData);
            _messageController.add(message);
          } catch (e) {
            if (kDebugMode) {
              print("Error parsing real-time message: $e");
            }
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Firebase Chat Init Error: $e");
      }
      rethrow;
    }
  }

  Map<String, dynamic> _convertMap(Map<dynamic, dynamic> original) {
    final Map<String, dynamic> converted = {};
    original.forEach((key, value) {
      String stringKey = key.toString();
      
      // Normalize specific common keys from camelCase/Firebase names to snake_case
      if (stringKey == 'attachmentUrl' || stringKey == 'attachment' || stringKey == 'url') {
        stringKey = 'attachment_url';
      }
      if (stringKey == 'senderType') stringKey = 'sender_type';
      if (stringKey == 'senderId') stringKey = 'sender_id';
      if (stringKey == 'senderName') stringKey = 'sender_name';
      if (stringKey == 'createdAt') stringKey = 'created_at';
      
      if (value is Map) {
        converted[stringKey] = _convertMap(value);
      } else {
        converted[stringKey] = value;
      }
    });
    return converted;
  }

  Future<void> dispose() async {
    await _messageSubscription?.cancel();
    _messageSubscription = null;
    // We do NOT close _messageController here because ChatFirebaseService is a Singleton.
    // Closing it here would prevent it from being used if the user re-enters the chat.
  }
}
