import 'package:flutter_football/domain/models/conversation.dart';

abstract class ConversationService {
  Future<List<Conversation>> getConversationPlayer(String idplayer);

  Future<List<Conversation>> getConversationCoach(int idcoach);

  Stream<ConversationEventRealtime> subscribeToConversation();
}