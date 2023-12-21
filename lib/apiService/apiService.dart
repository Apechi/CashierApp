import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<String> GetToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('TOKEN').toString();
    return value;
  }

  static Future<dynamic> fetchData(String url,
      Map<String, dynamic>? data, String? method) async {
    String token = await GetToken();
    try {
      http.Response response;
      switch (method) {
        case 'GET':
          response = await http.get(
            Uri.parse(url),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
            },
          );
          break;
        case 'POST':
          response = await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(data),
          );
          break;
        case 'PUT':
          response = await http.put(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(data),
          );
          break;
        case 'DELETE':
          response = await http.delete(
            Uri.parse(url),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
            },
          );
          break;
        default:
          throw Exception('Invalid method');
      }

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }
}
