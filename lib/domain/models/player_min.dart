class PlayerMin {
  final String email;
  final String? avatar;
  final String? position;
  final String? birthday;
  final String? password;

  PlayerMin({
    required this.email,
    this.avatar,
    this.position,
    this.birthday,
    this.password
  });

  factory PlayerMin.fromJson(Map<String, dynamic> json) {
    try {
      final String email = json["email"] as String;
      final String? avatar = json["avatar"] as String?;
      final String? position = json["position"] as String?;
      final String? birthday = json["birthday"] as String?;

      return PlayerMin(
        email: email,
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
