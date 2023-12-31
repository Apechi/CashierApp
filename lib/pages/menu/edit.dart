import 'dart:convert';

import 'package:cashierfe/pages/menu/api_service.dart';
import 'package:cashierfe/apiService/apiService.dart';
import 'package:cashierfe/constant.dart';
import 'package:cashierfe/pages/menu/global_var.dart';
import 'package:cashierfe/pages/menu/menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:cashierfe/pages/menu/menu.dart';
import 'package:cashierfe/pages/menu/get_pref.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<void> showEditModal(BuildContext context, Map<String, dynamic> data,
    Function updateState) async {
  menuNameController.text = data['nama'];
  menuHargaController.text = data['harga'].toString();
  menuDeskripsiController.text = data['deskripsi'].toString();
  selectedJenis = data['jenis'];
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
                    controller: menuNameController,
                    decoration: const InputDecoration(
                      labelText: "Nama Menu",
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
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: menuHargaController,
                    decoration: const InputDecoration(
                      labelText: "Harga",
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
                    controller: menuDeskripsiController,
                    decoration: const InputDecoration(
                      labelText: "Deskripsi",
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
                  child: DropdownButtonFormField<int>(
                    value: selectedJenis,
                    items: jenisList.map((jenis) {
                      return DropdownMenuItem<int>(
                        value: jenis.id,
                        child: Text(jenis.namaJenis),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      updateState(() {
                        selectedJenis = newValue;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Pilih Jenis",
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
                    String url = Constant.BASE_URL;
                    int dataPost = data['id'];
                    ApiService.fetchData(
                        "$url/menu/$dataPost",
                        {
                          'nama_menu': menuNameController.text,
                          'harga': int.parse(menuHargaController.text),
                          'deskripsi': menuDeskripsiController.text,
                          'jenis_id': selectedJenis
                        },
                        'PUT');
                    Navigator.of(context).pop();
                    updateState(() {});
                  },
                  child: const Text('Save'),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
