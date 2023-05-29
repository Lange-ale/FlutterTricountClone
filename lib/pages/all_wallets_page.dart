import 'package:flutter/material.dart';

import 'package:tricount/db/wallets_database.dart';
import 'package:tricount/pages/add_edit_wallet_page.dart';
import 'package:tricount/pages/wallet_page.dart';

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
      appBar: AppBar(title: const Text('Wallets')),
      body: //edit the list of wallets here
          ListView.builder(
        itemCount: WalletsPageState.wallets.length,
        itemBuilder: (BuildContext context, int index) {
          final wallet = WalletsPageState.wallets[index];
          return Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(wallet.name),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WalletPage(wallet: wallet))
                    );
                    refreshWallets();
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                          builder: (context) => AddEditWalletPage(wallet: wallet))
                  );
                  refreshWallets();
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditWalletPage()),
          );
          refreshWallets();
        },
      ),
    );
  }
}
