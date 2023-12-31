import 'package:cashierfe/models/User.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cashierfe/pages/custom_drawer.dart';
import 'package:cashierfe/pages/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashierfe/constant.dart';

class PenggunaPage extends StatefulWidget {
  const PenggunaPage({super.key});

  @override
  State<PenggunaPage> createState() => _PenggunaPageState();
}

class _PenggunaPageState extends State<PenggunaPage> {
  late Future<UserData?> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = getData();
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

    String url = "${Constant.BASE_URL}/users";
    String token = await getTOKEN();

    http.Response res = await http.delete(
      Uri.parse("$url/$id"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      setState(() {}); // Refresh the ListView
    }
  }

  Future<UserData?> getData() async {
    String url = "${Constant.BASE_URL}/users";
    String token = await getTOKEN();

    try {
      http.Response res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        return userDataFromJson(res.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> createItem(Map<String, dynamic> item) async {
    String url = "${Constant.BASE_URL}/users";
    String token = await getTOKEN();

    String name = item['name'].toString();
    String email = item['email'].toString();
    String password = item['password'].toString();

    try {
      http.Response res = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );
      if (res.statusCode == 200) {
        setState(() {});
      } else {
        debugPrint(res.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> editItem(Map<String, dynamic> data) async {
    var id = data['id'];
    String name = data['name'].toString();
    String email = data['email'].toString();
    var password = data['password'].toString();

    String url = "${Constant.BASE_URL}/users";
    String token = await getTOKEN();

    try {
      http.Response res = await http.put(
        Uri.parse("$url/$id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: password.isNotEmpty
            ? jsonEncode({"name": name, "email": email, "password": password})
            : jsonEncode({"name": name, "email": email}),
      );
      if (res.statusCode == 200) {
        setState(() {});
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

  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> showCreateModal(BuildContext context) async {
    namaController.clear();
    emailController.clear();
    passwordController.clear();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Form(
            child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 7, 20, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 7, 20, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
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
                  createItem({
                    'name': namaController.text,
                    'email': emailController.text,
                    'password': passwordController.text,
                  });
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
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> showEditModal(
      BuildContext context, Map<String, dynamic> data) async {
    var id = data['id'];
    namaController.text = data['name'].toString();
    emailController.text = data['email'].toString();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Form(
            child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 7, 20, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 7, 20, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "New Password",
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
                  editItem({
                    'id': id,
                    'name': namaController.text,
                    'password': passwordController.text,
                    'email': emailController.text
                  });
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
        appBar: const appBaru(title: "Manage Users"),
        endDrawer: const drawerBar(),
        body: Column(
          children: [
            menuAtas(),
            listUser(context),
          ],
        ));
  }

  Container listUser(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: FutureBuilder<UserData?>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<UserData?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else {
            UserData? userData = snapshot.data;
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: Text(
                                          userData?.data[index].name
                                                  .toString() ??
                                              'N/A',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: Text(
                                          "Email: ${userData?.data[index].email}" ??
                                              'N/A',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            color: Colors.orange,
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {
                                              showEditModal(context, {
                                                'id': userData!.data[index].id,
                                                'name':
                                                    userData.data[index].name,
                                                'email':
                                                    userData.data[index].email,
                                              });
                                            },
                                          ),
                                          IconButton(
                                            color: Colors.red,
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              int? id =
                                                  userData?.data[index].id;
                                              deleteItem(id);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ));
                  },
                  itemCount: userData?.data.length,
                ),
              ),
            );
          }
        },
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
                  'List User',
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
