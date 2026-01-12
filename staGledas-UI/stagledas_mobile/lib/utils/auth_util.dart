class Authorization {
  static int? id;
  static String? username;
  static String? password;
  static String? fullName;
  static String? email;
  static String? slika;
  static bool isPremium = false;
}

class AuthUtil {
  static Future<int?> getCurrentUserId() async {
    return Authorization.id;
  }

  static Future<Map<String, String>?> getCredentials() async {
    if (Authorization.username == null || Authorization.password == null) {
      return null;
    }
    return {
      'username': Authorization.username!,
      'password': Authorization.password!,
    };
  }
}
