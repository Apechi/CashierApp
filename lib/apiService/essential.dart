import 'package:shared_preferences/shared_preferences.dart';

class APIEssential {
  static Future<String> GetToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('TOKEN').toString();
    return value;
  }

  static Future<String> getBASEURLJENIS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('BASEURL').toString();
    return value;
  }
}
