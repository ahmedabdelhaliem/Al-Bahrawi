import 'package:al_bahrawi/common/network/either.dart';
import 'package:al_bahrawi/common/network/failure.dart';
import 'package:al_bahrawi/features/chat/data/data_source/chat_api_data_source.dart';
import 'package:al_bahrawi/features/chat/data/data_source/chat_firebase_service.dart';
import 'package:al_bahrawi/features/chat/domain/model/message_model.dart';
import 'package:al_bahrawi/features/chat/domain/model/chat_model.dart';
import 'package:al_bahrawi/features/chat/domain/model/firebase_chat_config.dart';
import 'package:al_bahrawi/features/chat/domain/repo/chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  final ChatApiDataSource _apiDataSource;
  final ChatFirebaseService _firebaseService;

  ChatRepoImpl(this._apiDataSource, this._firebaseService);

  @override
  Future<Either<Failure, CreateChatResponse>> createChat(int supplierId) {
    return _apiDataSource.createChat(supplierId);
  }

  @override
  Future<Either<Failure, FirebaseChatConfig>> getFirebaseToken(int purchaseOrderId) {
    return _apiDataSource.getFirebaseToken(purchaseOrderId);
  }

  @override
  Future<Either<Failure, List<MessageModel>>> getChatMessages(int chatId, {int page = 1}) {
    return _apiDataSource.getChatMessages(chatId, page: page);
  }

  @override
  Future<Either<Failure, MessageModel>> sendMessage(int chatId, {String? message, String? imagePath}) {
    return _apiDataSource.sendMessage(chatId, body: message, imagePath: imagePath);
  }

  @override
  Future<void> initFirebaseChat(FirebaseChatConfig config) async {
    await _firebaseService.init(config.customToken, config.databaseUrl, config.messagesPath);
  }

  @override
  Stream<MessageModel> get messagesStream => _firebaseService.messagesStream;

  @override
  Future<void> disposeFirebaseChat() async {
    await _firebaseService.dispose();
  }

  @override
  Future<Either<Failure, List<ChatModel>>> getChats() {
    return _apiDataSource.getChats();
  }
}
