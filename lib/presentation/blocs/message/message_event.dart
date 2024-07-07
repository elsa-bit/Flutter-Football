import 'package:flutter_football/domain/models/message.dart';

abstract class MessageEvent {}

class GetMessage extends MessageEvent {
  String idConversation;

  GetMessage({required this.idConversation});
}

class SubscribeToMessages extends MessageEvent {
  String idConversation;

  SubscribeToMessages({required this.idConversation});
}

class AddMessage extends MessageEvent {
  Message message;

  AddMessage({required this.message});
}

class ClearMessageState extends MessageEvent {
  ClearMessageState();
}
