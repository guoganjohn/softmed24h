import 'package:softmed24h/src/data/models/prescription.dart';
import 'package:softmed24h/src/data/network/api_client.dart';

class PrescriptionsApiService {
  final ApiClient _apiClient;

  PrescriptionsApiService(this._apiClient);

  Future<Map<String, dynamic>> createPrescription(
    CreatePrescriptionRequest request,
  ) async {
    final response = await _apiClient.post(
      '/prescriptions/',
      body: request.toJson(),
    );
    return response;
  }
}
