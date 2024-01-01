// To parse this JSON data, do
//
//     final loginData = loginDataFromJson(jsonString);

import 'dart:convert';

LoginData loginDataFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginDataToJson(LoginData data) => json.encode(data.toJson());

class LoginData {
  String token;

  LoginData({
    required this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
