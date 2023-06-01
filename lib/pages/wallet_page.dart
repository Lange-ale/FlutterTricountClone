import 'package:flutter/material.dart';

import 'package:tricount/pages/expenses_widget.dart';
import 'package:tricount/pages/balances_widget.dart';

import 'package:tricount/model/wallet.dart';

class WalletPage extends StatefulWidget {
  final Wallet wallet;

  const WalletPage({Key? key, required this.wallet}) : super(key: key);

  @override
  WalletPageState createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.receipt),
                text: 'EXPENSES',
              ),
              Tab(
                icon: Icon(Icons.compare_arrows),
                text: 'BALANCES',
              ),
            ],
          ),
          title: Text(widget.wallet.name),
          actions: [
            IconButton(icon: const Icon(Icons.person), onPressed: () async {}),
          ],
        ),
        body: TabBarView(
          children: [
            ExpensesWidget(wallet: widget.wallet),
            BalancesWidget(wallet: widget.wallet),
          ],
        ),
      ),
    );
  }
}
