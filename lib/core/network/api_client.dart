import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pakistani_independence_wallpapers/core/exceptions/api_exception.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> get(
    String url, {
    required Map<String, String> queryParameters,
  }) async {
    try {
      final uri = Uri.parse(url).replace(queryParameters: queryParameters);
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 20));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw const ApiException('Server error. Please try again later.');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('Invalid response from server.');
      }

      return decoded;
    } on TimeoutException {
      throw const ApiException('Request timed out. Please try again.');
    } on SocketException {
      throw const ApiException('No internet connection.');
    } on FormatException {
      throw const ApiException('Invalid response from server.');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Something went wrong. Please try again.');
    }
  }

  Future<Map<String, dynamic>> post(
    String url, {
    required Map<String, String> body,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw const ApiException('Server error. Please try again later.');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('Invalid response from server.');
      }

      return decoded;
    } on TimeoutException {
      throw const ApiException('Request timed out. Please try again.');
    } on SocketException {
      throw const ApiException('No internet connection.');
    } on FormatException {
      throw const ApiException('Invalid response from server.');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Something went wrong. Please try again.');
    }
  }
}
