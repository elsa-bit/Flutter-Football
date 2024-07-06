import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_football/domain/models/message.dart';
import 'package:flutter_football/domain/repositories/message_repository.dart';
import 'package:flutter_football/presentation/blocs/message/message_event.dart';
import 'package:flutter_football/presentation/blocs/message/message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository repository;
  StreamSubscription<Message>? _subscription;

  MessageBloc({required this.repository}) : super(MessageState()) {
    on<GetMessage>((event, emit) async {
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

    on<SubscribeToMessages>((event, emit) async {
      try {
        await _subscription?.cancel();
        List<Message> updatesMessages = List.empty();
        await for (final message in repository.subscribeToMessages()) {
          if (message.idConversation.toString() == event.idConversation) {
            updatesMessages = List<Message>.from(state.messages!)
              ..insert(0, message);
            emit(state.copyWith(
                messages: updatesMessages, status: MessageStatus.success));
          }
        }
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: MessageStatus.error));
      }
    });

    on<AddMessage>((event, emit) async {
      try {
        await repository.addMessage(event.message);
        emit(state.copyWith(status: MessageStatus.addSuccess));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: MessageStatus.error));
      }
    });

    on<ClearMessageState>((event, emit) async {
      emit(MessageState());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
