import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cashierfe/models/Category.dart';
import 'package:cashierfe/pages/custom_drawer.dart';
import 'package:cashierfe/pages/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  CategoryData? categoryData;

  getBASEURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('BASEURL').toString();
    String url = "$value/category";
    return url;
  }

  getTOKEN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('TOKEN').toString();
    return value;
  }
  //CRUD METHOD

  Future<void> deleteItem(int? id) async {
    bool? shouldDelete = await showConfirmationDialog(context);

    if (shouldDelete == null || !shouldDelete) return;

    String url = await getBASEURL();
    String token = await getTOKEN();

    http.Response res = await http.delete(
      Uri.parse("$url/$id"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      getData(); // Refresh the ListView
    }
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
        categoryData = categoryDataFromJson(res.body);
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> createItem(String name) async {
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

  Future<void> editItem(String name, int? id) async {
    String url = await getBASEURL();
    String token = await getTOKEN();

    try {
      http.Response res = await http.put(
        Uri.parse("$url/$id"),
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

  //Modal PopUp

  Future<bool?> showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apa anda yakin ingin menghapus Item ini?"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Batal"),
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Hapus")),
          ],
        );
      },
    );
  }

  final TextEditingController categoryNameController = TextEditingController();

  Future<void> showCreateModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Form(
            child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: categoryNameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Kategori",
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
                  createItem(categoryNameController.text);
                  Navigator.of(context).pop();
                },
                child: const Text('Create'),
              ),
            )
          ],
        ));
      },
    );
  }

  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }

  Future<void> showEditModal(
      BuildContext context, int? id, String? name) async {
    categoryNameController.text = name.toString();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Form(
            child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: categoryNameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Kategori",
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
                  editItem(categoryNameController.text, id);
                  Navigator.of(context).pop();
                },
                child: const Text('Edit'),
              ),
            )
          ],
        ));
      },
    );
  }

  //variable UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const appBaru(title: "Manage Category"),
        endDrawer: const drawerBar(),
        body: Column(
          children: [
            menuAtas(),
            listCategory(context),
          ],
        ));
  }

  Container listCategory(BuildContext context) {
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
                onRefresh: () {
                  setState(() {});
                  return getData();
                },
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
                                child: Text(
                                  categoryData?.data[index].name ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    color: Colors.orange,
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showEditModal(
                                          context,
                                          categoryData?.data[index].id,
                                          categoryData?.data[index].name);
                                    },
                                  ),
                                  IconButton(
                                    color: Colors.red,
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      int? id = categoryData?.data[index].id;
                                      deleteItem(id);
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
                  itemCount: categoryData?.data.length,
                ),
              ),
            ),
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
                  'Category',
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
}
