import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

/// 10.0.2.2 é o alias padrão do emulador Android para o `localhost` da
/// máquina host (onde roda `php artisan serve`). Em dispositivo físico ou
/// iOS Simulator, ajustar para o IP/host real da API.
const String apiBaseUrl = 'http://10.0.2.2:8000/api/v1';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  Future<String?> get token => _storage.read(key: _tokenKey);

  Future<void> saveToken(String token) => _storage.write(
    key: _tokenKey,
    value: token,
  );

  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<Map<String, String>> _headers({bool authenticated = true}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authenticated) {
      final storedToken = await token;
      if (storedToken != null) {
        headers['Authorization'] = 'Bearer $storedToken';
      }
    }

    return headers;
  }

  Future<dynamic> get(String path, {bool authenticated = true}) async {
    final response = await http.get(
      Uri.parse('$apiBaseUrl$path'),
      headers: await _headers(authenticated: authenticated),
    );
    return _handle(response);
  }

  Future<dynamic> post(
    String path,
    Map<String, dynamic> body, {
    bool authenticated = true,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl$path'),
      headers: await _headers(authenticated: authenticated),
      body: jsonEncode(body),
    );
    return _handle(response);
  }

  dynamic _handle(http.Response response) {
    final hasBody = response.body.isNotEmpty;
    final decoded = hasBody ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    String message = 'Erro ao comunicar com o servidor (${response.statusCode}).';
    if (decoded is Map<String, dynamic>) {
      if (decoded['errors'] is Map) {
        final errors = (decoded['errors'] as Map).values.expand((v) => v as List);
        if (errors.isNotEmpty) message = errors.first.toString();
      } else if (decoded['message'] != null) {
        message = decoded['message'].toString();
      }
    }

    throw ApiException(message, statusCode: response.statusCode);
  }
}
