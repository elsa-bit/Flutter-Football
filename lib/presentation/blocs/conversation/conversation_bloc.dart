import 'package:bloc/bloc.dart';
import 'package:flutter_football/domain/repositories/conversation_repository.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_event.dart';
import 'package:flutter_football/presentation/blocs/conversation/conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ConversationRepository repository;

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
  }
}
