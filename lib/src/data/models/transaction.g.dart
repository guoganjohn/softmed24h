// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionBase _$TransactionBaseFromJson(Map<String, dynamic> json) =>
    TransactionBase(
      dateTime: json['date_time'] as String,
      invoice: json['invoice'] as String?,
      description: json['description'] as String,
      totalValue: (json['total_value'] as num).toDouble(),
      availableBalance: (json['available_balance'] as num).toDouble(),
      blockedBalance: (json['blocked_balance'] as num).toDouble(),
    );

Map<String, dynamic> _$TransactionBaseToJson(TransactionBase instance) =>
    <String, dynamic>{
      'date_time': instance.dateTime,
      'invoice': instance.invoice,
      'description': instance.description,
      'total_value': instance.totalValue,
      'available_balance': instance.availableBalance,
      'blocked_balance': instance.blockedBalance,
    };

TransactionCreate _$TransactionCreateFromJson(Map<String, dynamic> json) =>
    TransactionCreate(
      dateTime: json['date_time'] as String,
      invoice: json['invoice'] as String?,
      description: json['description'] as String,
      totalValue: (json['total_value'] as num).toDouble(),
      availableBalance: (json['available_balance'] as num).toDouble(),
      blockedBalance: (json['blocked_balance'] as num).toDouble(),
    );

Map<String, dynamic> _$TransactionCreateToJson(TransactionCreate instance) =>
    <String, dynamic>{
      'date_time': instance.dateTime,
      'invoice': instance.invoice,
      'description': instance.description,
      'total_value': instance.totalValue,
      'available_balance': instance.availableBalance,
      'blocked_balance': instance.blockedBalance,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  dateTime: json['date_time'] as String,
  invoice: json['invoice'] as String?,
  description: json['description'] as String,
  totalValue: (json['total_value'] as num).toDouble(),
  availableBalance: (json['available_balance'] as num).toDouble(),
  blockedBalance: (json['blocked_balance'] as num).toDouble(),
  id: (json['id'] as num).toInt(),
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'date_time': instance.dateTime,
      'invoice': instance.invoice,
      'description': instance.description,
      'total_value': instance.totalValue,
      'available_balance': instance.availableBalance,
      'blocked_balance': instance.blockedBalance,
      'id': instance.id,
    };

FinancialSummary _$FinancialSummaryFromJson(Map<String, dynamic> json) =>
    FinancialSummary(
      availableFinancialBalance: (json['available_financial_balance'] as num)
          .toDouble(),
      blockedFinancialBalance: (json['blocked_financial_balance'] as num)
          .toDouble(),
      dailyAttendances: (json['daily_attendances'] as num).toInt(),
      monthlyAttendances: (json['monthly_attendances'] as num).toInt(),
      myRating: (json['my_rating'] as num).toDouble(),
      timeInConsultationMinutes: (json['time_in_consultation_minutes'] as num)
          .toDouble(),
    );

Map<String, dynamic> _$FinancialSummaryToJson(FinancialSummary instance) =>
    <String, dynamic>{
      'available_financial_balance': instance.availableFinancialBalance,
      'blocked_financial_balance': instance.blockedFinancialBalance,
      'daily_attendances': instance.dailyAttendances,
      'monthly_attendances': instance.monthlyAttendances,
      'my_rating': instance.myRating,
      'time_in_consultation_minutes': instance.timeInConsultationMinutes,
    };
