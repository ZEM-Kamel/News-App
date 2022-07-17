import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static var sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putData({
    required bool isDark,
  }) async {
    return await sharedPreferences.setBool('isDark', isDark);
  }

  static bool getData() {
    return sharedPreferences.getBool('isDark');
  }
}
