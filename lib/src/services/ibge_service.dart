import 'dart:convert';
import 'package:http/http.dart' as http;

class IbgeService {
  Future<List<String>> fetchStates() async {
    final response = await http.get(
      Uri.parse('https://servicodados.ibge.gov.br/api/v1/localidades/estados'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((state) => state['sigla'] as String).toList()..sort();
    } else {
      throw Exception('Failed to load states');
    }
  }

  Future<List<String>> fetchCities(String state) async {
    final response = await http.get(
      Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$state/municipios',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((city) => city['nome'] as String).toList()..sort();
    } else {
      throw Exception('Failed to load cities');
    }
  }
}
