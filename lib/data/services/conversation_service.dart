import 'package:flutter_football/domain/models/conversation.dart';

abstract class ConversationService {
  Future<List<Conversation>> getConversationPlayer(String idplayer);
}