import 'package:shared_preferences/shared_preferences.dart';

getTOKEN() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String value = prefs.getString('TOKEN').toString();
  return value;
}
