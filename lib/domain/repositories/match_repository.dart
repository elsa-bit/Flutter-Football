import 'package:flutter_football/data/data_sources/match_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/match.dart';

class MatchRepository {
  final MatchDataSource matchDataSource;
  SharedPreferencesDataSource preferencesDataSource;

  MatchRepository({
    required this.matchDataSource,
    required this.preferencesDataSource,
  });

  Future<List<Match>> getMatches() async {
    try {
      final idTeams = preferencesDataSource.getTeamsIds();
      return await matchDataSource.getMatches(idTeams ?? []);
    } catch (error) {
      print(error);
      rethrow;
    }
  }

}
