import 'dart:convert';

import 'package:cashierfe/models/Menu.dart';
import 'package:cashierfe/models/Jenis.dart';
import 'package:flutter/material.dart';
import 'package:cashierfe/pages/custom_drawer.dart';
import 'package:cashierfe/pages/custom_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
    getJenis();
  }

  String? _selectedJenis;
  MenuData? menuData;
  List<String> jenisList = [];

  getJenis() async {
    String url = await getBASEURLJENIS();
    String token = await getTOKEN();
    http.Response res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      final jenisData = jenisDataFromJson(res.body);
      for (var item in jenisData.data) {
        jenisList.add({"nama_jenis": item.namaJenis, "id_jenis": item.id_jenis}
            as String);
      }
      _isLoading = false;
      setState(() {});
    }
  }

  getBASEURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('BASEURL').toString();
    String url = "$value/menu";
    return url;
  }

  getBASEURLJENIS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('BASEURL').toString();
    String url = "$value/jenis";
    return url;
  }

  getTOKEN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('TOKEN').toString();
    return value;
  }

  Future<void> getData() async {
    String url = await getBASEURL();
    String token = await getTOKEN();

    try {
      http.Response res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        menuData = menuDataFromJson(res.body);
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final TextEditingController categoryNameController = TextEditingController();

//CREATE

  Future<void> showCreateModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Form(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: categoryNameController,
                      decoration: const InputDecoration(
                        labelText: "",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: categoryNameController,
                      decoration: const InputDecoration(
                        labelText: "",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: categoryNameController,
                      decoration: const InputDecoration(
                        labelText: "",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: categoryNameController,
                      decoration: const InputDecoration(
                        labelText: "",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // background color
                    ),
                    onPressed: () {
                      // createItem(categoryNameController.text);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Create'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> createItem(
      String name, int harga, String deskripsi, int jenisId) async {
    String url = await getBASEURL();
    String token = await getTOKEN();

    try {
      http.Response res = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"name": name}),
      );
      if (res.statusCode == 200) {
        return getData();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //END CREATE

  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
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
                  onPressed: () => showCreateModal(context),
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

  Container listMenu(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: _isLoading
          ? const Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height * .6,
              child: RefreshIndicator(
                onRefresh: getData,
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
                                    onPressed: () {
                                      // showEditModal(
                                      //     context,
                                      //     menuData?.data[index].id,
                                      //     menuData?.data[index].name);
                                    },
                                  ),
                                  IconButton(
                                    color: Colors.red,
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      // int? id = categoryData?.data[index].id;
                                      // deleteItem(id);
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
