// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePaymentIntentRequest _$CreatePaymentIntentRequestFromJson(
  Map<String, dynamic> json,
) => CreatePaymentIntentRequest(amount: (json['amount'] as num).toInt());

Map<String, dynamic> _$CreatePaymentIntentRequestToJson(
  CreatePaymentIntentRequest instance,
) => <String, dynamic>{'amount': instance.amount};

PaymentIntentResponse _$PaymentIntentResponseFromJson(
  Map<String, dynamic> json,
) => PaymentIntentResponse(clientSecret: json['client_secret'] as String);

Map<String, dynamic> _$PaymentIntentResponseToJson(
  PaymentIntentResponse instance,
) => <String, dynamic>{'client_secret': instance.clientSecret};

CreatePixPaymentRequest _$CreatePixPaymentRequestFromJson(
  Map<String, dynamic> json,
) => CreatePixPaymentRequest(
  amount: (json['amount'] as num).toInt(),
  description: json['description'] as String,
);

Map<String, dynamic> _$CreatePixPaymentRequestToJson(
  CreatePixPaymentRequest instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'description': instance.description,
};

PixPaymentResponse _$PixPaymentResponseFromJson(Map<String, dynamic> json) =>
    PixPaymentResponse(
      pixTransactionId: json['pix_transaction_id'] as String,
      pixQrCodeData: json['pix_qr_code_data'] as String,
      pixStatus: json['pix_status'] as String,
      message:
          json['message'] as String? ?? "PIX payment initiated successfully.",
    );

Map<String, dynamic> _$PixPaymentResponseToJson(PixPaymentResponse instance) =>
    <String, dynamic>{
      'pix_transaction_id': instance.pixTransactionId,
      'pix_qr_code_data': instance.pixQrCodeData,
      'pix_status': instance.pixStatus,
      'message': instance.message,
    };
