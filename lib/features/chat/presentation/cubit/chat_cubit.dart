import 'dart:async';
import 'package:al_bahrawi/app/app_prefs.dart';
import 'package:al_bahrawi/app/pagination_helper.dart';
import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/common/network/either.dart';
import 'package:al_bahrawi/common/network/failure.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_bahrawi/features/chat/domain/model/message_model.dart';
import 'package:al_bahrawi/features/chat/domain/repo/chat_repo.dart';

class ChatCubit extends Cubit<BaseState<MessageModel>> {
  final ChatRepo _chatRepo;
  final AppPreferences _appPreferences;
  StreamSubscription? _firebaseSubscription;
  final Set<String> _messageIds = {};
  late final PaginationHandler<MessageModel, ChatCubit> paginationHandler;

  ChatCubit(this._chatRepo, this._appPreferences) : super(const BaseState()) {
    paginationHandler = PaginationHandler<MessageModel, ChatCubit>(
      bloc: this,
    );
  }

  Future<void> initChat(int chatId) async {
    emit(state.copyWith(status: Status.loading, items: []));
    _messageIds.clear();

    // 1. Init Firebase Real-time (Start listening early to avoid missing messages)
    _setupRealtimeChat(chatId);

    // 2. Fetch History
    await paginationHandler.loadFirstPage(
      (page, limit, [params]) => _chatRepo.getChatMessages(chatId, page: page),
    );

    if (state.isSuccess) {
       for (var msg in state.items) {
         _messageIds.add(msg.id.toString());
       }
    }
  }

  Future<void> _setupRealtimeChat(int chatId) async {
    final result = await _chatRepo.getFirebaseToken(chatId);
    result.fold(
      (failure) => null,
      (config) async {
        await _chatRepo.initFirebaseChat(config);
        _firebaseSubscription?.cancel();
        _firebaseSubscription = _chatRepo.messagesStream.listen((message) {
          _handleIncomingMessage(message as MessageModel);
        });
      },
    );
  }

  Future<Either<Failure, List<MessageModel>>> getChatMessages({
    required int chatId,
    required int page,
  }) async {
    final result = await _chatRepo.getChatMessages(chatId, page: page);
    result.fold((l) => null, (messages) {
      for (var msg in messages) {
        _messageIds.add(msg.id.toString());
      }
    });
    return result;
  }

  void _handleIncomingMessage(MessageModel message) {
    final messageIdStr = message.id.toString();
    
    // 1. Check if ID already exists (Exact match)
    final existingIndex = state.items.indexWhere((m) => m.id.toString() == messageIdStr);
    
    if (existingIndex != -1) {
      // Update existing message (e.g. to fill in attachment_url from API response)
      final List<MessageModel> updatedItems = List.from(state.items);
      updatedItems[existingIndex] = message;
      emit(state.copyWith(items: updatedItems));
    } else {
      // 2. Reconciliation: Is it a "Me" message that might be a replacement for a temp?
      if (message.senderType == 'user') {
        // Find the last (oldest) matching temp message that hasn't been replaced yet
        final tempIndex = state.items.lastIndexWhere((m) => 
          m.id.toString().startsWith('temp_') && 
          m.type == message.type &&
          (m.body == message.body || (m.type == 'image' && m.attachmentUrl != null))
        );
          
        if (tempIndex != -1) {
          // Found a matching temp message! Reconcile it now.
          final tempIdStr = state.items[tempIndex].id.toString();
          _messageIds.remove(tempIdStr);
          _messageIds.add(messageIdStr);
          
          final List<MessageModel> updatedItems = List.from(state.items);
          updatedItems[tempIndex] = message;
          emit(state.copyWith(items: updatedItems));
          return;
        }
      }
      
      // 3. New message or no temp match: Add to list
      _messageIds.add(messageIdStr);
      final updatedMessages = [message, ...state.items]; 
      emit(state.copyWith(items: updatedMessages));
    }
  }

  Future<void> sendMessage(int chatId, String? messageText, {String? imagePath}) async {
    if (messageText == null && imagePath == null) return;
    
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final myId = _appPreferences.getUserId();
    
    // 1. Create Optimistic Message
    final optimisticMessage = MessageModel(
      id: tempId,
      senderId: myId,
      senderType: 'user', // Set sender type explicitly
      type: imagePath != null ? 'image' : 'text',
      body: messageText,
      attachmentUrl: imagePath, // Use local path for preview
      createdAt: DateTime.now().toIso8601String(),
    );

    // 2. Add to list immediately
    _handleIncomingMessage(optimisticMessage);
    
    // 3. Call API
    final result = await _chatRepo.sendMessage(chatId, message: messageText, imagePath: imagePath);
    
    result.fold(
      (failure) {
        // Remove optimistic message on failure
        final updatedItems = state.items.where((m) => m.id.toString() != tempId).toList();
        emit(state.copyWith(items: updatedItems));
        _messageIds.remove(tempId);
      },
      (message) {
        // Replace optimistic message with real message
        final List<MessageModel> updatedItems = List.from(state.items);
        final index = updatedItems.indexWhere((m) => m.id.toString() == tempId);
        
        if (index != -1) {
          updatedItems[index] = message;
          _messageIds.remove(tempId);
          _messageIds.add(message.id.toString());
          emit(state.copyWith(items: updatedItems));
        } else {
          _handleIncomingMessage(message);
        }
      },
    );
  }

  @override
  Future<void> close() {
    _firebaseSubscription?.cancel();
    _chatRepo.disposeFirebaseChat();
    return super.close();
  }
}
