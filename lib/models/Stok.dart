// To parse this JSON data, do
//
//     final stokData = stokDataFromJson(jsonString);

import 'dart:convert';

StokData stokDataFromJson(String str) => StokData.fromJson(json.decode(str));

String stokDataToJson(StokData data) => json.encode(data.toJson());

class StokData {
    int status;
    List<Datum> data;

    StokData({
        required this.status,
        required this.data,
    });

    factory StokData.fromJson(Map<String, dynamic> json) => StokData(
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
    int menuId;
    int jumlah;
    DateTime createdAt;
    DateTime updatedAt;
    Menu menu;

    Datum({
        required this.id,
        required this.menuId,
        required this.jumlah,
        required this.createdAt,
        required this.updatedAt,
        required this.menu,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        menuId: json["menu_id"],
        jumlah: json["jumlah"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        menu: Menu.fromJson(json["menu"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "menu_id": menuId,
        "jumlah": jumlah,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "menu": menu.toJson(),
    };
}

class Menu {
    int id;
    int jenisId;
    String namaMenu;
    int harga;
    String deskripsi;
    DateTime createdAt;
    DateTime updatedAt;

    Menu({
        required this.id,
        required this.jenisId,
        required this.namaMenu,
        required this.harga,
        required this.deskripsi,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["id"],
        jenisId: json["jenis_id"],
        namaMenu: json["nama_menu"],
        harga: json["harga"],
        deskripsi: json["deskripsi"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "jenis_id": jenisId,
        "nama_menu": namaMenu,
        "harga": harga,
        "deskripsi": deskripsi,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
