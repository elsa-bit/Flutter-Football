
class Endpoints {
  Endpoints._();

  static const String localHostURL = '10.0.2.2:3000';

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
}