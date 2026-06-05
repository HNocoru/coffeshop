import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  // ← NUEVO: callback para 401
  VoidCallback? onUnauthorized;

  ApiClient();

  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'https://l7kjcnjq-8080.use2.devtunnels.ms';
    }
    return 'http://127.0.0.1:8000';
  }

  Future<Map<String, String>> _headers({bool requireAuth = true}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (requireAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';
      if (token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // ← SOLO UN _parse, con el 401 adentro
  dynamic _parse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      onUnauthorized?.call();
    }

    String message = 'Error del servidor (${response.statusCode})';
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body.containsKey('detail')) {
        message = body['detail'].toString();
      }
    } catch (_) {}

    throw ApiException(message, statusCode: response.statusCode);
  }

  Future<dynamic> get(String path) async {
    try {
      final headers = await _headers();
      final url = Uri.parse('$baseUrl$path');

      debugPrint('➡️ GET $url');
      debugPrint('HEADERS: $headers');

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 15));

      debugPrint('⬅️ STATUS ${response.statusCode} GET $url');
      debugPrint('BODY: ${response.body}');

      return _parse(response);
    } on SocketException {
      throw ApiException('No se pudo conectar con el servidor');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } on FormatException {
      throw ApiException('Respuesta inválida del servidor');
    }
  }

  Future<dynamic> post(
    String path,
    Map<String, dynamic> body, {
    bool requireAuth = true,
  }) async {
    try {
      final headers = await _headers(requireAuth: requireAuth);
      final url = Uri.parse('$baseUrl$path');
  
      debugPrint('➡️ POST $url');
      debugPrint('HEADERS: $headers');
      debugPrint('BODY(SEND): ${jsonEncode(body)}');
  
      final response = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
  
      debugPrint('⬅️ STATUS ${response.statusCode} POST $url');
      debugPrint('BODY(RECV): ${response.body}');
  
      return _parse(response);
    } on SocketException {
      throw ApiException('No se pudo conectar con el servidor');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } on FormatException {
      throw ApiException('Respuesta inválida del servidor');
    }
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    try {
      final headers = await _headers();
      final response = await http
          .put(
            Uri.parse('$baseUrl$path'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
      return _parse(response);
    } on SocketException {
      throw ApiException('No se pudo conectar con el servidor');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } on FormatException {
      throw ApiException('Respuesta inválida del servidor');
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final headers = await _headers();
      final response = await http
          .delete(Uri.parse('$baseUrl$path'), headers: headers)
          .timeout(const Duration(seconds: 15));
      return _parse(response);
    } on SocketException {
      throw ApiException('No se pudo conectar con el servidor');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } on FormatException {
      throw ApiException('Respuesta inválida del servidor');
    }
  }
}
