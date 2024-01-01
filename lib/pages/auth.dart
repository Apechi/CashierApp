import 'package:cashierfe/pages/home/home.dart';
import 'package:cashierfe/pages/login/authentication.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAuthCheck extends StatefulWidget {
  const MyAuthCheck({super.key});

  @override
  State<MyAuthCheck> createState() => _MAuthCheckState();
}

class _MAuthCheckState extends State<MyAuthCheck> {
  bool? isLoggedIn = false;

  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool("LOGGEDIN");
    isLoggedIn = loggedIn;
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn! ? const MyHome() : const MyLoginPage(),
    );
  }
}
