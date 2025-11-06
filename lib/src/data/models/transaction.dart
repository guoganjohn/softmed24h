import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionBase {
  final String dateTime;
  final String? invoice;
  final String description;
  final double totalValue;
  final double availableBalance;
  final double blockedBalance;

  TransactionBase({
    required this.dateTime,
    this.invoice,
    required this.description,
    required this.totalValue,
    required this.availableBalance,
    required this.blockedBalance,
  });

  factory TransactionBase.fromJson(Map<String, dynamic> json) =>
      _$TransactionBaseFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionBaseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionCreate extends TransactionBase {
  TransactionCreate({
    required super.dateTime,
    super.invoice,
    required super.description,
    required super.totalValue,
    required super.availableBalance,
    required super.blockedBalance,
  });

  factory TransactionCreate.fromJson(Map<String, dynamic> json) =>
      _$TransactionCreateFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TransactionCreateToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Transaction extends TransactionBase {
  final int id;

  Transaction({
    required super.dateTime,
    super.invoice,
    required super.description,
    required super.totalValue,
    required super.availableBalance,
    required super.blockedBalance,
    required this.id,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FinancialSummary {
  final double availableFinancialBalance;
  final double blockedFinancialBalance;
  final int dailyAttendances;
  final int monthlyAttendances;
  final double myRating;
  final double timeInConsultationMinutes;

  FinancialSummary({
    required this.availableFinancialBalance,
    required this.blockedFinancialBalance,
    required this.dailyAttendances,
    required this.monthlyAttendances,
    required this.myRating,
    required this.timeInConsultationMinutes,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) =>
      _$FinancialSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$FinancialSummaryToJson(this);
}
