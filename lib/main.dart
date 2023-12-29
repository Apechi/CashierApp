import 'package:cashierfe/pages/pelanggan/pelanggan.dart';
import 'package:cashierfe/providerModels/crud.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashierfe/constant.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => CRUDType()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("BASEURL", Constant.BASE_URL);
    await prefs.setString("TOKEN",
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNjMxMTgyODA0NTNmM2ExM2E0YTFkNjQxNDRkNTdjNDZhZGZhNTFmM2IyNzFkYmIzMmZhNzI3YTcyMGVlMjlhZTRmZjhlNTIxZTQ5Y2ViMjIiLCJpYXQiOjE3MDAwOTY3NDYuODMwNzkzLCJuYmYiOjE3MDAwOTY3NDYuODMwODEsImV4cCI6MTczMTcxOTE0NC45MTQ5MDQsInN1YiI6IjEiLCJzY29wZXMiOltdfQ.EYYf4MoyS0pRikYHaUP1hipYRrOFF-nDw5ZY619IcCDLKts6TMFPWK3n85oxJkzVe1rOIS2KG5JS5WI-B3lC_Sf0fgPtjBV3eAryLEJ_zQkK_y5STu2AfGQ8wlvZzeExtPjaSDuu3bK59cpIeBvG1yg8GIt5Yxh1SplP8zXGd9HXTe339ecmeWORRvQornYuBfhMwxpASlVuF41_uhPwR2y7Tb9Nq4Sfd21CGzM9Of_YnXQlqTdp24ueRYyfZWPHrtolyE3tRZm6PLYp2IUZVvgeobYoVo6R8oPB89coRJRXB2QjyccGOTERJyReDB0wBqD5264rzUde6KTiNir9zqyoOsA_y_LjoqxdPNjXxrPZ2M-dHrJbIaYQFzL1lffdibdAkRxLJ1zxC-lvvYek0f2DuIKhv8EwcrdDiFrTlBgVLnz23ncEf-JbpTruxXXdQ85gniO8RvTW5wxixJ1ADtBZ8myp_Bm9aqJLWx2iA_wPGpKEYXJErLFUWk8-1LTg43lLP2AXFQPOcMnKD4aRU0bJcoS68GTEGgCNhV_Nx5Zf8Wqq525uVXlI0aC5s_MzKdw1fJxNeNxtKzrG1QQt0X5AieqR_EWsEWpDOrc5faa_yjFdFZb6Kmdp4APQfr1lPWoh8l8QktogkcXBbOXR9vVTCv2jWGGiWHmV-W-E9DE");
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    saveData();
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CashierApp',
        home: PelangganPage());
  }
}
