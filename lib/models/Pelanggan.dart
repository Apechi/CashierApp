// To parse this JSON data, do
//
//     final pelangganData = pelangganDataFromJson(jsonString);

import 'dart:convert';

PelangganData pelangganDataFromJson(String str) =>
    PelangganData.fromJson(json.decode(str));

String pelangganDataToJson(PelangganData data) => json.encode(data.toJson());

class PelangganData {
  int status;
  List<Datum> data;

  PelangganData({
    required this.status,
    required this.data,
  });

  factory PelangganData.fromJson(Map<String, dynamic> json) => PelangganData(
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
  String nama;
  String email;
  String nomorTelepon;
  String alamat;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.nama,
    required this.email,
    required this.nomorTelepon,
    required this.alamat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        nama: json["nama"],
        email: json["email"],
        nomorTelepon: json["nomor_telepon"],
        alamat: json["alamat"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "email": email,
        "nomor_telepon": nomorTelepon,
        "alamat": alamat,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
