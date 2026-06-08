import 'package:dio/dio.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/network/end_points.dart';
import 'package:al_bahrawi/features/chat/domain/model/message_model.dart';
import 'package:al_bahrawi/features/chat/domain/model/chat_model.dart';
import 'package:al_bahrawi/features/chat/domain/model/firebase_chat_config.dart';
import 'package:al_bahrawi/common/network/failure.dart';
import 'package:al_bahrawi/common/network/either.dart';

abstract class ChatApiDataSource {
  Future<Either<Failure, CreateChatResponse>> createChat(int supplierId);
  Future<Either<Failure, FirebaseChatConfig>> getFirebaseToken(int purchaseOrderId);
  Future<Either<Failure, List<MessageModel>>> getChatMessages(int chatId, {int page = 1});
  Future<Either<Failure, MessageModel>> sendMessage(int chatId, {String? body, String? imagePath});
  Future<Either<Failure, List<ChatModel>>> getChats();
}

class ChatApiDataSourceImpl implements ChatApiDataSource {
  @override
  Future<Either<Failure, CreateChatResponse>> createChat(int supplierId) {
    return DioHelper.postData(
      url: EndPoints.chats,
      data: {'supplier_id': supplierId},
      fromJson: (json) => CreateChatResponse.fromJson(json['data']),
    );
  }

  @override
  Future<Either<Failure, FirebaseChatConfig>> getFirebaseToken(int purchaseOrderId) {
    return DioHelper.getData(
      url: EndPoints.firebaseToken(purchaseOrderId),
      fromJson: (json) => FirebaseChatConfig.fromJson(json['data']),
    );
  }

  @override
  Future<Either<Failure, List<MessageModel>>> getChatMessages(int chatId, {int page = 1}) async {
    return DioHelper.getData(
      url: EndPoints.chatMessages(chatId),
      query: {'page': page, 'limit': 30},
      fromJson: (json) {
        List data = [];
        if (json['data'] is List) {
          data = json['data'] as List;
        } else if (json['data'] is Map) {
          final dataMap = Map<String, dynamic>.from(json['data'] as Map);
          data = dataMap['messages'] as List? ?? dataMap['data'] as List? ?? [];
        }
        return data.map((e) => MessageModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      },
    );
  }

  @override
  Future<Either<Failure, MessageModel>> sendMessage(int chatId, {String? body, String? imagePath}) async {
    final Map<String, dynamic> data = {};
    
    // Support new payload format: type, message, file
    if (imagePath != null) {
      data['type'] = 'image';
      data['file'] = await MultipartFile.fromFile(imagePath);
      if (body != null) data['message'] = body;
    } else {
      data['type'] = 'text';
      if (body != null) {
        data['message'] = body;
        data['body'] = body; // backward-compatibility support
      }
    }

    return DioHelper.postData(
      url: EndPoints.chatMessages(chatId),
      data: FormData.fromMap(data),
      fromJson: (json) {
        return MessageModel.fromJson(Map<String, dynamic>.from(json['data'] as Map));
      },
    );
  }

  @override
  Future<Either<Failure, List<ChatModel>>> getChats() {
    return DioHelper.getData(
      url: EndPoints.chatConversations,
      fromJson: (json) {
        final List data = json['data'] ?? [];
        return data.map((e) => ChatModel.fromJson(e)).toList();
      },
    );
  }
}
