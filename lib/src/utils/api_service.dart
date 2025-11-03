import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = dotenv.env['BASE_URL']!;

  Future<AuthResponse> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/token');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$_baseUrl/forgot-password');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      // Successfully sent reset link request
      return;
    } else {
      throw Exception('Failed to request password reset: ${response.body}');
    }
  }

  Future<void> resetPassword(
      String token, String newPassword, String confirmNewPassword) async {
    final url = Uri.parse('$_baseUrl/reset-password'); // Assuming this endpoint
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'token': token,
        'new_password': newPassword,
        'confirm_password': confirmNewPassword,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to reset password: ${response.body}');
    }
  }

  Future<User> register(
      String email,
      String password,
      String name,
      String? gender,
      String cpf,
      String phone,
      String birthday,
      String cep,
      String logradouro,
      String numero,
      String? complemento,
      String bairro,
      String estado,
      String cidade,
      ) async {
    final url = Uri.parse('$_baseUrl/users/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
        'name': name,
        'gender': gender,
        'cpf': cpf,
        'phone': phone,
        'birthday': birthday,
        'cep': cep,
        'logradouro': logradouro,
        'numero': numero,
        'complemento': complemento,
        'bairro': bairro,
        'estado': estado,
        'cidade': cidade,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register user: ${response.body}');
    }
  }
  Future<User> getCurrentUser(String accessToken) async {
    final url = Uri.parse('$_baseUrl/users/me');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Token expired or invalid.');
    } else {
      throw Exception('Failed to fetch current user: ${response.body}');
    }
  }
}

class AuthResponse {
  final String accessToken;
  final String tokenType;

  AuthResponse({required this.accessToken, required this.tokenType});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}

class User {
  final int id;
  final String email;
  final bool isActive;
  final String? name;
  final String? gender;
  final String? cpf;
  final String phone; // Now non-nullable
  final String? birthday;
  final String? cep;
  final String? logradouro;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? estado;
  final String? cidade;
  final bool hasActivePayment; // New field

  User({
    required this.id,
    required this.email,
    required this.isActive,
    this.name,
    this.gender,
    this.cpf,
    required this.phone, // Now required
    this.birthday,
    this.cep,
    this.logradouro,
    this.numero,
    this.complemento,
    this.bairro,
    this.estado,
    this.cidade,
    required this.hasActivePayment, // Now required
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      isActive: json['is_active'],
      name: json['name'],
      gender: json['gender'],
      cpf: json['cpf'],
      phone: json['phone'],
      birthday: json['birthday'],
      cep: json['cep'],
      logradouro: json['logradouro'],
      numero: json['numero'],
      complemento: json['complemento'],
      bairro: json['bairro'],
      estado: json['estado'],
      cidade: json['cidade'],
      hasActivePayment: json['has_active_payment'],
    );
  }
}
