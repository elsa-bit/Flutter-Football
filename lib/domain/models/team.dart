
class Team {
  final int id;
  final String name;
  //final List<String> coachIds;
  //final bool playerAccessEnabled;

  Team({
    required this.id,
    required this.name,
    //required this.coachIds,
    //required this.playerAccessEnabled
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final String name = json["name"] as String;

      return Team(id: id, name: name);
    } catch(e) {
      print(e);
      throw const FormatException('Failed to convert Team data.');
    }
  }
}