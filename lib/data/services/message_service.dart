import 'package:flutter_football/domain/models/message.dart';

abstract class MessageService {
  Stream<List<Message>> getMessageConversation(String idconversation);

  Stream<Message> subscribeToMessage();

  Future<String> addMessage(Message message);
}