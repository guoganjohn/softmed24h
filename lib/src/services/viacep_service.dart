import 'dart:convert';
import 'package:http/http.dart' as http;

class ViaCepService {
  Future<Map<String, dynamic>> fetchAddress(String cep) async {
    final response = await http.get(
      Uri.parse('https://viacep.com.br/ws/$cep/json/'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load address');
    }
  }
}
