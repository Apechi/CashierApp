import 'package:cashierfe/apiService/dioService.dart';
import 'package:cashierfe/apiService/essential.dart';
import 'package:cashierfe/constant.dart';
import 'package:cashierfe/models/Jenis.dart';
import 'package:cashierfe/pages/custom_appbar.dart';
import 'package:cashierfe/pages/custom_drawer.dart';
import 'package:cashierfe/providerModels/crud.dart';
import 'package:diox/diox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JenisPage extends StatelessWidget {
  const JenisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final crudJenis = Provider.of<CRUDType>(context);
    final JenisDioService jenisDioService = JenisDioService();

    return Scaffold(
        appBar: const appBaru(title: "Jenis"),
        endDrawer: const drawerBar(),
        body: Column(children: [
          menuAtas(),
          Flexible(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
                future: crudJenis.fetchJenis(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.data[index].namaJenis,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "Kategori:${snapshot.data!.data[index].kategori.name}",
                                          style: const TextStyle(
                                            fontSize: 13,
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
                                          onPressed: () {}),
                                      IconButton(
                                        color: Colors.red,
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data!.data.length,
                    );
                  }
                }),
          ))
        ]));
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
                  onPressed: () {},
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
