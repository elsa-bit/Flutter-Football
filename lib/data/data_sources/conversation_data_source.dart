import 'dart:convert';
import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/data/services/conversation_service.dart';
import 'package:flutter_football/domain/models/conversation.dart';
import 'package:flutter_football/networking/endpoints.dart';
import 'package:flutter_football/networking/exceptions_factory.dart';

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
}
