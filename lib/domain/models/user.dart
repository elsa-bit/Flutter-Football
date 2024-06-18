class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;

  User(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.lastName});
}

class Coach extends User {
  Coach(
      {required super.id,
      required super.email,
      required super.firstName,
      required super.lastName});

  factory Coach.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["idCoach"] as int;
      final String email = json["email"] as String;
      final String firstName = json["firstname"] as String;
      final String lastName = json["lastname"] as String;

      return Coach(
          id: id, email: email, firstName: firstName, lastName: lastName);
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Coach data.');
    }
  }
}

class Member extends User {
  final List<int> teamsId;

  Member({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required this.teamsId,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    try {
      print(json);
      final int id = json["idPlayer"] as int;
      final String email = json["email"] as String;
      final String firstName = json["firstname"] as String;
      final String lastName = json["lastname"] as String;
      //final String teamsId = json["idTeams"] as List<int>;

      return Member(
          id: id,
          email: email,
          firstName: firstName,
          lastName: lastName,
          teamsId: []);
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Coach data.');
    }
  }
}
