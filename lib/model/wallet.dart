class Wallet {
  static const String table = 'wallet';
  static const String columnId = 'id';
  static const String columnName = 'name';

  final int? id;
  final String name;

  Wallet({
    this.id,
    required this.name,
  });

  Wallet.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        name = map[columnName];

  Wallet copyWith({int? id, String? name}) {
    return Wallet(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

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

  @override
  String toString() {
    return 'Wallet{$columnId: $id, $columnName: $name}';
  }
}
