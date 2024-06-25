import 'package:flutter_football/domain/models/message.dart';

abstract class MessageService {
  Stream<List<Message>> getMessageConversation(String idconversation);

  Future<String> addMessage(Message message);
}