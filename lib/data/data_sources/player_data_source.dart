import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/data/services/player_service.dart';
import '../../networking/endpoints.dart';
import '../../networking/exceptions_factory.dart';

class PlayerDataSource extends BaseDataSource with PlayerService {
  @override
  Future<String> getPlayersTeam(String idteam) async {
    final queryParameters = {'idteam': idteam};
    final response = await httpGet(Endpoints.playersTeamPath, queryParameters);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory().handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }
}
