import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/data/services/message_service.dart';
import 'package:flutter_football/domain/models/message.dart';
import 'package:flutter_football/main.dart';
import 'package:flutter_football/networking/endpoints.dart';
import 'package:flutter_football/networking/exceptions_factory.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageDataSource extends BaseDataSource with MessageService {
  @override
  Stream<List<Message>> getMessageConversation(String idconversation) async* {
    final queryParameters = {'idconversation': idconversation};
    final response =
        await httpGet(Endpoints.messageConversationPlayerPath, queryParameters);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)["messages"];
      final messages =
          List<Message>.from(data.map((model) => Message.fromJson(model)));
      yield messages;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory()
          .handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

  @override
  Stream<Message> subscribeToMessage() {
    final StreamController<Message> controller = StreamController<Message>();

    final channel = supabase
        .channel('todos')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'message',
          callback: (payload) {
            final newMessage = Message.fromJson(payload.newRecord);
            controller.add(newMessage);
          },
        )
        .subscribe();

    controller.onCancel = () {
      channel.unsubscribe();
    };

    return controller.stream;
  }

  void getMessage(Map<String, dynamic> message) {
    debugPrint("-------------MESSAGE---------");
    debugPrint(message.toString());
    var result = Message.fromJson(message);
    debugPrint(result.toString());
  }

  @override
  Future<String> addMessage(Message message) async {
    final queryParameters = {
      'idconversation': message.idConversation.toString(),
      'message': message.message,
      'idsender': message.idSender.toString(),
      'role': message.role,
    };
    final response = await httpPost(
        Endpoints.createMessageConversationPath, queryParameters);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory()
          .handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }
}
