abstract class ConversationEvent {}

class GetConversationPlayer extends ConversationEvent {
  GetConversationPlayer();
}

class SubscribeToConversation extends ConversationEvent {
  SubscribeToConversation();
}
