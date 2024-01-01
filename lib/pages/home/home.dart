import 'package:cashierfe/pages/custom_appbar.dart';
import 'package:cashierfe/pages/custom_drawer.dart';
import 'package:flutter/material.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const appBaru(title: "Home"),
        endDrawer: const drawerBar(),
        body: Column(
          children: [
            menuAtas(),
          ],
        ));
  }

  Column menuAtas() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 17.5),
          child: Container(
            child: const Text(
              'Buka Navigasi Menu Untuk Mulai',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: const Divider(
            color: Colors.black,
            thickness: 3,
          ),
        ),
      ],
    );
  }
}
