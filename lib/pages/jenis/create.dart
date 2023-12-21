import 'package:cashierfe/apiService/dioService.dart';
import 'package:cashierfe/pages/jenis/jenis.dart';
import 'package:cashierfe/pages/menu/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MyFormJenis extends HookWidget {
  const MyFormJenis({super.key});

  @override
  Widget build(BuildContext context) {
    final jenisNameController = useTextEditingController();
    final selectedValue = useState<int?>(null);

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
                  controller: jenisNameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Jenis",
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
                child: FutureBuilder(
                    future: JenisDioService().getKategori(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data;

                        return DropdownButtonFormField<int>(
                          value: selectedValue.value,
                          items: jenisList.map((jenis) {
                            return DropdownMenuItem<int>(
                              value: jenis.id,
                              child: Text(jenis.namaJenis),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            selectedValue.value = newValue;
                          },
                          decoration: const InputDecoration(
                            labelText: "Pilih Jenis",
                            border: InputBorder.none,
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // background color
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Create'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> showCreateModal(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return const MyFormJenis();
    },
  );
}
