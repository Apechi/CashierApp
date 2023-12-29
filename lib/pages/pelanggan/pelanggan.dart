import 'package:cashierfe/models/Pelanggan.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:cashierfe/pages/custom_drawer.dart';
import 'package:cashierfe/pages/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashierfe/constant.dart';

class PelangganPage extends StatefulWidget {
  const PelangganPage({super.key});

  @override
  State<PelangganPage> createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  late Future<PelangganData?> _dataFuture;

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

    String url = "${Constant.BASE_URL}/customer";
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

  Future<PelangganData?> getData() async {
    String url = "${Constant.BASE_URL}/customer";
    String token = await getTOKEN();

    try {
      http.Response res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        return pelangganDataFromJson(res.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> createItem(Map<String, dynamic> item) async {
    String url = "${Constant.BASE_URL}/customer";
    String token = await getTOKEN();

    String nama = item['nama'].toString();
    String email = item['email'].toString();
    String noTelp = item['nomor_telepon'].toString();
    String alamat = item['alamat'].toString();

    try {
      http.Response res = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "nama": nama,
          "email": email,
          "nomor_telepon": noTelp,
          "alamat": alamat
        }),
      );
      if (res.statusCode == 200) {
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> editItem(Map<String, dynamic> data) async {
    var id = data['id'];
    String nama = data['nama'].toString();
    String email = data['email'].toString();
    String noTelp = data['nomor_telepon'].toString();
    String alamat = data['alamat'].toString();
    String url = "${Constant.BASE_URL}/customer";
    String token = await getTOKEN();

    try {
      http.Response res = await http.put(
        Uri.parse("$url/$id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "nama": nama,
          "email": email,
          "nomor_telepon": noTelp,
          "alamat": alamat
        }),
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
  final TextEditingController noTelpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  Future<void> showCreateModal(BuildContext context) async {
    namaController.clear();
    emailController.clear();
    noTelpController.clear();
    alamatController.clear();
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
                    labelText: "Nama Pelanggan",
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
                  controller: alamatController,
                  decoration: const InputDecoration(
                    labelText: "Alamat",
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
                  controller: noTelpController,
                  decoration: const InputDecoration(
                    labelText: "Nomor Telepon",
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
            Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // background color
                ),
                onPressed: () {
                  createItem({
                    'nama': namaController.text,
                    'alamat': alamatController.text,
                    'nomor_telepon': noTelpController.text,
                    'email': emailController.text
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
    noTelpController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  Future<void> showEditModal(
      BuildContext context, Map<String, dynamic> data) async {
    var id = data['id'];
    namaController.text = data['nama'].toString();
    emailController.text = data['email'].toString();
    noTelpController.text = data['nomor_telepon'].toString();
    alamatController.text = data['alamat'].toString();
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
                    labelText: "Nama Pelanggan",
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
                  controller: alamatController,
                  decoration: const InputDecoration(
                    labelText: "Alamat",
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
                  controller: noTelpController,
                  decoration: const InputDecoration(
                    labelText: "Nomor Telepon",
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
            Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // background color
                ),
                onPressed: () {
                  editItem({
                    'id': id,
                    'nama': namaController.text,
                    'alamat': alamatController.text,
                    'nomor_telepon': noTelpController.text,
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
        appBar: const appBaru(title: "Manage Pelanggan"),
        endDrawer: const drawerBar(),
        body: Column(
          children: [
            menuAtas(),
            listPelanggan(context),
          ],
        ));
  }

  Container listPelanggan(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: FutureBuilder<PelangganData?>(
        future: getData(),
        builder:
            (BuildContext context, AsyncSnapshot<PelangganData?> snapshot) {
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
            PelangganData? pelangganData = snapshot.data;
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Text(
                                      pelangganData?.data[index].nama
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
                                      "Alamat: ${pelangganData?.data[index].alamat}" ??
                                          'N/A',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Text(
                                      pelangganData?.data[index].email ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Text(
                                      pelangganData?.data[index].nomorTelepon ??
                                          'N/A',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    color: Colors.orange,
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showEditModal(context, {
                                        'id': pelangganData!.data[index].id,
                                        'nama': pelangganData.data[index].nama,
                                        'email':
                                            pelangganData.data[index].email,
                                        'alamat':
                                            pelangganData.data[index].alamat,
                                        'nomor_telepon': pelangganData
                                            .data[index].nomorTelepon
                                      });
                                    },
                                  ),
                                  IconButton(
                                    color: Colors.red,
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      int? id = pelangganData?.data[index].id;
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
                  itemCount: pelangganData?.data.length,
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
                  'Pelanggan',
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
