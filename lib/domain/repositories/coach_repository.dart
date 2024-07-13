import 'package:flutter_football/data/data_sources/coach_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/user.dart';

class CoachRepository {
  final CoachDataSource coachDataSource;
  SharedPreferencesDataSource preferencesDataSource;

  CoachRepository({
    required this.coachDataSource,
    required this.preferencesDataSource,
  });

  Future<Coach> getCoachDetails() async {
    final idCoach = preferencesDataSource.getIdCoach();

    try {
      final detailsCoach =
          await coachDataSource.getCoachDetails(idCoach.toString());
      return detailsCoach;
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
