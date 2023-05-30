import 'package:flutter/material.dart';

import 'package:tricount/model/wallet.dart';


class WalletPage extends StatefulWidget {
  final Wallet wallet;

  const WalletPage({Key? key, required this.wallet}) : super(key: key);

  @override
  WalletPageState createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wallet.name),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _ExpensesWidget(wallet: widget.wallet),
          _BalancesPage(wallet: widget.wallet),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Balances',
          ),
        ],
        selectedItemColor: Colors.amber[800],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _ExpensesWidget extends StatefulWidget {
  final Wallet wallet;

  const _ExpensesWidget({Key? key, required this.wallet}) : super(key: key);

  @override
  _ExpensesWidgetState createState() => _ExpensesWidgetState();
}

class _ExpensesWidgetState extends State<_ExpensesWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Expenses'),
    );
  }
}

class _BalancesPage extends StatefulWidget {
  final Wallet wallet;

  const _BalancesPage({Key? key, required this.wallet}) : super(key: key);

  @override
  _BalancesPageState createState() => _BalancesPageState();
}

class _BalancesPageState extends State<_BalancesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Balances'),
    );
  }
}
