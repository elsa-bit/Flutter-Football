
class Endpoints {
  Endpoints._();

  static const String localHostURL = 'http://localhost:3000/api';

  static const String prodURL = '';

  static const String baseURL = localHostURL;

  static const int receiveTimeout = 5000;

  static const int connectionTimeout = 3000;

  // login paths
  static const String loginAdmin = '/loginAdmin';
  static const String loginCoach = '/loginCoach';
  static const String loginPlayer = '/loginPlayer';

  // team paths
  static const String teamPath = '/team';
  static const String coachTeamsPath = '/teamsCoach';
}