import 'package:flutter_football/domain/models/conversation.dart';

enum ConversationStatus { initial, loading, success, addSuccess, error, addError }

class ConversationState {
  final ConversationStatus status;
  final List<Conversation>? conversations;
  final String error;

  ConversationState({
    this.status = ConversationStatus.initial,
    this.conversations = const [],
    this.error = '',
  });

  ConversationState copyWith({
    ConversationStatus? status,
    List<Conversation>? conversations,
    String? error,
  }) {
    return ConversationState(
        status: status ?? this.status,
        conversations: conversations ?? this.conversations,
        error: error ?? this.error);
  }
}
