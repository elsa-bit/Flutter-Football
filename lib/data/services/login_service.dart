
abstract class LoginService {
  Future<String> loginAdmin(String email, String password);
  Future<String> loginPlayer(String email, String password);
  Future<String> loginCoach(String email, String password);
}