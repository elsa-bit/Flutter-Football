import 'dart:convert';

import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/data/services/match_service.dart';
import 'package:flutter_football/networking/endpoints.dart';
import 'package:flutter_football/networking/exceptions_factory.dart';
import 'package:flutter_football/domain/models/match.dart';
import 'package:http/http.dart';


class MatchDataSource extends BaseDataSource with MatchService {


  Future<String> getMatchesDetails(int idCoach) async {
    final queryParameters = {
      'idcoach': idCoach.toString(),
    };
    final response = await httpGet(Endpoints.matchDetailsPath, queryParameters);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory().handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }


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

  @override
  Future<Response> addCard(int idMatch, String idPlayer, String color) async {
    final queryParameters = {
      'idmatch': idMatch.toString(),
      'idplayer': idPlayer,
      'color': color,
    };
    return await httpPost(Endpoints.addCardPath, queryParameters);
  }

  @override
  Future<Response> addGoal(int idMatch, String? idPlayer) async {
    final queryParameters;
    if (idPlayer != null) {
      queryParameters = {
        'idmatch': idMatch.toString(),
        'idplayer': idPlayer,
        'fromOpponent': (idPlayer == null).toString(),
      };
    } else {
      queryParameters = {
        'idmatch': idMatch.toString(),
        'fromOpponent': (idPlayer == null).toString(),
      };
    }
    return await httpPost(Endpoints.addGoalPath, queryParameters);
  }

  @override
  Future<Response> addReplacement(int idMatch, String idPlayerOut, String idPlayerIn, String? reason) async {
    final queryParameters;
    if (reason != null && reason.isNotEmpty) {
      queryParameters = {
        'idmatch': idMatch.toString(),
        'idplayerOut': idPlayerOut,
        'idplayerIn': idPlayerIn,
        'reason': reason.toString(),
      };
    } else {
      queryParameters = {
        'idmatch': idMatch.toString(),
        'idplayerOut': idPlayerOut.toString(),
        'idplayerIn': idPlayerIn.toString(),
      };
    }
    return await httpPost(Endpoints.addReplacementPath, queryParameters);
  }

  @override
  Future<Response> getActions(int idMatch) async {
    final queryParameters = {
      'idmatch': idMatch.toString(),
    };
    return await httpGet(Endpoints.getActionsPath, queryParameters);
  }

  @override
  Future<Response> getSelection(int idMatch, String idTeam) {
    final queryParameters = {
      'idmatch': idMatch.toString(),
      'idteam': idTeam,
    };
    return httpGet(Endpoints.getSelectionPath, queryParameters);
  }

  @override
  Future<Response> setFmiReport(int idMatch, String? commentTeam, String? commentOpponent) {
    final queryParameters = {
      'idmatch': idMatch.toString(),
      'commentTeam': commentTeam,
      'commentOpponent': commentOpponent,
    };
    return httpPostBody(Endpoints.setFmiReportPath, queryParameters);
  }

  @override
  Future<Response> setSelection(int idMatch, String idTeam, List<String> idPlayers) {
    final queryParameters = {
      'idmatch': idMatch.toString(),
      'idteam': idTeam,
      'idplayers': idPlayers,
    };
    return httpPostBody(Endpoints.setSelectionPath, queryParameters);
  }

}
