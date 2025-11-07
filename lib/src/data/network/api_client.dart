import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:softmed24h/src/data/network/app_exceptions.dart';
import 'package:softmed24h/src/utils/session_manager.dart';

class ApiClient {
  final String _baseUrl = dotenv.env['BASE_URL']!;
  // Placeholder for token retrieval. Implement secure storage here.
  Future<String?> _getToken() async {
    return await SessionManager().getToken();
  }

  Map<String, String> _getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  dynamic _processResponse(http.Response response) {
    developer.log(
      'API Response Status: ${response.statusCode}',
      name: 'ApiClient',
    );
    developer.log('API Response Body: ${response.body}', name: 'ApiClient');

    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        return json.decode(responseJson);
      case 400:
        throw BadRequestException(response.body, response.statusCode);
      case 401:
        throw UnauthorizedException(response.body, response.statusCode);
      case 403:
        throw ForbiddenException(response.body, response.statusCode);
      case 404:
        throw NotFoundException(response.body, response.statusCode);
      case 500:
        throw InternalServerErrorException(response.body, response.statusCode);
      default:
        throw FetchDataException(
          'Error occurred with status code : ${response.statusCode}',
          response.statusCode,
        );
    }
  }

  Future<dynamic> get(String path) async {
    String? token = await _getToken();
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$path'),
        headers: _getHeaders(token),
      );
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on http.ClientException catch (e) {
      throw FetchDataException('HTTP Client Error: ${e.message}');
    } catch (e) {
      developer.log('GET request failed: $e', name: 'ApiClient', error: e);
      rethrow;
    }
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    String? token = await _getToken();
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$path'),
        headers: _getHeaders(token),
        body: json.encode(body),
      );
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on http.ClientException catch (e) {
      throw FetchDataException('HTTP Client Error: ${e.message}');
    } catch (e) {
      developer.log('POST request failed: $e', name: 'ApiClient', error: e);
      rethrow;
    }
  }

  Future<dynamic> postUrlencoded(
    String path, {
    Map<String, String>? body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$path'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on http.ClientException catch (e) {
      throw FetchDataException('HTTP Client Error: ${e.message}');
    } catch (e) {
      developer.log(
        'POST urlencoded request failed: $e',
        name: 'ApiClient',
        error: e,
      );
      rethrow;
    }
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    String? token = await _getToken();
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$path'),
        headers: _getHeaders(token),
        body: json.encode(body),
      );
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on http.ClientException catch (e) {
      throw FetchDataException('HTTP Client Error: ${e.message}');
    } catch (e) {
      developer.log('PUT request failed: $e', name: 'ApiClient', error: e);
      rethrow;
    }
  }

  Future<dynamic> delete(String path) async {
    String? token = await _getToken();
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$path'),
        headers: _getHeaders(token),
      );
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on http.ClientException catch (e) {
      throw FetchDataException('HTTP Client Error: ${e.message}');
    } catch (e) {
      developer.log('DELETE request failed: $e', name: 'ApiClient', error: e);
      rethrow;
    }
  }
}
