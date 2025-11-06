import 'package:softmed24h/src/data/models/queue.dart';
import 'package:softmed24h/src/data/network/api_client.dart';

class QueueApiService {
  final ApiClient _apiClient;

  QueueApiService(this._apiClient);

  Future<Map<String, dynamic>> addToQueue(int patientId) async {
    final response = await _apiClient.post('/queue/$patientId');
    return response;
  }

  Future<Map<String, dynamic>> removeFromQueue(int patientId) async {
    final response = await _apiClient.delete('/queue/$patientId');
    return response;
  }

  Future<List<int>> getQueue() async {
    final response = await _apiClient.get('/queue/');
    return (response as List).cast<int>();
  }

  Future<Map<String, dynamic>> callNextPatient(int doctorId) async {
    final response = await _apiClient.post('/queue/call_next/$doctorId');
    return response;
  }

  Future<QueueStats> getQueueStats() async {
    final response = await _apiClient.get('/queue/stats');
    return QueueStats.fromJson(response);
  }
}
