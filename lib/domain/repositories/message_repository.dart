import 'package:flutter_football/data/data_sources/conversation_data_source.dart';
import 'package:flutter_football/data/data_sources/message_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/conversation.dart';
import 'package:flutter_football/domain/models/message.dart';

class MessageRepository {
  final MessageDataSource messageDataSource;

  MessageRepository({
    required this.messageDataSource,
  });

  Stream<List<Message>> getMessageConversation(String idConversation) {
    try {
      final messages = messageDataSource.getMessageConversation(idConversation);
      return messages;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Stream<Message> subscribeToMessages() {
    try {
      return messageDataSource.subscribeToMessage();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<String> addMessage(Message message) {
    return messageDataSource.addMessage(message);
  }
}
