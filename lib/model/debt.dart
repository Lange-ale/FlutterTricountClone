class Debt {
  static const String table = 'debt';
  static const String columnId = 'id';
  static const String columnTransictionId = 'transictionId';
  static const String columnPersonId = 'personId';
  static const String columnAmount = 'amount';

  final int? id;
  final int? transictionId;
  final int personId;
  double amount;

  Debt({
    this.id,
    required this.transictionId,
    required this.personId,
    required this.amount,
  });

  Debt.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        transictionId = map[columnTransictionId],
        personId = map[columnPersonId],
        amount = map[columnAmount];

  Debt copyWith({
    int? id,
    int? transictionId,
    int? personId,
    double? amount,
  }) {
    return Debt(
      id: id ?? this.id,
      transictionId: transictionId ?? this.transictionId,
      personId: personId ?? this.personId,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    var toReturn = {
      columnTransictionId: transictionId,
      columnPersonId: personId,
      columnAmount: amount,
    };
    if (id != null) {
      toReturn.putIfAbsent(columnId, () => id!);
    }
    return toReturn;
  }

  @override
  String toString() {
    return 'Debt{$columnId: $id, $columnTransictionId: $transictionId, $columnPersonId: $personId, $columnAmount: $amount}';
  }
}
