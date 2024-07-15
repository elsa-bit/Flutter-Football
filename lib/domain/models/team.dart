
class Team {
  final int id;
  final String name;
  Team({
    required this.id,
    required this.name,
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