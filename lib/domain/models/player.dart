class Player {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String? avatar;
  final String? position;
  final int matchPlayed;
  final List<String>? teams;

  Player({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.avatar,
    required this.position,
    required this.matchPlayed,
    required this.teams,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final String firstname = json["firstname"] as String;
      final String lastname = json["lastname"] as String;
      final String email = json["email"] as String;
      final String? avatar = json["avatar"] as String?;
      final String? position = json["position"] as String?;
      final int? matchPlayed = json["matchPlayed"] as int?;
      final List<String>? teams = json["idTeams"] as List<String>?;

      return Player(
        id: id,
        firstname: firstname,
        lastname: lastname,
        email: email,
        avatar: avatar,
        position: position,
        matchPlayed: matchPlayed ?? 0,
        teams: teams,
      );
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Player data.');
    }
  }
}
