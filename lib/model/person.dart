class Person {
  static const String table = 'person';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnWalletId = 'walletId';

  final int? id;
  final String name;
  final int walletId;

  Person({
    this.id,
    required this.name,
    required this.walletId,
  });

  Person.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        name = map[columnName],
        walletId = map[columnWalletId];

  Map<String, dynamic> toMap() {
    var toReturn = {
      columnName: name,
      columnWalletId: walletId,
    };
    if (id != null) {
      toReturn.putIfAbsent(columnId, () => id!);
    }
    return toReturn;
  }

  @override
  String toString() {
    return 'Person{$columnId: $id, $columnName: $name}';
  }
}
