
class Endpoints {
  Endpoints._();

  static const String localHostURL = '10.0.2.2:3000';

  static const String prodURL = 'api-csbretigny.vercel.app';

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
  static const String addFriendPath = '/api/updateFriend';
  static const String friendPlayerPath = '/api/friendsPlayer';

  //match paths
  static const String matchDetailsPath = '/api/getCoachMatchesDetails';
  static const String teamMatchPath = '/api/matchsTeam';
  static const String addReplacementPath = '/api/addReplacement';
  static const String addCardPath = '/api/addCard';
  static const String addGoalPath = '/api/addGoal';

}