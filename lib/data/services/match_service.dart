import 'package:flutter_football/domain/models/match.dart';

abstract class MatchService {
  Future<List<Match>> getMatches(List<int> idTeams);
  Future<List<Match>> getMatch(int idTeam);
}