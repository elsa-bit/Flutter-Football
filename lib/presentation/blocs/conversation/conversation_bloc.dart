import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/conversation.dart';
import 'package:flutter_football/domain/repositories/conversation_repository.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_event.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ConversationRepository repository;
  StreamSubscription<Conversation>? _subscription;
  SharedPreferencesDataSource preferences = SharedPreferencesDataSource();

  ConversationBloc({required this.repository}) : super(ConversationState()) {
    on<GetConversationPlayer>((event, emit) async {
      try {
        emit(state.copyWith(status: ConversationStatus.loading));
        final conversations = await repository.getConversationPlayer();
        emit(state.copyWith(
            conversations: conversations, status: ConversationStatus.success));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: ConversationStatus.error,
        ));
      }
    });

    on<SubscribeToConversation>((event, emit) async {
      try {
        await _subscription?.cancel();
        List<Conversation> updatesConversations = List.empty();
        await for (final event in repository.subscribeToMessages()) {
          var idPlayer = preferences.getIdPlayer();
          if (event.conversation.players.contains(idPlayer.toString())) {
            if (event.eventType == PostgresChangeEvent.insert) {
              updatesConversations =
                  List<Conversation>.from(state.conversations!)
                    ..insert(0, event.conversation);
            } else if (event.eventType == PostgresChangeEvent.update) {
              updatesConversations =
                  List<Conversation>.from(state.conversations!);
              int index = updatesConversations
                  .indexWhere((c) => c.id == event.conversation.id);
              if (index != -1) {
                updatesConversations[index].date = event.conversation.date;
                updatesConversations.sort((a, b) => b.date.compareTo(a.date));
              }
            }
            emit(state.copyWith(
                conversations: updatesConversations,
                status: ConversationStatus.success));
          }
        }
      } catch (e) {
        emit(state.copyWith(
            error: e.toString(), status: ConversationStatus.error));
      }
    });

    on<ClearConversationState>((event, emit) async {
      emit(ConversationState());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
