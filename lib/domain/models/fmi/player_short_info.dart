class PlayerShortInfo {
  final int id;
  final String firstname;
  final String lastname;
  final String position;

  PlayerShortInfo(this.id, this.firstname, this.lastname, this.position);

  factory PlayerShortInfo.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final String firstname = json["firstname"] as String;
      final String lastname = json["lastname"] as String;
      final String position = json["position"] as String;

      return PlayerShortInfo(id, firstname, lastname, position);
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert PlayerShortInfo data.');
    }
  }
}