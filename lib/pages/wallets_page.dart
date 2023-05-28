import 'package:flutter/material.dart';

import 'package:balance/db/wallets_database.dart';
import 'package:balance/model/wallet.dart';
import 'package:balance/pages/add_edit_wallet_page.dart';

class WalletsPage extends StatefulWidget {
  const WalletsPage({Key? key}) : super(key: key);

  @override
  WalletsPageState createState() => WalletsPageState();
}

class WalletsPageState extends State<WalletsPage> {
  static final wallets = [];

  @override
  void initState() {
    super.initState();
    refreshWallets();
  }

  Future<void> refreshWallets() async {
    final wallets = await WalletsDatabase.instance.getWallets();
    setState(() {
      WalletsPageState.wallets.clear();
      WalletsPageState.wallets.addAll(wallets);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallets'),
      ),
      body: //edit the list of wallets here
          ListView.builder(
        itemCount: WalletsPageState.wallets.length,
        itemBuilder: (BuildContext context, int index) {
          final wallet = WalletsPageState.wallets[index];
          return Dismissible(
            key: Key('${wallet.id}'),
            onDismissed: (direction) {
              WalletsDatabase.instance.deleteWallet(wallet.id!);
              setState(() {
                WalletsPageState.wallets.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wallet deleted')),
              );
            },
            child: ListTile(
              title: Text(
                wallet.name,
                style: const TextStyle(fontSize: 20),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            AddEditWalletPage(wallet: wallet)),
                  );
                  refreshWallets();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditWalletPage()),
          );
          refreshWallets();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
