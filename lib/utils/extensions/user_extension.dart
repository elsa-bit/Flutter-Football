import 'package:supabase_flutter/supabase_flutter.dart';



extension UserData on User {

  String? getFirstname() {
    try {
      return this.userMetadata?["firstname"] as String;
    } catch(e) {
      return null;
    }
  }

  String? getLastname() {
    try {
      return this.userMetadata?["lastname"] as String;
    } catch(e) {
      return null;
    }
  }

  String? getRole() {
    try {
      return this.userMetadata?["role"] as String;
    } catch(e) {
      return null;
    }
  }
}