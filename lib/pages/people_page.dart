import 'package:flutter/material.dart';

import 'package:tricount/db/wallets_database.dart';
import 'package:tricount/pages/add_edit_wallet_page.dart';
import 'package:tricount/pages/wallet_page.dart';
import 'package:tricount/model/person.dart';

import 'package:tricount/model/wallet.dart';
import 'package:tricount/pages/add_edit_person_page.dart';
import 'package:tricount/pages/add_edit_wallet_page.dart';

class PeoplePage extends StatefulWidget {
  final Wallet wallet;

  const PeoplePage({Key? key, required this.wallet}) : super(key: key);

  @override
  PeoplePageState createState() => PeoplePageState();
}

class PeoplePageState extends State<PeoplePage> {
  Map<int, Person> people = {};

  @override
  void initState() {
    super.initState();
    refreshPeople();
  }

  Future<void> refreshPeople() async {
    final people = await WalletsDatabase.instance.getPeople(widget.wallet);
    setState(() {
      this.people = people;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('People')),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (BuildContext context, int index) {
          final person = people.values.elementAt(index);
          return ListTile(
            title: Text(person.name),
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddEditPersonPage(
                        person: person,
                        wallet: widget.wallet,
                      )));
              refreshPeople();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddEditPersonPage(
                      person: null,
                      wallet: widget.wallet,
                    )),
          );
          refreshPeople();
        },
      ),
    );
  }
}
