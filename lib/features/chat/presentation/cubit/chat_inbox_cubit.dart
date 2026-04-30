import 'package:al_bahrawi/common/base/base_state.dart';
import 'package:al_bahrawi/features/chat/domain/model/chat_model.dart';
import 'package:al_bahrawi/features/chat/domain/repo/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInboxCubit extends Cubit<BaseState<ChatModel>> {
  final ChatRepo _chatRepo;

  ChatInboxCubit(this._chatRepo) : super(const BaseState());

  Future<void> getChats() async {
    emit(state.copyWith(status: Status.loading));

    final result = await _chatRepo.getChats();

    result.fold(
      (failure) => emit(state.copyWith(status: Status.failure, failure: failure)),
      (chats) => emit(state.copyWith(status: Status.success, items: chats)),
    );
  }
}
