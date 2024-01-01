import 'dart:js';

import 'package:cashierfe/pages/auth.dart';
import 'package:cashierfe/pages/home/home.dart';
import 'package:cashierfe/pages/login/authentication.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashierfe/constant.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) {
        {}
      }),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, title: 'CashierApp', home: MyAuthCheck());
  }
}
