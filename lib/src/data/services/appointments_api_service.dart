import 'package:softmed24h/src/data/models/appointment.dart';
import 'package:softmed24h/src/data/network/api_client.dart';

class AppointmentsApiService {
  final ApiClient _apiClient;

  AppointmentsApiService(this._apiClient);

  Future<List<Appointment>> getAppointments() async {
    final response = await _apiClient.get('/appointments/');
    return (response as List)
        .map((item) => Appointment.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> createMeeting(
    CreateMeetingRequest request,
  ) async {
    final response = await _apiClient.post(
      '/appointments/create-meeting',
      body: request.toJson(),
    );
    return response;
  }
}
