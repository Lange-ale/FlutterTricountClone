import 'package:flutter/material.dart';

import 'package:tricount/db/wallets_database.dart';
import 'package:tricount/model/wallet.dart';
import 'package:tricount/model/person.dart';
import 'package:tricount/model/transiction.dart';

import 'package:fl_chart/fl_chart.dart';

class BalancesWidget extends StatefulWidget {
  final Wallet wallet;

  const BalancesWidget({Key? key, required this.wallet}) : super(key: key);

  @override
  BalancesWidgetState createState() => BalancesWidgetState();
}

class BalancesWidgetState extends State<BalancesWidget> {
  late Map<int, Person> people = {};
  Map<int, double> balances = {};

  @override
  void initState() {
    super.initState();
    refreshBalances();
  }

  Future<void> refreshBalances() async {
    final people = await WalletsDatabase.instance.getPeople(widget.wallet);
    final debts = await WalletsDatabase.instance.getDebts(widget.wallet);
    final Map<int, double> balances = {for (var id in people.keys) id: 0};
    for (var debt in debts) {
      balances[debt.personId] = balances[debt.personId]! - debt.amount;
    }
    setState(() {
      this.people = people;
      this.balances = balances;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: balances.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Row(
            children: [
              Text(people[balances.keys.elementAt(index)]!.name),
              const Spacer(),
              Text('€ ${balances.values.elementAt(index)}'),
            ],
          ),
          titleTextStyle: const TextStyle(color: Colors.blue),
        );
      },
    );
  }
}