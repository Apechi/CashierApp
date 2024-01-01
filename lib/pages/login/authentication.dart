import 'dart:convert';

import 'package:cashierfe/constant.dart';
import 'package:cashierfe/models/Login.dart';
import 'package:cashierfe/pages/custom_appbar.dart';
import 'package:cashierfe/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MLoginPageState();
}

class _MLoginPageState extends State<MyLoginPage> {
  void saveData(String token, bool loggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("TOKEN", token);
    await prefs.setBool("LOGGEDIN", loggedIn);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyHome()));
  }

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  Center loginField() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: email,
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            obscureText: true,
            controller: password,
            decoration: const InputDecoration(
              hintText: 'Enter your password',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              login();
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    String url = "${Constant.BASE_URL}/login";
    String emailText = email.text;
    String passwordText = password.text;
    var loginData;

    try {
      http.Response res = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"email": emailText, "password": passwordText}),
      );
      if (res.statusCode == 200) {
        LoginData loginData = loginDataFromJson(res.body);
        saveData(loginData.token, true);
      } else {
        debugPrint(res.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const appBaru(title: "Login"),
      body: Container(padding: const EdgeInsets.all(8.0), child: loginField()),
    );
  }
}
