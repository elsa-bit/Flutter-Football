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
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(
            error: errorMessage, status: ConversationStatus.error));
      }
    });

    on<GetConversationCoach>((event, emit) async {
      try {
        emit(state.copyWith(status: ConversationStatus.loading));
        final conversations = await repository.getConversationCoach();
        emit(state.copyWith(
            conversations: conversations, status: ConversationStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(
            error: errorMessage, status: ConversationStatus.error));
      }
    });

    on<SubscribeToConversation>((event, emit) async {
      try {
        await _subscription?.cancel();
        List<Conversation> updatesConversations = List.empty();
        await for (final eventConversation
            in repository.subscribeToConversation()) {
          if (event.mode == 'player') {
            var idPlayer = preferences.getIdPlayer();
            if (eventConversation.conversation.players.contains(idPlayer)) {
              if (eventConversation.eventType == PostgresChangeEvent.insert) {
                updatesConversations =
                    List<Conversation>.from(state.conversations!)
                      ..insert(0, eventConversation.conversation);
              } else if (eventConversation.eventType ==
                  PostgresChangeEvent.update) {
                updatesConversations =
                    List<Conversation>.from(state.conversations!);
                int index = updatesConversations.indexWhere(
                    (c) => c.id == eventConversation.conversation.id);
                if (index != -1) {
                  updatesConversations[index].date =
                      eventConversation.conversation.date;
                  updatesConversations.sort((a, b) => b.date.compareTo(a.date));
                }
              }
              emit(state.copyWith(
                  conversations: updatesConversations,
                  status: ConversationStatus.success));
            }
          } else if (event.mode == 'coach') {
            var idCoach = preferences.getIdCoach();
            if (eventConversation.conversation.coach == idCoach) {
              if (eventConversation.eventType == PostgresChangeEvent.insert) {
                updatesConversations =
                    List<Conversation>.from(state.conversations!)
                      ..insert(0, eventConversation.conversation);
              } else if (eventConversation.eventType ==
                  PostgresChangeEvent.update) {
                updatesConversations =
                    List<Conversation>.from(state.conversations!);
                int index = updatesConversations.indexWhere(
                    (c) => c.id == eventConversation.conversation.id);
                if (index != -1) {
                  updatesConversations[index].date =
                      eventConversation.conversation.date;
                  updatesConversations.sort((a, b) => b.date.compareTo(a.date));
                }
              }
              emit(state.copyWith(
                  conversations: updatesConversations,
                  status: ConversationStatus.success));
            }
          }
        }
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(
            error: errorMessage, status: ConversationStatus.error));
      }
    });

    on<AddConversation>((event, emit) async {
      emit(state.copyWith(status: ConversationStatus.loading));
      try {
        await repository.addConversation(event.players);
        emit(state.copyWith(status: ConversationStatus.addSuccess));
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(
            error: errorMessage, status: ConversationStatus.addError));
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
