
class Endpoints {
  Endpoints._();

  static const String localHostURL = '192.168.1.107:3000';
  //'10.0.2.2:3000';

  static const String prodURL = '';

  static const String baseURL = localHostURL;

  static const int receiveTimeout = 5000;

  static const int connectionTimeout = 3000;

  // login paths
  static const String loginAdmin = '/api/loginAdmin';
  static const String loginCoach = '/api/loginCoach';
  static const String loginPlayer = '/api/loginPlayer';

  // team paths
  static const String teamPath = '/api/team';
  static const String coachTeamsPath = '/api/teamsCoach';

  //schedule paths
  static const String schedulePath = '/api/eventsCoach';
  static const String scheduleCreateMatchPath = '/api/createMatch';
  static const String scheduleCreateTrainingPath = '/api/createTraining';
  static const String playersTeamPath = '/api/playersTeam';
  static const String addAttendanceSchedule = '/api/updateAttendanceTraining';

}