import 'package:softmed24h/src/data/models/auth.dart';
import 'package:softmed24h/src/data/network/api_client.dart';

class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService(this._apiClient);

  Future<Token> login(String username, String password) async {
    final response = await _apiClient.postUrlencoded(
      '/auth/token',
      body: {'username': username, 'password': password},
    );
    return Token.fromJson(response);
  }
}
