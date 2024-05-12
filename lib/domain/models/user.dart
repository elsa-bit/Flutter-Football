
class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final String email = json["email"] as String;
      final String firstName = json["firstName"] as String;
      final String lastName = json["lastName"] as String;

      return User(id: id, email: email, firstName: firstName, lastName: lastName);
    } catch(e) {
      print(e);
      throw const FormatException('Failed to convert User data.');
    }
  }

}