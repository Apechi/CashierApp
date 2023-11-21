// To parse this JSON data, do
//
//     final menuData = menuDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MenuData menuDataFromJson(String str) => MenuData.fromJson(json.decode(str));

String menuDataToJson(MenuData data) => json.encode(data.toJson());

class MenuData {
    int status;
    List<Datum> data;

    MenuData({
        required this.status,
        required this.data,
    });

    factory MenuData.fromJson(Map<String, dynamic> json) => MenuData(
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
    int jenisId;
    String namaMenu;
    int harga;
    String deskripsi;
    DateTime createdAt;
    DateTime updatedAt;
    Jenis jenis;

    Datum({
        required this.id,
        required this.jenisId,
        required this.namaMenu,
        required this.harga,
        required this.deskripsi,
        required this.createdAt,
        required this.updatedAt,
        required this.jenis,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        jenisId: json["jenis_id"],
        namaMenu: json["nama_menu"],
        harga: json["harga"],
        deskripsi: json["deskripsi"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        jenis: Jenis.fromJson(json["jenis"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "jenis_id": jenisId,
        "nama_menu": namaMenu,
        "harga": harga,
        "deskripsi": deskripsi,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "jenis": jenis.toJson(),
    };
}

class Jenis {
    int id;
    int kategoriId;
    String namaJenis;
    DateTime createdAt;
    DateTime updatedAt;

    Jenis({
        required this.id,
        required this.kategoriId,
        required this.namaJenis,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Jenis.fromJson(Map<String, dynamic> json) => Jenis(
        id: json["id"],
        kategoriId: json["kategori_id"],
        namaJenis: json["nama_jenis"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "kategori_id": kategoriId,
        "nama_jenis": namaJenis,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
