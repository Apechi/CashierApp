import 'dart:convert';

import 'package:cashierfe/constant.dart';
import 'package:cashierfe/models/Jenis.dart';
import 'package:cashierfe/models/Menu.dart';

import 'package:cashierfe/pages/menu/get_pref.dart';
import 'package:cashierfe/pages/menu/global_var.dart';
import 'package:cashierfe/pages/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> getData(Function updateState) async {
  String url = "${Constant.BASE_URL}/menu";
  String token = await getTOKEN();

  try {
    http.Response res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      menuData = menuDataFromJson(res.body);
      await getJenis();
      isLoading = false;
      updateState(() {});
      
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

getJenis() async {
  String url = "${Constant.BASE_URL}/type";
  String token = await getTOKEN();
  http.Response res = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (res.statusCode == 200) {
    final jenisData = jenisDataFromJson(res.body);
    jenisList.clear();
    for (var item in jenisData.data) {
      jenisList.add(JenisList(id: item.id, namaJenis: item.namaJenis));
    }
  }
}

Future<void> createItem(
    String name, int harga, String deskripsi, int jenisId, Function updateState) async {
  String url = "${Constant.BASE_URL}/menu";
  String token = await getTOKEN();

  try {
    http.Response res = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "nama_menu": name,
        "harga": harga,
        "deskripsi": deskripsi,
        "jenis_id": jenisId
      }),
    );
    if (res.statusCode == 200) {
      getData(updateState);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

 Future<void> deleteItem(int? id, Function updateState) async {
   

  

    String url = "${Constant.BASE_URL}/menu";
    String token = await getTOKEN();

    http.Response res = await http.delete(
      Uri.parse("$url/$id"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      getData(updateState); // Refresh the ListView
    }
  }