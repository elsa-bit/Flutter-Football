import 'package:bloc/bloc.dart';
import 'package:flutter_football/domain/repositories/message_repository.dart';
import 'package:flutter_football/presentation/blocs/message/message_event.dart';
import 'package:flutter_football/presentation/blocs/message/message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository repository;

  MessageBloc({required this.repository}) : super(MessageState()) {
    on<GetMessagePlayer>((event, emit) async {
      try {
        emit(state.copyWith(status: MessageStatus.loading));
        await for (var messages
            in repository.getMessageConversation(event.idConversation)) {
          emit(state.copyWith(
              messages: messages.reversed.toList(),
              status: MessageStatus.success));
        }
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: MessageStatus.error,
        ));
      }
    });

    on<AddMessage>((event, emit) async {
      emit(state.copyWith(status: MessageStatus.loading));
      try {
        await repository.addMessage(event.message);
        emit(state.copyWith(status: MessageStatus.addSuccess));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: MessageStatus.error));
      }
    });
  }
}
