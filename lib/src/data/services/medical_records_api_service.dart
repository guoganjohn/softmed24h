import 'package:softmed24h/src/data/network/api_client.dart';

class MedicalRecordsApiService {
  final ApiClient _apiClient;

  MedicalRecordsApiService(this._apiClient);

  Future<String> getMedicalRecords() async {
    final response = await _apiClient.get('/medical_records/');
    return response['message'];
  }
}
