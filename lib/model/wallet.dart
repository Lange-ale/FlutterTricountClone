class Wallet {
  static const String tableName = 'wallet';
  static const String columnId = 'id';
  static const String columnName = 'name';

  int? id;
  String name;

  Wallet({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    if (id == null) {
      return {
        columnName: name,
      };
    } else {
      return {
        columnId: id,
        columnName: name,
      };
    }
  }

  static Wallet fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: map[columnId],
      name: map[columnName],
    );
  }

  @override
  String toString() {
    return 'Wallet{$columnId: $id, $columnName: $name}';
  }
}
