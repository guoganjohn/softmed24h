class PixPaymentResponse {
  final String pixTransactionId;
  final String pixQrCodeData;
  final String pixStatus;
  final String message;

  PixPaymentResponse({
    required this.pixTransactionId,
    required this.pixQrCodeData,
    required this.pixStatus,
    required this.message,
  });

  factory PixPaymentResponse.fromJson(Map<String, dynamic> json) {
    return PixPaymentResponse(
      pixTransactionId: json['pix_transaction_id'],
      pixQrCodeData: json['pix_qr_code_data'],
      pixStatus: json['pix_status'],
      message: json['message'],
    );
  }
}
