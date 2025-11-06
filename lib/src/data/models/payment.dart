import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CreatePaymentIntentRequest {
  final int amount;

  CreatePaymentIntentRequest({required this.amount});

  factory CreatePaymentIntentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentIntentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePaymentIntentRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentIntentResponse {
  final String clientSecret;

  PaymentIntentResponse({required this.clientSecret});

  factory PaymentIntentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentIntentResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CreatePixPaymentRequest {
  final int amount;
  final String description;

  CreatePixPaymentRequest({required this.amount, required this.description});

  factory CreatePixPaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePixPaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePixPaymentRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PixPaymentResponse {
  final String pixTransactionId;
  final String pixQrCodeData;
  final String pixStatus;
  final String message;

  PixPaymentResponse({
    required this.pixTransactionId,
    required this.pixQrCodeData,
    required this.pixStatus,
    this.message = "PIX payment initiated successfully.",
  });

  factory PixPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$PixPaymentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PixPaymentResponseToJson(this);
}
