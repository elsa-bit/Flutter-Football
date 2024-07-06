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

class ClearConversationState extends ConversationEvent {
  ClearConversationState();
}

class GetConversationCoach extends ConversationEvent {
  GetConversationCoach();
}

