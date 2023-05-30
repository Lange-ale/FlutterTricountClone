import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:tricount/model/wallet.dart';
import 'package:tricount/model/person.dart';
import 'package:tricount/model/transiction.dart';
import 'package:tricount/model/debt.dart';

class WalletsDatabase {
  static const String databaseName = 'walletsDatabase.db';

  static final WalletsDatabase instance = WalletsDatabase._privateConstructor();
  static Database? _database;

  WalletsDatabase._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Wallet.tableName} (
        ${Wallet.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Wallet.columnName} TEXT NOT NULL
      )
     ''');
    await db.execute('''
      CREATE TABLE ${Person.tableName} (
        ${Person.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Person.columnName} TEXT NOT NULL,
        ${Person.columnWalletId} INTEGER NOT NULL,
        FOREIGN KEY (${Person.columnWalletId}) 
          REFERENCES ${Wallet.tableName} (${Wallet.columnId}) 
          ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE ${Transiction.tableName} (
        ${Transiction.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Transiction.columnPersonId} INTEGER NOT NULL,
        ${Transiction.columnTotalAmount} REAL NOT NULL,
        ${Transiction.columnDate} TEXT NOT NULL,
        FOREIGN KEY (${Transiction.columnPersonId}) 
          REFERENCES ${Person.tableName} (${Person.columnId}) 
          ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE ${Debt.tableName} (
        ${Debt.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Debt.columnPersonId} INTEGER NOT NULL,
        ${Debt.columnTransictionId} INTEGER NOT NULL,
        ${Debt.columnAmount} REAL NOT NULL,
        FOREIGN KEY (${Debt.columnPersonId}) 
          REFERENCES ${Person.tableName} (${Person.columnId}) 
          ON DELETE CASCADE,
        FOREIGN KEY (${Debt.columnTransictionId}) 
          REFERENCES ${Transiction.tableName} (${Transiction.columnId}) 
          ON DELETE CASCADE
      )
    ''');

    //TODO: REMOVE THIS
    await db.insert(Wallet.tableName, Wallet(id: 1, name: 'Wallet 1').toMap());
    await db.insert(
        Person.tableName, Person(id: 1, name: 'Person 1', walletId: 1).toMap());
    await db.insert(
        Person.tableName, Person(id: 2, name: 'Person 2', walletId: 1).toMap());
    await db.insert(
        Person.tableName, Person(id: 3, name: 'Person 3', walletId: 1).toMap());
    await db.insert(Transiction.tableName,
        Transiction(id: 1, personId: 1, totalAmount: 150, date: DateTime.now(), description: 'Transiction 1').toMap());
    await db.insert(Debt.tableName,
        Debt(id: 1, personId: 1, transictionId: 1, amount: -100).toMap());
    await db.insert(Debt.tableName,
        Debt(id: 2, personId: 2, transictionId: 1, amount: 50).toMap());
    await db.insert(Debt.tableName,
        Debt(id: 3, personId: 3, transictionId: 1, amount: 50).toMap());
    await db.insert(
        Transiction.tableName,
        Transiction(
                id: 2,
                personId: 1,
                totalAmount: 150,
                date: DateTime.now(),
                description: 'Transiction 2')
            .toMap());
    await db.insert(Debt.tableName,
        Debt(id: 3, personId: 1, transictionId: 2, amount: -100).toMap());
    await db.insert(Debt.tableName,
        Debt(id: 4, personId: 2, transictionId: 2, amount: 50).toMap());
    await db.insert(Debt.tableName,
        Debt(id: 5, personId: 3, transictionId: 2, amount: 50).toMap());
    //if in the receiver there is the payer, amount = totalAmount / number of people and in the for if the receiver is the payer continue,
    //the debt of the payer is - (totalAmount / number of people - amount)
    //if in the receiver there is not the payer, amount = totalAmount / number of people
    //the debt of the payer is - (totalAmount / number of people)
  }

  Future<List<Wallet>> getWallets() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(Wallet.tableName);
    return List.generate(maps.length, (index) {
      return Wallet.fromMap(maps[index]);
    });
  }

  Future<void> insertWallet(Wallet wallet) async {
    Database db = await instance.database;
    await db.insert(Wallet.tableName, wallet.toMap());
  }

  Future<void> updateWallet(Wallet wallet) async {
    Database db = await instance.database;
    await db.update(
      Wallet.tableName,
      wallet.toMap(),
      where: '${Wallet.columnId} = ?',
      whereArgs: [wallet.id],
    );
  }

  Future<void> deleteWallet(Wallet wallet) async {
    Database db = await instance.database;
    await db.delete(
      Wallet.tableName,
      where: '${Wallet.columnId} = ?',
      whereArgs: [wallet.id],
    );
  }
}
