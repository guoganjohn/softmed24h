import 'package:softmed24h/src/data/models/user.dart';
import 'package:softmed24h/src/data/network/api_client.dart';

class UserApiService {
  final ApiClient _apiClient;

  UserApiService(this._apiClient);

  Future<UserMeResponse> getMe() async {
    final response = await _apiClient.get('/users/me');
    return UserMeResponse.fromJson(response);
  }

  Future<User> createUser(UserCreate user) async {
    final response = await _apiClient.post('/users/', body: user.toJson());
    return User.fromJson(response);
  }

  Future<void> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _apiClient.put(
      '/users/me/password',
      body: {'current_password': currentPassword, 'new_password': newPassword},
    );
  }
}
