 import 'package:shared_preferences/shared_preferences.dart';

getBASEURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('BASEURL').toString();
    String url = "$value/menu";
    return url;
  }

  getBASEURLJENIS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('BASEURL').toString();
    String url = "$value/type";
    return url;
  }

  getTOKEN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('TOKEN').toString();
    return value;
  }