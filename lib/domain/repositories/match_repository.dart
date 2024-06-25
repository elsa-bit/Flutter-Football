import 'dart:convert';

import 'package:flutter_football/data/data_sources/match_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
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

  Future<Response> addCard(int idMatch, int idPlayer, String color) async {
    return await matchDataSource.addCard(idMatch, idPlayer, color);
  }

  Future<Response> addGoal(int idMatch, int? idPlayer) async {
    return await matchDataSource.addGoal(idMatch, idPlayer);
  }

  Future<Response> addReplacement(int idMatch, int idPlayerOut, int idPlayerIn, String? reason) async {
    return await matchDataSource.addReplacement(idMatch, idPlayerOut, idPlayerIn, reason);
  }

}
