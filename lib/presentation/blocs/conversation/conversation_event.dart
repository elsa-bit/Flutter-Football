abstract class ConversationEvent {}

class GetConversationPlayer extends ConversationEvent {
  GetConversationPlayer();
}

class SubscribeToConversation extends ConversationEvent {
  final String mode;

  SubscribeToConversation({
    required this.mode
  });
}

class AddConversation extends ConversationEvent {
  final String players;

  AddConversation({
    required this.players
  });
}

class ClearConversationState extends ConversationEvent {
  ClearConversationState();
}

class GetConversationCoach extends ConversationEvent {
  GetConversationCoach();
}

