import 'package:cashierfe/models/Menu.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cashierfe/models/Stok.dart';
import 'package:cashierfe/pages/custom_drawer.dart';
import 'package:cashierfe/pages/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashierfe/constant.dart';

class StokPage extends StatefulWidget {
  const StokPage({super.key});

  @override
  State<StokPage> createState() => _StokPageState();
}

class _StokPageState extends State<StokPage> {
  final bool _isLoading = true;
  late Future<StokData?> _dataFuture;

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

    String url = "${Constant.BASE_URL}/stok";
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

  Future<StokData?> getData() async {
    String url = "${Constant.BASE_URL}/stok";
    String token = await getTOKEN();

    try {
      http.Response res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        return stokDataFromJson(res.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<MenuData> getAllMenu() async {
    String url = "${Constant.BASE_URL}/menu";
    String token = await getTOKEN();

    try {
      http.Response res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode == 200) {
        return menuDataFromJson(res.body);
      } else {
        throw Exception('Unexpected status code ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Error while getting data');
    }
  }

  Future<void> createItem(Map<String, dynamic> item) async {
    String url = "${Constant.BASE_URL}/stok";
    String token = await getTOKEN();

    String menuId = item['menu_id'].toString();
    String jumlah = item['jumlah'].toString();

    try {
      http.Response res = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"menu_id": menuId, "jumlah": jumlah}),
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
    var menuId = data['menu_id'].toString();
    var jumlah = data['jumlah'].toString();
    String url = "${Constant.BASE_URL}/stok";
    String token = await getTOKEN();

    try {
      http.Response res = await http.put(
        Uri.parse("$url/$id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"menu_id": menuId, "jumlah": jumlah}),
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
    MenuData menuData = await getAllMenu();
    List<DropdownMenuItem<String>> menuItems = [];
    for (var item in menuData.data) {
      menuItems.add(DropdownMenuItem(
        value: item.id.toString(),
        child: Text(item.namaMenu),
      ));
    }
    return menuItems;
  }

  var selectedId;
  final TextEditingController jumlahController = TextEditingController();

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
                  controller: jumlahController,
                  decoration: const InputDecoration(
                    labelText: "Jumlah Stok",
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
                  createItem(
                      {'menu_id': selectedId, 'jumlah': jumlahController.text});
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
    jumlahController.dispose();
    super.dispose();
  }

  Future<void> showEditModal(
      BuildContext context, Map<String, dynamic> data) async {
    var selectedIdEdit = data['menu_id'].toString();
    var itemId = data['id'];
    jumlahController.text = data['jumlah'].toString();
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
                  controller: jumlahController,
                  decoration: const InputDecoration(
                    labelText: "Jumlah Stok",
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
                    'menu_id': selectedIdEdit,
                    'jumlah': jumlahController.text
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
        appBar: const appBaru(title: "Manage Stok"),
        endDrawer: const drawerBar(),
        body: Column(
          children: [
            menuAtas(),
            listStok(context),
          ],
        ));
  }

  Container listStok(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: FutureBuilder<StokData?>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<StokData?> snapshot) {
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
            StokData? stokData = snapshot.data;
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
                                      stokData?.data[index].menu.namaMenu
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
                                      "Stok Tersisa: ${stokData?.data[index].jumlah.toString()}" ??
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
                                        'id': stokData!.data[index].id,
                                        'menu_id': stokData.data[index].menuId,
                                        'jumlah': stokData.data[index].jumlah
                                      });
                                    },
                                  ),
                                  IconButton(
                                    color: Colors.red,
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      int? id = stokData?.data[index].id;
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
                  itemCount: stokData?.data.length,
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
                  'Stok',
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
