import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client httpClient;
  final String _baseUrl = 'https://62ed0389a785760e67622eb2.mockapi.io/spots/v1';

  ApiClient({http.Client? client}) : httpClient = client ?? http.Client();

  Future<List<dynamic>> getCampsitesRaw() async {
    final url = Uri.parse('$_baseUrl/campsites');

    try {
      final response = await httpClient.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw HttpException('Failed to load campsites: ${response.statusCode}');
      }

      final decoded = json.decode(response.body);
      if (decoded is! List) {
        throw FormatException('Unexpected JSON format: expected a List');
      }

      return decoded;
    } on SocketException {
      throw Exception('No Internet connection.');
    } on FormatException catch (e) {
      throw Exception('Bad response format: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('HTTP Client error: ${e.message}');
    } on TimeoutException {
      throw Exception('Request timed out.');
    } catch (e) {
      rethrow; // For other unknown exceptions
    }
  }
}
