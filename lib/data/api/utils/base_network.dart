import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

typedef ResponseParser<T> = T Function(Map<String, dynamic> json);

class BaseNetwork {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

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

      _logger.i('🚀 $method Request => $url');
      _logger.d('Headers: ${jsonEncode(headers)}');
      if (body != null) {
        _logger.d('Body: ${jsonEncode(body)}');
      }

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

      _logger.i('✅ Response [${response.statusCode}] => $url');
      _logger.d('Response Body: ${response.body}');

      if (response.statusCode == successCode) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return parser(json);
      } else {
        _logger.e('❌ API Error [${response.statusCode}] => $url');
        _logger.e('Error Body: ${response.body}');
        throw Exception('Request failed: ${response.statusCode}');
      }
    } on SocketException catch (e, stackTrace) {
      _logger.e('📡 No internet connection.', error: e, stackTrace: stackTrace);
      throw Exception('No internet connection. Please try again later.');
    } on HttpException catch (e, stackTrace) {
      _logger.e('🛑 HTTP exception.', error: e, stackTrace: stackTrace);
      throw Exception('Failed to communicate with the server.');
    } on FormatException catch (e, stackTrace) {
      _logger.e(
        '⚠️ Format exception (Invalid JSON).',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Bad response format from server.');
    } catch (e, stackTrace) {
      _logger.e(
        '🔥 Unexpected error: ${e.toString()}',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }
}
