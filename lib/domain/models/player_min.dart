class PlayerMin {
  final String? avatar;
  final String? position;
  final String? birthday;
  final String? password;

  PlayerMin({
    this.avatar,
    this.position,
    this.birthday,
    this.password
  });

  factory PlayerMin.fromJson(Map<String, dynamic> json) {
    try {
      final String? avatar = json["avatar"] as String?;
      final String? position = json["position"] as String?;
      final String? birthday = json["birthday"] as String?;

      return PlayerMin(
        avatar: avatar,
        position: position,
        birthday: birthday,
      );
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert PlayerMin data.');
    }
  }
}
