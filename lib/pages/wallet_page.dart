import 'package:flutter/material.dart';

import 'package:tricount/db/wallets_database.dart';
import 'package:tricount/model/wallet.dart';

class WalletPage extends StatefulWidget {
  final Wallet wallet;

  const WalletPage({Key? key, required this.wallet}) : super(key: key);

  @override
  WalletPageState createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.wallet.name),
      ),
    );
  }
}
