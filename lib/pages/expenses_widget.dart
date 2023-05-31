import 'package:flutter/material.dart';

import 'package:tricount/db/wallets_database.dart';
import 'package:tricount/model/wallet.dart';
import 'package:tricount/model/person.dart';
import 'package:tricount/model/transiction.dart';

import 'package:tricount/pages/transiction_page.dart';

class ExpensesWidget extends StatefulWidget {
  final Wallet wallet;

  const ExpensesWidget({Key? key, required this.wallet}) : super(key: key);

  @override
  ExpensesWidgetState createState() => ExpensesWidgetState();
}

class ExpensesWidgetState extends State<ExpensesWidget> {
  Map<int, Person> people = {};
  List<Transiction> transictions = [];

  @override
  void initState() {
    super.initState();
    refreshTransictions();
  }

  Future<void> refreshTransictions() async {
    final people = await WalletsDatabase.instance.getPeople(widget.wallet);
    final transictions =
        await WalletsDatabase.instance.getTransictions(widget.wallet);
    setState(() {
      this.people = people;
      this.transictions = transictions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: transictions.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Row(
              children: [
                Text(transictions[index].description),
                const Spacer(),
                Text('€ ${transictions[index].totalAmount}'),
              ],
            ),
            titleTextStyle: const TextStyle(color: Colors.blue),
            subtitle: Row(
              children: [
                Row(
                  children: [
                    const Text('paid by '),
                    Text(
                      people[transictions[index].personId]!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                Text(transictions[index].date.toString().substring(0, 10)),
              ],
            ),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TransictionPage(
                    transiction: transictions[index],
                  ),
                ),
              );
              refreshTransictions();
            },
          );
        },        
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // TODO
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
