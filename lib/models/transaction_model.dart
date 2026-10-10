
class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type;
  final String date;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'date': date,
    };
  }

  factory TransactionModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: map['type'] as String,
      date: map['date'] as String,
    );
  }
}
