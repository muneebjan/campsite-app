import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final _baseUrl = 'https://62ed0389a785760e67622eb2.mockapi.io/spots/v1';

  Future<List<dynamic>> getCampsitesRaw() async {
    final url = Uri.parse('$_baseUrl/campsites');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load campsites');
    }
  }
}
