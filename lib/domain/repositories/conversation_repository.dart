import 'package:flutter_football/data/data_sources/conversation_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/conversation.dart';

class ConversationRepository {
  final ConversationDataSource conversationDataSource;
  final SharedPreferencesDataSource preferences;

  ConversationRepository({
    required this.conversationDataSource,
    required this.preferences,
  });

  Future<List<Conversation>> getConversationPlayer() async {
    try {
      final idPlayer = preferences.getIdPlayer();

      return await conversationDataSource
          .getConversationPlayer(idPlayer!);
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<List<Conversation>> getConversationCoach() async {
    try {
      final idCoach = preferences.getIdCoach();

      return await conversationDataSource
          .getConversationCoach(idCoach!);
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Stream<ConversationEventRealtime> subscribeToConversation() {
    try {
      return conversationDataSource.subscribeToConversation();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<String> addConversation(String players) {
    final idCoach = preferences.getIdCoach();

    return conversationDataSource.addConversation(players, idCoach.toString());
  }
}
