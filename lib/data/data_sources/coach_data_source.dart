import 'dart:convert';
import 'dart:async';

import 'package:flutter_football/data/services/coach_service.dart';
import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/domain/models/user.dart';
import 'package:flutter_football/networking/endpoints.dart';
import 'package:flutter_football/networking/exceptions_factory.dart';

class CoachDataSource extends BaseDataSource with CoachService {
  @override
  Future<Coach> getCoachDetails(String idcoach) async {
    final queryParameters = {'idcoach': idcoach};
    final response =
        await httpGet(Endpoints.detailsCoachPath, queryParameters);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)["info"] as Map<String, dynamic>;
      return Coach.fromJson(data);
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory()
          .handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }
}
