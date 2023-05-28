class Balance {
  static const String tableName = 'balance';
  static const String columnId = 'id';
  static const String columnPersonId = 'personId';
  static const String columnWalletId = 'walletId';
  static const String columnAmount = 'amount';

  final int? id;
  final int personId;
  final int walletId;
  final double amount;

  Balance({
    this.id,
    required this.personId,
    required this.walletId,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    if (id == null) {
      return {
        columnPersonId: personId,
        columnWalletId: walletId,
        columnAmount: amount,
      };
    } else {
      return {
        columnId: id,
        columnPersonId: personId,
        columnWalletId: walletId,
        columnAmount: amount,
      };
    }
  }

  static Balance fromMap(Map<String, dynamic> map) {
    return Balance(
      id: map[columnId],
      personId: map[columnPersonId],
      walletId: map[columnWalletId],
      amount: map[columnAmount],
    );
  }

  @override
  String toString() {
    return 'Balance{$columnId: $id, $columnPersonId: $personId, $columnWalletId: $walletId, $columnAmount: $amount}';
  }
}