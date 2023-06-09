import 'package:flutter/material.dart';

import 'package:tricount/db/wallets_database.dart';
import 'package:tricount/model/wallet.dart';

class AddEditWalletPage extends StatefulWidget {
  final Wallet? wallet;

  const AddEditWalletPage({
    Key? key,
    this.wallet,
  }) : super(key: key);

  @override
  AddEditWalletPageState createState() => AddEditWalletPageState();
}

class AddEditWalletPageState extends State<AddEditWalletPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;

  @override
  void initState() {
    super.initState();
    _name = widget.wallet?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wallet == null ? 'New wallet' : 'Edit wallet'),
        actions: [
          if (widget.wallet != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                WalletsDatabase.instance.deleteWallet(widget.wallet!);
                Navigator.of(context).pop();
              },
            )
        ],
      ),
      body: Form(
        // button with save icon
        key: _formKey,
        child: TextFormField(
          initialValue: _name,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'Enter wallet name',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter wallet name';
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
            if (widget.wallet == null) {
              WalletsDatabase.instance.insertWallet(Wallet(
                name: _name,
              ));
            } else {
              WalletsDatabase.instance.updateWallet(
                widget.wallet!.copyWith(name: _name),
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
