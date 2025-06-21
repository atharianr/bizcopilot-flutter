import 'dart:convert';
import 'dart:io';

import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:http/http.dart' as http;

typedef ResponseParser<T> = T Function(Map<String, dynamic> json);

class BaseNetwork {
  static Future<T> post<T>({
    required Uri url,
    required Map<String, String> headers,
    required Map<String, dynamic> body,
    required ResponseParser<T> parser,
    int successCode = 201,
  }) async {
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

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
