import 'dart:core';

import 'package:cashierfe/apiService/essential.dart';
import 'package:cashierfe/constant.dart';
import 'package:cashierfe/models/Jenis.dart';
import 'package:diox/diox.dart';
import 'package:shared_preferences/shared_preferences.dart';

//JENIS
class JenisDioService {
  final Dio _dio = Dio();
  final url = Constant.BASE_URL;

  
  Future<List<Kategori>> getKategori() async {
    Dio dio = Dio();
    var base = Constant.BASE_URL;
    String url = "$base/category";
    String token = await APIEssential.GetToken();

    Response response = await dio.get(url,
        options: Options(
            headers: {"Authorization": "Bearer $token"},
            responseType: ResponseType.json));

    if (response.statusCode == 200) {
      List<Kategori> items = [];
      var jsonData = response.data as List;
      for (var element in jsonData) {
        items.add(Kategori(
            id: element["id"],
            name: element["name"],
            createdAt: element["createdAt"],
            updatedAt: element["updatedAt"]));
      }
      return items;
    } else {
      throw Exception("Error! Couldn't get data from server");
    }
  }

  Future<Response> getJenis() async {
    String test = "$url/type";
    String token = await APIEssential.GetToken();
    return await _dio.get("$url/type",
        options: Options(
            headers: {"Authorization": "Bearer $token"},
            responseType: ResponseType.json,
            contentType: Headers.jsonContentType));
  }

  Future<Response> removeJenis(String id) async {
    String token = await APIEssential.GetToken();
    return _dio.delete("$url/type/$id",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }));
  }

  Future<Response> addJenis(Map data) async {
    String token = await APIEssential.GetToken();
    return _dio.post(
      "$url/type",
      data: data,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer $token"
        },
      ),
    );
  }

  Future<Response> updateJenis(Map data, String id) async {
    String token = await APIEssential.GetToken();
    return _dio.put('$url/type/$id',
        data: data,
        options: Options(headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer $token"
        }));
  }
}
