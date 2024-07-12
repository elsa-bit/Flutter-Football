
class Endpoints {
  Endpoints._();

  static const String localHostURL = '192.168.1.107:3000'; //192.168.1.107:3000 - 10.0.2.2:3000
  static const String prodURL = 'api-csbretigny.vercel.app';

  static const String baseURL = localHostURL;

  static const int receiveTimeout = 5000;

  static const int connectionTimeout = 3000;


  static const String accessPlayerPath = '/api/playerAccess';

  // login paths
  static const String loginAdmin = '/api/loginAdmin';
  static const String loginCoach = '/api/loginCoach';
  static const String loginPlayer = '/api/loginPlayer';
  static const String logout = '/api/logout';

  // team paths
  static const String teamPath = '/api/team';
  static const String coachTeamsPath = '/api/teamsCoach';
  static const String teamPlayersPath = '/api/playersTeam';
  static const String specificTeamPlayerPath = '/api/teamsPlayer';

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

  //player paths
  static const String modifyPlayerPath = '/api/modifyPlayer';
  static const String coachPlayerPath = '/api/coachTeams';
  static const String specificVideosPlayerPath = '/api/videosPlayer';
  static const String newStatisticPlayerPath = '/api/newStatisticPlayer';
  static const String updateProfilePicturePath = '/api/updateProfilePicture';

  //tchat paths
  static const String conversationPlayerPath = '/api/conversationPlayer';
  static const String messageConversationPath = '/api/messageConversation';
  static const String createMessageConversationPath = '/api/addMessage';
  static const String subscribeMessageConversationPath = '/api/subscribeToMessage';
  static const String conversationCoachPath = '/api/conversationCoach';
  static const String playersTeamsPath = '/api/playersTeams';
  static const String createConversationPath = '/api/createConversation';

  //match paths
  static const String matchDetailsPath = '/api/getCoachMatchesDetails';
  static const String teamMatchPath = '/api/matchsTeam';
  static const String addReplacementPath = '/api/addReplacement';
  static const String addCardPath = '/api/addCard';
  static const String addGoalPath = '/api/addGoal';
  static const String getActionsPath = '/api/getActions';
  static const String getSelectionPath = '/api/getSelection';
  static const String setSelectionPath = '/api/setSelection';
  static const String setFmiReportPath = '/api/setFmiReport';

}