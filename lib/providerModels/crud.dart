import 'dart:convert';

import 'package:cashierfe/apiService/apiService.dart';
import 'package:cashierfe/apiService/dioService.dart';
import 'package:cashierfe/models/Jenis.dart';
import 'package:flutter/foundation.dart';

class CRUDType extends ChangeNotifier {
  final JenisDioService _api = JenisDioService();

  Future<JenisData> fetchJenis() async {
    return _api.getJenis().then((res) {
      return JenisData.fromJson(res.data);
    }).catchError((onError) {
      print("$onError");
    });
  }

  Future removeJenis(String id) {
    return _api.removeJenis(id).then((_) {
      notifyListeners();
    }).catchError((onError) {
      print(onError);
    });
  }

  Future updateJenis(JenisData data, String id) {
    return _api
        .updateJenis(data.toJson(), id)
        .then((_) => notifyListeners())
        .catchError((onError) {
      print('$onError');
    });
  }

  Future addJenis(JenisData data) {
    return _api
        .addJenis(data.toJson())
        .then((value) => notifyListeners())
        .catchError((onError) {
      print(' $onError');
    });
  }
}
