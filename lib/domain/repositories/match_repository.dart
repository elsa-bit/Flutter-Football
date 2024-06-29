import 'dart:convert';

import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/data/data_sources/match_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/fmi/card.dart';
import 'package:flutter_football/domain/models/fmi/goal.dart';
import 'package:flutter_football/domain/models/fmi/match_action.dart';
import 'package:flutter_football/domain/models/fmi/replacement.dart';
import 'package:flutter_football/domain/models/match.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:http/http.dart';

class MatchRepository {
  final MatchDataSource matchDataSource;
  SharedPreferencesDataSource preferencesDataSource;

  MatchRepository({
    required this.matchDataSource,
    required this.preferencesDataSource,
  });

  Future<List<MatchDetails>> getMatchesDetails() async {
    try {
      final idCoach = preferencesDataSource.getIdCoach();
      if(idCoach == null) {
        throw Exception("idCoach is null");
      }

      final response = await matchDataSource.getMatchesDetails(idCoach);
      final data = jsonDecode(response)["matchs"] as List<dynamic>;
      return List<MatchDetails>.from(data.map((model)=> MatchDetails.fromJson(model)));
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<List<Match>> getMatches() async {
    try {
      final idTeams = preferencesDataSource.getTeamsIds();
      return await matchDataSource.getMatches(idTeams ?? []);
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<Card> addCard(int idMatch, int idPlayer, String color) async {
    try {
      final response = await matchDataSource.addCard(idMatch, idPlayer, color);
      if(response.statusCode != 200) throw Exception(); // TODO : throw exception FMICardCreationException

      final body = response.body;
      final data = jsonDecode(body)["card"] as Map<String, dynamic>;
      return Card.fromJson(data);
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<Goal> addGoal(int idMatch, int? idPlayer) async {
    try {
      final response = await matchDataSource.addGoal(idMatch, idPlayer);
      if(response.statusCode != 200) throw Exception(); // TODO : throw exception FMIGoalCreationException

      final body = response.body;
      final data = jsonDecode(body)["goal"] as Map<String, dynamic>;
      return Goal.fromJson(data);
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<Replacement> addReplacement(int idMatch, int idPlayerOut, int idPlayerIn, String? reason) async {
    try {
      final response = await matchDataSource.addReplacement(idMatch, idPlayerOut, idPlayerIn, reason);
      if(response.statusCode != 200) throw Exception(); // TODO : throw exception FMIReplacementCreationException

      final body = response.body;
      final data = jsonDecode(body)["replacement"] as Map<String, dynamic>;
      return Replacement.fromJson(data);
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<List<MatchAction>> getActions(int idMatch) async {
    try {
      final response = await matchDataSource.getActions(idMatch);
      if(response.statusCode != 200) throw Exception(); // TODO : throw exception FMICardCreationException

      final body = response.body;
      final cardsData = jsonDecode(body)["cards"] as List<dynamic>;
      final cards = List<CardAction>.from(cardsData.map((model) {
        final card = Card.fromJson(model);
        return CardAction(
          id: "card-${card.id}",
          createdAt: card.createdAt,
          assetName: (card.color == "yellow")
              ? "assets/yellow_card.svg"
              : "assets/red_card.svg",
          card: card,
        );
      }));

      final replacementsData = jsonDecode(body)["replacements"] as List<dynamic>;
      final replacements = List<ReplacementAction>.from(replacementsData.map((model) {
        final replacement = Replacement.fromJson(model);
        return ReplacementAction(
          id: "replacement-${replacement.id}",
          createdAt: replacement.createdAt,
          assetName: "assets/replacement_icon.svg",
          replacement: replacement,
        );
      }));

      final goalsData = jsonDecode(body)["goals"] as List<dynamic>;
      final goals = List<GoalAction>.from(goalsData.map((model) {
        final goal = Goal.fromJson(model);
        return GoalAction(
          id: "goal-${goal.id}",
          createdAt: goal.createdAt,
          assetName: "assets/football_icon.svg",
          assetTint: goal.fromOpponent ? AppColors.red : AppColors.green,
          goal: goal,
        );
      }));

      List<MatchAction> actions = [];
      actions.addAll(cards);
      actions.addAll(replacements);
      actions.addAll(goals);
      actions.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return actions;
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
