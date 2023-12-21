import 'dart:convert';

import 'package:cashierfe/models/Menu.dart';
import 'package:cashierfe/models/Jenis.dart';
import 'package:cashierfe/pages/menu/api_service.dart';
import 'package:cashierfe/pages/menu/global_var.dart';
import 'package:flutter/material.dart';
import 'package:cashierfe/pages/custom_drawer.dart';
import 'package:cashierfe/pages/custom_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashierfe/pages/menu/create.dart';
import 'package:cashierfe/pages/menu/edit.dart';
import 'package:cashierfe/pages/menu/get_pref.dart';

class JenisList {
  int id;
  String namaJenis;

  JenisList({required this.id, required this.namaJenis});
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => MenuState();
}

class MenuState extends State<Menu> {
  @override
  void initState() {
    super.initState();
    getData(setState);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refreshData() async {
    await getData(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const appBaru(
        title: "Manage Menu",
      ),
      endDrawer: const drawerBar(),
      body: Column(children: [menuAtas(), listMenu(context)]),
    );
  }

  Column menuAtas() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 17.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: const Text(
                  'Menu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              IconButton(
                  onPressed: () => showCreateModal(context, setState),
                  icon: const Icon(Icons.add, size: 37, color: Colors.green)),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: const Divider(
            color: Colors.black,
            thickness: 3,
          ),
        )
      ],
    );
  }

  Future<bool?> showConfirmationDialog(BuildContext context, int? id) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apa anda yakin ingin menghapus Item ini?"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),
                onPressed: () {
                  deleteItem(id, setState);
                  Navigator.of(context).pop();
                },
                child: const Text("Hapus")),
          ],
        );
      },
    );
  }

  Container listMenu(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height * .6,
              child: RefreshIndicator(
                onRefresh: refreshData,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Card(
                        color: const Color(0xFF77BC4D),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      menuData?.data[index].namaMenu ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      menuData?.data[index].jenis.namaJenis ??
                                          'N/A',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8),
                                      child: Text(
                                        menuData?.data[index].deskripsi ??
                                            'N/A',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Rp. ${menuData?.data[index].harga.toString()}" ??
                                          'N/A',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      color: Colors.orange,
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => showEditModal(
                                          context,
                                          {
                                            'id': menuData?.data[index].id,
                                            'nama':
                                                menuData?.data[index].namaMenu,
                                            'jenis':
                                                menuData?.data[index].jenisId,
                                            'harga':
                                                menuData?.data[index].harga,
                                            'deskripsi':
                                                menuData?.data[index].deskripsi
                                          },
                                          setState)),
                                  IconButton(
                                    color: Colors.red,
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      int? id = menuData?.data[index].id;
                                      showConfirmationDialog(context, id);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: menuData?.data.length,
                ),
              ),
            ),
    );
  }
}
