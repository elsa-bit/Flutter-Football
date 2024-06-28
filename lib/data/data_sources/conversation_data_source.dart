import 'dart:async';
import 'dart:convert';
import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/data/services/conversation_service.dart';
import 'package:flutter_football/domain/models/conversation.dart';
import 'package:flutter_football/main.dart';
import 'package:flutter_football/networking/endpoints.dart';
import 'package:flutter_football/networking/exceptions_factory.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationDataSource extends BaseDataSource with ConversationService {
  @override
  Future<List<Conversation>> getConversationPlayer(String idplayer) async {
    final queryParameters = {'idplayer': idplayer};

    final response =
        await httpGet(Endpoints.conversationPlayerPath, queryParameters);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)["conversations"];
      return List<Conversation>.from(
          data.map((model) => Conversation.fromJson(model)));
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory()
          .handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

  @override
  Stream<Conversation> subscribeToConversation() {
    final StreamController<Conversation> controller =
        StreamController<Conversation>();

    final channel = supabase
        .channel('todos')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'conversation',
          callback: (payload) {
            final newConversation = Conversation.fromJson(payload.newRecord);
            controller.add(newConversation);
          },
        )
        .subscribe();

    controller.onCancel = () {
      channel.unsubscribe();
    };

    return controller.stream;
  }
}
