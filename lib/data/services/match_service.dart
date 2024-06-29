import 'package:flutter_football/domain/models/match.dart';
import 'package:http/http.dart';

abstract class MatchService {
  Future<List<Match>> getMatches(List<int> idTeams);
  Future<List<Match>> getMatch(int idTeam);
  Future<Response> addGoal(int idMatch, int? idPlayer);
  Future<Response> addCard(int idMatch, int idPlayer, String color);
  Future<Response> addReplacement(int idMatch, int idPlayerOut, int idPlayerIn, String? reason);
  Future<Response> getActions(int idMatch);
}