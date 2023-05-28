class Person {
  static const String tableName = 'person';
  static const String columnId = 'id';
  static const String columnName = 'name';
  

  final int? id;
  String name;

  Person({
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

  static Person fromMap(Map<String, dynamic> map) {
    return Person(
      id: map[columnId],
      name: map[columnName],
    );
  }

  @override
  String toString() {
    return 'Person{$columnId: $id, $columnName: $name}';
  }
}
