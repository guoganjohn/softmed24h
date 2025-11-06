import 'package:softmed24h/src/data/models/payment.dart';
import 'package:softmed24h/src/data/network/api_client.dart';

class PaymentApiService {
  final ApiClient _apiClient;

  PaymentApiService(this._apiClient);

  Future<PaymentIntentResponse> createPaymentIntent(
    CreatePaymentIntentRequest request,
  ) async {
    final response = await _apiClient.post(
      '/payments/create-payment-intent',
      body: request.toJson(),
    );
    return PaymentIntentResponse.fromJson(response);
  }

  Future<PixPaymentResponse> createPixPayment(
    CreatePixPaymentRequest request,
  ) async {
    final response = await _apiClient.post(
      '/payments/create-pix-payment',
      body: request.toJson(),
    );
    return PixPaymentResponse.fromJson(response);
  }
}
