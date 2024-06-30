import 'package:flutter_football/domain/models/conversation.dart';
import 'package:flutter_football/domain/models/message.dart';

enum MessageStatus { initial, loading, success, addSuccess, error }

class MessageState {
  final MessageStatus status;
  final List<Message>? messages;
  final String error;

  MessageState({
    this.status = MessageStatus.initial,
    this.messages = const [],
    this.error = '',
  });

  MessageState copyWith({
    MessageStatus? status,
    List<Message>? messages,
    String? error,
  }) {
    return MessageState(
        status: status ?? this.status,
        messages: messages ?? this.messages,
        error: error ?? this.error);
  }
}
