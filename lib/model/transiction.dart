class Transiction {
  static const String table = 'transiction';
  static const String columnId = 'id';
  static const String columnPersonId = 'personId';
  static const String columnTotalAmount = 'totalAmount';
  static const String columnDate = 'date';
  static const String columnDescription = 'description';

  final int? id;
  int personId;
  double totalAmount;
  DateTime date;
  String description;

  Transiction({
    this.id,
    required this.personId,
    required this.totalAmount,
    required this.date,
    required this.description,
  });

  Transiction copyWith(
      {int? id,
      int? personId,
      double? totalAmount,
      DateTime? date,
      String? description}) {
    return Transiction(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      totalAmount: totalAmount ?? this.totalAmount,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  Transiction.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        personId = map[columnPersonId],
        totalAmount = map[columnTotalAmount],
        date = DateTime.parse(map[columnDate]),
        description = map[columnDescription];

  Map<String, dynamic> toMap() {
    var toReturn = {
      columnPersonId: personId,
      columnTotalAmount: totalAmount,
      columnDate: date.toIso8601String(),
      columnDescription: description,
    };
    if (id != null) {
      toReturn.putIfAbsent(columnId, () => id!);
    }
    return toReturn;
  }

  @override
  String toString() {
    return 'Transiction{$columnId: $id, $columnPersonId: $personId, $columnTotalAmount: $totalAmount, $columnDate: $date, $columnDescription: $description}';
  }
}
