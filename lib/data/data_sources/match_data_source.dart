import 'dart:convert';

import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/data/services/match_service.dart';
import 'package:flutter_football/networking/endpoints.dart';
import 'package:flutter_football/networking/exceptions_factory.dart';
import 'package:flutter_football/domain/models/match.dart';


class MatchDataSource extends BaseDataSource with MatchService {

  @override
  Future<List<Match>> getMatches(List<int> idTeams) async {
    List<Match> matches = [];
    for (var id in idTeams) {
      final result = await getMatch(id);
      matches.addAll(result);
    }
    return matches;
  }

  @override
  Future<List<Match>> getMatch(int idTeam) async {
    final queryParameters = {'idteam': idTeam.toString()};
    final response = await httpGet(Endpoints.teamMatchPath, queryParameters);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)["matchs"] as List<dynamic>;
      return List<Match>.from(data.map((model) => Match.fromJson(model)));
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory()
          .handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

}
