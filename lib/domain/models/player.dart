class Player {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String? avatar;
  final int matchPlayed;
  final String? position;
  final String? birthday;
  final String? num_licence;
  final List<String>? teams;
  final int goal;
  final int redCard;
  final int yellowCard;

  Player({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.avatar,
    required this.matchPlayed,
    this.position,
    this.birthday,
    this.num_licence,
    this.teams,
    required this.goal,
    required this.redCard,
    required this.yellowCard,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final String firstname = json["firstname"] as String;
      final String lastname = json["lastname"] as String;
      final String email = json["email"] as String;
      final String? avatar = json["avatar"] as String?;
      final int matchPlayed = json["matchPlayed"] as int;
      final String? position = json["position"] as String?;
      final String? birthday = json["birthday"] as String?;
      final String? num_licence = json["num_licence"] as String?;
      final List<String>? teams =
          (json["idTeams"] as List<dynamic>?)?.map((e) => e as String).toList();
      final int goal = json["goal"] as int;
      final int redCard = json["redCard"] as int;
      final int yellowCard = json["yellowCard"] as int;

      return Player(
        id: id,
        firstname: firstname,
        lastname: lastname,
        email: email,
        avatar: avatar,
        matchPlayed: matchPlayed,
        position: position,
        birthday: birthday,
        num_licence: num_licence,
        teams: teams,
        goal: goal,
        redCard: redCard,
        yellowCard: yellowCard,
      );
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Player data.');
    }
  }
}
