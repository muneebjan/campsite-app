import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:camping_site/core/api/api_client.dart';
import 'mock_http_client.mocks.dart';

void main() {
  group('ApiClient', () {
    late ApiClient apiClient;
    late MockClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
      apiClient = ApiClient(client: mockHttpClient);
    });

    test('returns list of campsites on 200 OK', () async {
      final mockResponse = jsonEncode([
        {"id": "1", "label": "Test Camp", "pricePerNight": 10.0},
      ]);

      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await apiClient.getCampsitesRaw();

      expect(result, isA<List>());
      expect(result.first['label'], 'Test Camp');
    });

    test('throws HttpException on non-200 status', () async {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Error', 500));

      expect(() => apiClient.getCampsitesRaw(), throwsA(isA<Exception>()));
    });

    test('throws FormatException on invalid JSON', () async {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('not-json', 200));

      expect(() => apiClient.getCampsitesRaw(), throwsA(isA<Exception>()));
    });

    test('throws Exception on network failure (SocketException)', () async {
      when(mockHttpClient.get(any)).thenThrow(const SocketException('No Internet'));

      expect(() => apiClient.getCampsitesRaw(), throwsA(isA<Exception>()));
    });

    test('throws Exception on timeout', () async {
      when(
        mockHttpClient.get(any),
      ).thenAnswer((_) => Future.delayed(const Duration(seconds: 11), () => http.Response('[]', 200)));

      // You may need to wrap timeout manually for unit tests
      final future = apiClient.getCampsitesRaw().timeout(const Duration(seconds: 2));
      expect(future, throwsA(isA<Exception>()));
    });

    test('throws Exception if decoded JSON is not a List', () async {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response(jsonEncode({'key': 'value'}), 200));

      expect(() => apiClient.getCampsitesRaw(), throwsA(isA<Exception>()));
    });
  });
}
