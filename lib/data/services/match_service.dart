import 'package:flutter_football/domain/models/match.dart';
import 'package:flutter_football/domain/models/player_comment.dart';
import 'package:http/http.dart';

abstract class MatchService {
  Future<List<Match>> getMatches(List<int> idTeams);
  Future<List<Match>> getMatch(int idTeam);
  Future<Response> addGoal(int idMatch, String? idPlayer);
  Future<Response> addCard(int idMatch, String idPlayer, String color);
  Future<Response> addReplacement(int idMatch, String idPlayerOut, String idPlayerIn, String? reason);
  Future<Response> getActions(int idMatch);
  Future<Response> getSelection(int idMatch, String idTeam);
  Future<Response> setSelection(int idMatch, String idTeam, List<String> idPlayers);
  Future<Response> setFmiReport(int idMatch, String? commentTeam, String? commentOpponent, List<PlayerComment>? playerComments);
}