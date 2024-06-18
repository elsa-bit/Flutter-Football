
class Endpoints {
  Endpoints._();

  static const String localHostURL = 'api-csbretigny.vercel.app';

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
  static const String teamPlayersPath = '/api/playersTeam';

  //schedule paths
  static const String schedulePath = '/api/eventsCoach';
  static const String scheduleCreateMatchPath = '/api/createMatch';
  static const String scheduleCreateTrainingPath = '/api/createTraining';
  static const String playersTeamPath = '/api/playersTeam';
  static const String addAttendanceSchedule = '/api/updateAttendanceTraining';
  static const String schedulePlayerPath = '/api/eventsPlayer';

  //statistic paths
  static const String detailsPlayerPath = '/api/detailsPlayer';

}