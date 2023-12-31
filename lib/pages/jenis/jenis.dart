import 'package:cashierfe/models/Category.dart';
import 'package:cashierfe/models/Menu.dart';
import 'package:cashierfe/models/Jenis.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cashierfe/models/Stok.dart';
import 'package:cashierfe/pages/custom_drawer.dart';
import 'package:cashierfe/pages/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashierfe/constant.dart';

class JenisPage extends StatefulWidget {
  const JenisPage({super.key});

  @override
  State<JenisPage> createState() => _JenisPageState();
}

class _JenisPageState extends State<JenisPage> {
  final bool _isLoading = true;
  late Future<JenisData?> _dataFuture;

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

    String url = "${Constant.BASE_URL}/type";
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

  Future<JenisData?> getData() async {
    String url = "${Constant.BASE_URL}/type";
    String token = await getTOKEN();

    try {
      http.Response res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        return jenisDataFromJson(res.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<CategoryData> getAllKategori() async {
    String url = "${Constant.BASE_URL}/category";
    String token = await getTOKEN();

    try {
      http.Response res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode == 200) {
        return categoryDataFromJson(res.body);
      } else {
        throw Exception('Unexpected status code ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Error while getting data');
    }
  }

  Future<void> createItem(Map<String, dynamic> item) async {
    String url = "${Constant.BASE_URL}/type";
    String token = await getTOKEN();

    String kategoriId = item['kategori_id'].toString();
    String namaJenis = item['nama_jenis'].toString();

    try {
      http.Response res = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"kategori_id": kategoriId, "nama_jenis": namaJenis}),
      );
      if (res.statusCode == 200) {
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> editItem(Map<String, dynamic> data) async {
    var id = data['id'].toString();
    var kategoriId = data['kategori_id'].toString();
    var namaJenis = data['nama_jenis'].toString();
    String url = "${Constant.BASE_URL}/type";
    String token = await getTOKEN();

    try {
      http.Response res = await http.put(
        Uri.parse("$url/$id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"kategori_id": kategoriId, "nama_jenis": namaJenis}),
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

  Future<List<DropdownMenuItem<String>>> getDropdownMenuItems() async {
    CategoryData kategoriData = await getAllKategori();
    List<DropdownMenuItem<String>> categoryItems = [];
    for (var item in kategoriData.data) {
      categoryItems.add(DropdownMenuItem(
        value: item.id.toString(),
        child: Text(item.name),
      ));
    }
    return categoryItems;
  }

  var selectedId;
  final TextEditingController namaJenisController = TextEditingController();

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
                  controller: namaJenisController,
                  decoration: const InputDecoration(
                    labelText: "Nama Jenis ",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FutureBuilder<List<DropdownMenuItem<String>>>(
                  future: getDropdownMenuItems(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButtonFormField<String>(
                        value: selectedId,
                        items: snapshot.data!,
                        onChanged: (newValue) {
                          selectedId = newValue!;
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                )),
            Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // background color
                ),
                onPressed: () {
                  createItem({
                    'kategori_id': selectedId,
                    'nama_jenis': namaJenisController.text
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
    namaJenisController.dispose();
    super.dispose();
  }

  Future<void> showEditModal(
      BuildContext context, Map<String, dynamic> data) async {
    var selectedIdEdit = data['kategori_id'].toString();
    var itemId = data['id'];
    namaJenisController.text = data['nama_jenis'].toString();
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
                  controller: namaJenisController,
                  decoration: const InputDecoration(
                    labelText: "Ganti Jenis",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FutureBuilder<List<DropdownMenuItem<String>>>(
                  future: getDropdownMenuItems(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButtonFormField<String>(
                        value: selectedIdEdit,
                        items: snapshot.data!,
                        onChanged: (newValue) {
                          selectedIdEdit = newValue!;
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                )),
            Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // background color
                ),
                onPressed: () {
                  editItem({
                    'id': itemId,
                    'kategori_id': selectedIdEdit,
                    'nama_jenis': namaJenisController.text
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
        appBar: const appBaru(title: "Manage Jenis"),
        endDrawer: const drawerBar(),
        body: Column(
          children: [
            menuAtas(),
            listJenis(context),
          ],
        ));
  }

  Container listJenis(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: FutureBuilder<JenisData?>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<JenisData?> snapshot) {
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
            JenisData? jenisData = snapshot.data;
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Text(
                                      jenisData?.data[index].namaJenis
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
                                      "Kategori: ${jenisData?.data[index].kategori.name.toString()}" ??
                                          'N/A',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    color: Colors.orange,
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showEditModal(context, {
                                        'id': jenisData!.data[index].id,
                                        'nama_jenis':
                                            jenisData.data[index].namaJenis,
                                        'kategori_id':
                                            jenisData.data[index].kategoriId
                                      });
                                    },
                                  ),
                                  IconButton(
                                    color: Colors.red,
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      int? id = jenisData?.data[index].id;
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
                  itemCount: jenisData?.data.length,
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
                  'Jenis',
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
