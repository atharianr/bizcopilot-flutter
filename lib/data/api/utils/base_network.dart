import 'dart:convert';
import 'dart:io';

import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:http/http.dart' as http;

typedef ResponseParser<T> = T Function(Map<String, dynamic> json);

class BaseNetwork {
  static Future<T> get<T>({
    required Uri url,
    required Map<String, String> headers,
    required ResponseParser<T> parser,
    int successCode = 200,
  }) {
    return _request(
      method: 'GET',
      url: url,
      headers: headers,
      parser: parser,
      successCode: successCode,
    );
  }

  static Future<T> post<T>({
    required Uri url,
    required Map<String, String> headers,
    required Map<String, dynamic> body,
    required ResponseParser<T> parser,
    int successCode = 201,
  }) {
    return _request(
      method: 'POST',
      url: url,
      headers: headers,
      body: body,
      parser: parser,
      successCode: successCode,
    );
  }

  static Future<T> put<T>({
    required Uri url,
    required Map<String, String> headers,
    required Map<String, dynamic> body,
    required ResponseParser<T> parser,
    int successCode = 200,
  }) {
    return _request(
      method: 'PUT',
      url: url,
      headers: headers,
      body: body,
      parser: parser,
      successCode: successCode,
    );
  }

  static Future<T> delete<T>({
    required Uri url,
    required Map<String, String> headers,
    required ResponseParser<T> parser,
    int successCode = 200,
  }) {
    return _request(
      method: 'DELETE',
      url: url,
      headers: headers,
      parser: parser,
      successCode: successCode,
    );
  }

  static Future<T> patch<T>({
    required Uri url,
    required Map<String, String> headers,
    required Map<String, dynamic> body,
    required ResponseParser<T> parser,
    int successCode = 200,
  }) {
    return _request(
      method: 'PATCH',
      url: url,
      headers: headers,
      body: body,
      parser: parser,
      successCode: successCode,
    );
  }

  static Future<T> _request<T>({
    required String method,
    required Uri url,
    required Map<String, String> headers,
    Map<String, dynamic>? body,
    required ResponseParser<T> parser,
    required int successCode,
  }) async {
    try {
      http.Response response;

      switch (method) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        case 'PATCH':
          response = await http.patch(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      if (response.statusCode == successCode) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return parser(json);
      } else {
        throw Exception('Request failed: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please try again later.');
    } on HttpException {
      throw Exception('Failed to communicate with the server.');
    } on FormatException {
      throw Exception('Bad response format from server.');
    } catch (e) {
      throw Exception('Unexpected error: ${e.getMessage()}');
    }
  }
}
