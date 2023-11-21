// To parse this JSON data, do
//
//     final jenisData = jenisDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

JenisData jenisDataFromJson(String str) => JenisData.fromJson(json.decode(str));

String jenisDataToJson(JenisData data) => json.encode(data.toJson());

class JenisData {
    int status;
    List<Datum> data;

    JenisData({
        required this.status,
        required this.data,
    });

    factory JenisData.fromJson(Map<String, dynamic> json) => JenisData(
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
    int kategoriId;
    String namaJenis;
    DateTime createdAt;
    DateTime updatedAt;
    Kategori kategori;

    Datum({
        required this.id,
        required this.kategoriId,
        required this.namaJenis,
        required this.createdAt,
        required this.updatedAt,
        required this.kategori,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        kategoriId: json["kategori_id"],
        namaJenis: json["nama_jenis"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        kategori: Kategori.fromJson(json["kategori"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "kategori_id": kategoriId,
        "nama_jenis": namaJenis,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "kategori": kategori.toJson(),
    };
}

class Kategori {
    int id;
    String name;
    DateTime createdAt;
    DateTime updatedAt;

    Kategori({
        required this.id,
        required this.name,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Kategori.fromJson(Map<String, dynamic> json) => Kategori(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
