import 'package:flutter/material.dart';

import 'package:tricount/db/wallets_database.dart';
import 'package:tricount/model/transiction.dart';
import 'package:tricount/model/person.dart';

class AddEditTransictionPage extends StatefulWidget {
  Transiction? transiction;
  Map<int, Person> people = {};

  AddEditTransictionPage({
    Key? key,
    required this.transiction,
    required this.people,
  }) : super(key: key);

  @override
  AddEditTransictionPageState createState() => AddEditTransictionPageState();
}

class AddEditTransictionPageState extends State<AddEditTransictionPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // button with save icon
    return Scaffold(
      appBar: AppBar(
        title:
        Text(widget.transiction == null ? 'New expense' : 'Edit expense'),
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
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              )
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              initialValue: widget.transiction?.description ?? '',
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: widget.transiction?.totalAmount.toString() ?? '0',
              decoration: const InputDecoration(
                labelText: 'Total amount (€)',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a total amount';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue:
              widget.transiction?.date.toString().substring(0, 10) ??
                  DateTime.now().toString().substring(0, 10),
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                labelText: 'Date',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a date';
                }
                return null;
              },
            ),
          ]),
        ),
      ),
    );
  }
}
