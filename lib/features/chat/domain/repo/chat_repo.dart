import 'package:al_bahrawi/common/network/either.dart';
import 'package:al_bahrawi/common/network/failure.dart';
import 'package:al_bahrawi/features/chat/domain/model/firebase_chat_config.dart';
import 'package:al_bahrawi/features/chat/domain/model/message_model.dart';
import 'package:al_bahrawi/features/chat/domain/model/chat_model.dart';

abstract class ChatRepo {
  Future<Either<Failure, CreateChatResponse>> createChat(int supplierId);
  Future<Either<Failure, FirebaseChatConfig>> getFirebaseToken(int purchaseOrderId);
  Future<Either<Failure, List<MessageModel>>> getChatMessages(int chatId, {int page = 1});
  Future<Either<Failure, List<ChatModel>>> getChats();
  Future<Either<Failure, MessageModel>> sendMessage(int chatId, {String? message, String? imagePath});
  
  // Real-time
  Future<void> initFirebaseChat(FirebaseChatConfig config);
  Stream<MessageModel> get messagesStream;
  Future<void> disposeFirebaseChat();
}
