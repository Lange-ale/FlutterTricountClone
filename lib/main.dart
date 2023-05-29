import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tricount/pages/all_wallets_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const WalletsApp());
}

class WalletsApp extends StatelessWidget {
  const WalletsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WalletsPage(),
    );
  }
}