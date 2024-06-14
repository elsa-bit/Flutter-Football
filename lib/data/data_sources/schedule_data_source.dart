import 'dart:convert';

import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/data/services/schedule_service.dart';
import 'package:flutter_football/domain/models/event.dart';
import 'package:http/http.dart';
import '../../networking/endpoints.dart';
import '../../networking/exceptions_factory.dart';

class ScheduleDataSource extends BaseDataSource with ScheduleService {
  @override
  Future<ScheduleResult> getSchedule(int idcoach, String idteams) async {
    final queryParameters = {'idcoach': idcoach.toString(), 'idteams': idteams};
    final response = await httpGet(Endpoints.schedulePath, queryParameters);
    if (response.statusCode == 200) {
      return ScheduleResult.fromJson(jsonDecode(response.body));
    } else {
      throw ExceptionsFactory().handleStatusCode(response.statusCode);
    }
  }

  @override
  Future<String> addSchedule(Event event, DateTime date) async {
    late Response response;

    if (event.type == 'match') {
      final queryParameters = {
        'place': event.place,
        'idteam': event.team,
        'opponentName': event.opponentName,
        'date': date.toString(),
      };
      response =
          await httpPost(Endpoints.scheduleCreateMatchPath, queryParameters);
    } else if (event.type == 'training') {
      final queryParameters = {
        'place': event.place,
        'idteam': event.team,
        'date': date.toString(),
      };
      response =
          await httpPost(Endpoints.scheduleCreateTrainingPath, queryParameters);
    }
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw ExceptionsFactory().handleStatusCode(response.statusCode);
    }
  }
}
