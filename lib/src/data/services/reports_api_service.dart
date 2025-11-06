import 'package:softmed24h/src/data/models/report.dart';
import 'package:softmed24h/src/data/network/api_client.dart';

class ReportsApiService {
  final ApiClient _apiClient;

  ReportsApiService(this._apiClient);

  Future<ReportResponse> getReports() async {
    final response = await _apiClient.get('/reports/');
    return ReportResponse.fromJson(response);
  }
}
