import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:balance/model/wallet.dart';
import 'package:balance/model/balance.dart';
import 'package:balance/model/person.dart';

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
        ${Wallet.columnName} VARCHAR(255) NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE ${Person.tableName} (
        ${Person.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Person.columnName} TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE ${Balance.tableName} (
        ${Balance.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Balance.columnPersonId} INTEGER NOT NULL,
        ${Balance.columnWalletId} INTEGER NOT NULL,
        ${Balance.columnAmount} REAL NOT NULL,
        FOREIGN KEY (${Balance.columnPersonId}) 
          REFERENCES ${Person.tableName} (${Person.columnId}),
        FOREIGN KEY (${Balance.columnWalletId}) 
          REFERENCES ${Wallet.tableName} (${Wallet.columnId})
      )
    ''');
  }

  Future<List<Wallet>> getWallets() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(Wallet.tableName);
    return List.generate(maps.length, (index) {
      return Wallet.fromMap(maps[index]);
    });
  }

  Future<List<Person>> getPeople() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(Person.tableName);
    return List.generate(maps.length, (index) {
      return Person.fromMap(maps[index]);
    });
  }

  Future<List<Balance>> getBalances() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(Balance.tableName);
    return List.generate(maps.length, (index) {
      return Balance.fromMap(maps[index]);
    });
  }

  Future<void> insertWallet(Wallet wallet) async {
    Database db = await instance.database;
    await db.insert(Wallet.tableName, wallet.toMap());
  }

  Future<void> insertPerson(Person person) async {
    Database db = await instance.database;
    await db.insert(Person.tableName, person.toMap());
  }

  Future<void> insertBalance(Balance balance) async {
    Database db = await instance.database;
    await db.insert(Balance.tableName, balance.toMap());
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

  Future<void> updatePerson(Person person) async {
    Database db = await instance.database;
    await db.update(
      Person.tableName,
      person.toMap(),
      where: '${Person.columnId} = ?',
      whereArgs: [person.id],
    );
  }

  Future<void> updateBalance(Balance balance) async {
    Database db = await instance.database;
    await db.update(
      Balance.tableName,
      balance.toMap(),
      where: '${Balance.columnId} = ?',
      whereArgs: [balance.id],
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

  Future<void> deletePerson(Person person) async {
    Database db = await instance.database;
    await db.delete(
      Person.tableName,
      where: '${Person.columnId} = ?',
      whereArgs: [person.id],
    );
  }

  Future<void> deleteBalance(Balance balance) async {
    Database db = await instance.database;
    await db.delete(
      Balance.tableName,
      where: '${Balance.columnId} = ?',
      whereArgs: [balance.id],
    );
  }
}
