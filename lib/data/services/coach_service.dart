import 'package:flutter_football/domain/models/user.dart';

abstract class CoachService {
  Future<Coach> getCoachDetails(String idcoach);
}