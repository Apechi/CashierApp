// To parse this JSON data, do
//
//     final mejaData = mejaDataFromJson(jsonString);

import 'dart:convert';

MejaData mejaDataFromJson(String str) => MejaData.fromJson(json.decode(str));

String mejaDataToJson(MejaData data) => json.encode(data.toJson());

class MejaData {
  int status;
  List<Datum> data;

  MejaData({
    required this.status,
    required this.data,
  });

  factory MejaData.fromJson(Map<String, dynamic> json) => MejaData(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  int nomorMeja;
  int kapasitas;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.nomorMeja,
    required this.kapasitas,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        nomorMeja: json["nomor_meja"],
        kapasitas: json["kapasitas"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nomor_meja": nomorMeja,
        "kapasitas": kapasitas,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
