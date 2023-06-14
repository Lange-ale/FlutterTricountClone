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
      CREATE TABLE ${Wallet.table} (
        ${Wallet.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Wallet.columnName} TEXT NOT NULL
      )
     ''');
    await db.execute('''
      CREATE TABLE ${Person.table} (
        ${Person.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Person.columnName} TEXT NOT NULL,
        ${Person.columnWalletId} INTEGER NOT NULL,
        FOREIGN KEY (${Person.columnWalletId}) 
          REFERENCES ${Wallet.table} (${Wallet.columnId}) 
          ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE ${Transiction.table} (
        ${Transiction.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Transiction.columnPersonId} INTEGER NOT NULL,
        ${Transiction.columnTotalAmount} REAL NOT NULL,
        ${Transiction.columnDescription} VARCHAR(255) NOT NULL,
        ${Transiction.columnDate} DATETIME NOT NULL,
        FOREIGN KEY (${Transiction.columnPersonId}) 
          REFERENCES ${Person.table} (${Person.columnId}) 
          ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE ${Debt.table} (
        ${Debt.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Debt.columnPersonId} INTEGER NOT NULL,
        ${Debt.columnTransictionId} INTEGER NOT NULL,
        ${Debt.columnAmount} REAL NOT NULL,
        FOREIGN KEY (${Debt.columnPersonId}) 
          REFERENCES ${Person.table} (${Person.columnId}) 
          ON DELETE CASCADE,
        FOREIGN KEY (${Debt.columnTransictionId}) 
          REFERENCES ${Transiction.table} (${Transiction.columnId}) 
          ON DELETE CASCADE
      )
    ''');

    //TODO: REMOVE THIS
    for (int i = 1; i <= 10; i++) {
      await db.insert(Wallet.table, Wallet(id: i, name: 'Wallet $i').toMap());
    }
    for (int i = 1; i <= 10; i++) {
      await db.insert(
          Person.table, Person(id: i, name: 'Person $i', walletId: 1).toMap());
    }
    await db.insert(
        Transiction.table,
        Transiction(
                id: 1,
                personId: 1,
                totalAmount: 150,
                date: DateTime.now(),
                description: 'Transiction 1')
            .toMap());
    await db.insert(Debt.table,
        Debt(id: 1, personId: 1, transictionId: 1, amount: -100).toMap());
    await db.insert(Debt.table,
        Debt(id: 2, personId: 2, transictionId: 1, amount: 50).toMap());
    await db.insert(Debt.table,
        Debt(id: 3, personId: 3, transictionId: 1, amount: 50).toMap());
    await db.insert(
        Transiction.table,
        Transiction(
                id: 2,
                personId: 1,
                totalAmount: 100,
                date: DateTime.now(),
                description: 'Transiction 2')
            .toMap());
    await db.insert(Debt.table,
        Debt(id: 6, personId: 1, transictionId: 2, amount: -100).toMap());
    await db.insert(Debt.table,
        Debt(id: 4, personId: 2, transictionId: 2, amount: 50).toMap());
    await db.insert(Debt.table,
        Debt(id: 5, personId: 3, transictionId: 2, amount: 50).toMap());
    //if in the receiver there is the payer, amount = totalAmount / number of people and in the for if the receiver is the payer continue,
    //the debt of the payer is - (totalAmount / number of people - amount)
    //if in the receiver there is not the payer, amount = totalAmount / number of people
    //the debt of the payer is - (totalAmount / number of people)
  }

  Future<List<Wallet>> getWallets() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(Wallet.table);
    return List.generate(maps.length, (index) => Wallet.fromMap(maps[index]));
  }

  Future<void> insertWallet(Wallet wallet) async {
    Database db = await instance.database;
    await db.insert(Wallet.table, wallet.toMap());
  }

  Future<void> updateWallet(Wallet wallet) async {
    Database db = await instance.database;
    await db.update(
      Wallet.table,
      wallet.toMap(),
      where: '${Wallet.columnId} = ?',
      whereArgs: [wallet.id],
    );
  }

  Future<void> deleteWallet(Wallet wallet) async {
    Database db = await instance.database;
    await db.delete(
      Wallet.table,
      where: '${Wallet.columnId} = ?',
      whereArgs: [wallet.id],
    );
  }

  Future<Map<int, Person>> getPeople(Wallet wallet) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> people = await db.query(Person.table,
        where: '${Person.columnWalletId} = ?', whereArgs: [wallet.id]);
    return {for (var p in people) p[Person.columnId]: Person.fromMap(p)};
  }

  Future<void> insertPerson(Person person) async {
    Database db = await instance.database;
    await db.insert(Person.table, person.toMap());
  }

  Future<void> updatePerson(Person person) async {
    Database db = await instance.database;
    await db.update(
      Person.table,
      person.toMap(),
      where: '${Person.columnId} = ?',
      whereArgs: [person.id],
    );
  }

  Future<void> deletePerson(Person person) async {
    Database db = await instance.database;
    await db.delete(
      Person.table,
      where: '${Person.columnId} = ?',
      whereArgs: [person.id],
    );
  }

  Future<List<Transiction>> getTransictions(Wallet wallet) async {
    Database db = await instance.database;
    const sql = '''
        SELECT ${Transiction.table}.* 
        FROM ${Transiction.table} , ${Person.table} 
        WHERE ${Person.table}.${Person.columnId} = ${Transiction.table}.${Transiction.columnPersonId}
        AND ${Person.table}.${Person.columnWalletId} = ?
        ORDER BY ${Transiction.table}.${Transiction.columnDate} DESC''';
    final transictions = await db.rawQuery(sql, [wallet.id]);
    return List.generate(transictions.length,
        (index) => Transiction.fromMap(transictions[index]));
  }

  Future<Transiction> getTransiction(int transictionId) async {
    Database db = await instance.database;
    final transictions = await db.query(Transiction.table,
        where: '${Transiction.columnId} = ?', whereArgs: [transictionId]);
    return Transiction.fromMap(transictions.first);
  }

  Future<void> insertTransiction(Transiction transiction) async {
    Database db = await instance.database;
    await db.insert(
      Transiction.table,
      transiction.toMap(),
    );
  }

  Future<void> updateTransiction(Transiction transiction) async {
    Database db = await instance.database;
    await db.update(
      Transiction.table,
      transiction.toMap(),
      where: '${Transiction.columnId} = ?',
      whereArgs: [transiction.id],
    );
  }

  Future<List<Debt>> getDebts(Wallet wallet) async {
    Database db = await instance.database;
    const sql = '''
        SELECT ${Debt.table}.* 
        FROM ${Debt.table} , ${Person.table} 
        WHERE ${Person.table}.${Person.columnId} = ${Debt.table}.${Debt.columnPersonId}
        AND ${Person.table}.${Person.columnWalletId} = ? ''';
    final debts = await db.rawQuery(sql, [wallet.id]);
    return List.generate(debts.length, (index) => Debt.fromMap(debts[index]));
  }

  Future<List<Debt>> getDebtsOfTransiction(Transiction transiction) async {
    Database db = await instance.database;
    const sql = '''
        SELECT ${Debt.table}.* 
        FROM ${Debt.table} , ${Person.table} 
        WHERE ${Person.table}.${Person.columnId} = ${Debt.table}.${Debt.columnPersonId}
        AND ${Debt.table}.${Debt.columnTransictionId} = ? ''';
    final debts = await db.rawQuery(sql, [transiction.id]);
    return List.generate(debts.length, (index) => Debt.fromMap(debts[index]));
  }
}
