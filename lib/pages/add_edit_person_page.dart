import 'package:flutter/material.dart';

import 'package:tricount/db/wallets_database.dart';
import 'package:tricount/model/person.dart';
import 'package:tricount/model/wallet.dart';

class AddEditPersonPage extends StatefulWidget {
  final Person? person;
  final Wallet wallet;

  const AddEditPersonPage({
    Key? key,
    required this.person,
    required this.wallet,
  }) : super(key: key);

  @override
  AddEditPersonPageState createState() => AddEditPersonPageState();
}

class AddEditPersonPageState extends State<AddEditPersonPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;

  @override
  void initState() {
    super.initState();
    _name = widget.person?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person == null ? 'New person' : 'Edit person'),
        actions: [
          if (widget.person != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                WalletsDatabase.instance.deletePerson(widget.person!);
                Navigator.of(context).pop();
              },
            )
        ],
      ),
      body: Form(
        key: _formKey,
        child: TextFormField(
          initialValue: _name,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'Enter person name',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter person name';
            }
            return null;
          },
          onChanged: (value) => _name = value,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final form = _formKey.currentState!;
          if (form.validate()) {
            if (widget.person == null) {
              WalletsDatabase.instance.insertPerson(
                Person(
                  name: _name,
                  walletId: widget.wallet.id!,
                ),
              );
            } else {
              WalletsDatabase.instance.updatePerson(
                widget.person!.copyWith(name: _name),
              );
            }
            Navigator.of(context).pop();
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
