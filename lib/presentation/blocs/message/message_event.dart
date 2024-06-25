import 'package:flutter_football/domain/models/message.dart';

abstract class MessageEvent {}

class GetMessagePlayer extends MessageEvent {
  String idConversation;

  GetMessagePlayer({required this.idConversation});
}

class AddMessage extends MessageEvent {
  Message message;

  AddMessage({required this.message});
}
