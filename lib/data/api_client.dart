import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient(this._http, {this.baseUrl = 'https://dummyjson.com'});
  final http.Client _http;
  final String baseUrl;

  Future<Map<String, dynamic>> get(String path) async {
    try {
      final response = await _http.get(Uri.parse('$baseUrl$path')).timeout(const Duration(seconds: 15));
      return _decode(response);
    } on SocketException {
      throw const ApiException('No internet connection. Please check your network.');
    } on TimeoutException {
      throw const ApiException('Connection timed out. Please try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const ApiException('An unexpected network error occurred.');
    }
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, Object?> body,
  ) async {
    try {
      final response = await _http.post(
        Uri.parse('$baseUrl$path'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));
      return _decode(response);
    } on SocketException {
      throw const ApiException('No internet connection. Please check your network.');
    } on TimeoutException {
      throw const ApiException('Connection timed out. Please try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const ApiException('An unexpected network error occurred.');
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    try {
      final dynamic value = jsonDecode(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = value is Map<String, dynamic>
            ? value['message']?.toString() ??
                  'Request failed (${response.statusCode})'
            : 'Request failed (${response.statusCode})';
        throw ApiException(message);
      }
      if (value is! Map<String, dynamic>) {
        throw const ApiException('Unexpected response from server.');
      }
      return value;
    } on FormatException {
      throw const ApiException('Invalid response format from server.');
    }
  }
}
