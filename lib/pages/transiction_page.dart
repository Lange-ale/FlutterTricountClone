import 'package:flutter/material.dart';

import 'package:tricount/pages/add_edit_transiction_page.dart';

import 'package:tricount/db/wallets_database.dart';
import 'package:tricount/model/wallet.dart';
import 'package:tricount/model/transiction.dart';
import 'package:tricount/model/person.dart';

class TransictionPage extends StatefulWidget {
  final Wallet wallet;
  Transiction? transiction;
  final Map<int, Person> people;

  TransictionPage(
      {Key? key,
      required this.wallet,
      required this.transiction,
      required this.people})
      : super(key: key);

  @override
  TransictionPageState createState() => TransictionPageState();
}

class TransictionPageState extends State<TransictionPage> {
  @override
  void initState() {
    super.initState();
    refreshTransiction();
  }

  Future<void> refreshTransiction() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: ListTile(
            textColor: Colors.white,
            title: Center(
                child: Column(
              children: [
                Text(widget.transiction!.description),
                Text('€ ${widget.transiction!.totalAmount}')
              ],
            )),
            subtitle: Text('Paid by ${widget.transiction!.personId}'),
          ),
          toolbarHeight: 210,
          leading: Column(
            children: [
              IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
          actions: [
            Column(
              children: [
                IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddEditTransictionPage(
                                  transiction: widget.transiction,
                                  people: widget.people)));
                    })
              ],
            )
          ],
        ),
        body: Center(
          child: Text(widget.transiction!.description),
        ));
  }
}
