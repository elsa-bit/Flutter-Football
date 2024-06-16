import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/data/services/team_service.dart';

import '../../networking/endpoints.dart';
import '../../networking/exceptions_factory.dart';

class TeamDataSource extends BaseDataSource with TeamService {

  @override
  Future<String> getCoachTeams(int coachId) async {
    final queryParameters = {
      'idcoach': coachId.toString()
    };
    final response = await httpGet(Endpoints.coachTeamsPath, queryParameters);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory().handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

  @override
  Future<String> getTeam(int teamId) async {
    final response = await httpGet(Endpoints.teamPath);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory().handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

  @override
  Future<String> getTeamPlayers(int teamId) async {
    final queryParameters = {
      'idteam': '$teamId'
    };
    final response = await httpGet(Endpoints.coachTeamsPath, queryParameters);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw ExceptionsFactory().handleStatusCode(response.statusCode);
    }
  }
}