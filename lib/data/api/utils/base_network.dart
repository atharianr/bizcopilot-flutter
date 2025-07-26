import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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

  static Future<T?> postImage<T>({
    required Uri url,
    required Map<String, String> headers,
    ResponseParser<T>? parser,
    int successCode = 201,
    required String method,
    required File file,
  }) async {
    if (url.host.contains('s3.amazonaws.com') ||
        url.host.contains('amazonaws.com')) {
      final uri = Uri.parse(url.toString());
      // final lastUri = uri.replace(
      //   queryParameters: {
      //     ...uri.queryParameters,
      //     ...{
      //       'AWSAccessKeyId': 'AKIASE5KRCO64GKGFTVZ',
      //       'Signature': 'kHld6QXvJxHoZFmjgJdBWG8aVrQ%3D',
      //       'content-type': 'image%2Fpng',
      //       'Expires': '1752502134',
      //     },
      //   },
      // );
      final bytes = await file.readAsBytes();

      final request =
          http.Request('PUT', uri)
            ..headers['Content-Type'] = 'image/png}'
            ..bodyBytes = bytes;
      request.headers.clear();
      request.headers['Content-Type'] = 'image/png';

      String curlCommand = requestToCurl(request, file);
      print("Equivalent curl command:");
      print(curlCommand);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Debug output for S3
      print("S3 Upload - Status: ${response.statusCode}");
      print("S3 Upload - Headers: ${response.headers}");

      if (response.statusCode != 200) {
        final errorBody = response.body;
        print("S3 Error: ${response.statusCode} - $errorBody");
        throw Exception('Upload failed:');
      }
      return null;
    }
    var currentRequest = http.MultipartRequest(method, url);
    currentRequest.files.add(
      http.MultipartFile(
        "file",
        file!.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path.split('/').last,
        contentType: MediaType('image', 'png'),
      ),
    );

    currentRequest.headers.addAll(headers);

    var response = await currentRequest.send();

    final b = StringBuffer();
    b.write("curl -X ${currentRequest.method} '${currentRequest.url}'");

    currentRequest.headers.forEach((k, v) {
      b.write(" -H '${k}: $v'");
    });

    // add the file form‐field
    final filename = file.path.split('/').last;
    b.write(" -F 'file=@${file.path};filename=$filename;type=image/png'");

    print(b.toString());

    if (response.statusCode == 200) {
      final json = jsonDecode(await response.stream.bytesToString());
      if (parser != null) {
        return parser(json);
      } else {
        return null;
      }
    } else {
      throw Exception('Request failed: ${response.statusCode}');
    }
  }

  static Future<void> uploadToS3({
    required String presignedUrl,
    required File file,
  }) async {
    final client = HttpClient();
    final uri = Uri.parse(presignedUrl);
    final req = await client.openUrl('PUT', uri);

    // set only the headers you signed
    req.headers..set('content-type', 'image/png');

    // stream the file
    await req.addStream(file.openRead());
    final resp = await req.close();

    if (resp.statusCode == 200) {
      print('✅ Upload succeeded!');
    } else {
      print('⛔ Upload failed (${resp.statusCode}): ${resp}');
      throw Exception('S3 upload failed');
    }
  }

  static String requestToCurl(http.Request request, File file) {
    final buffer = StringBuffer();

    // Start with curl command
    buffer.write('curl -v');

    // Add HTTP method
    buffer.write(' -X ${request.method}');

    // Add headers
    request.headers.forEach((key, value) {
      buffer.write(' -H "$key: $value"');
    });

    // Add file upload
    buffer.write(' --upload-file "${file.path}"');

    // Add URL with proper escaping
    buffer.write(' "${request.url}"');

    return buffer.toString();
  }

  // Alternative version with more formatting options
  static String requestToCurlFormatted(http.Request request, File file) {
    final buffer = StringBuffer();

    buffer.writeln('curl -v \\');
    buffer.writeln('  -X ${request.method} \\');

    // Add headers with line breaks for readability
    request.headers.forEach((key, value) {
      buffer.writeln('  -H "$key: $value" \\');
    });

    buffer.writeln('  --upload-file "${file.path}" \\');
    buffer.write('  "${request.url}"');

    return buffer.toString();
  }

  static Future<T> _request<T>({
    required String method,
    required Uri url,
    required Map<String, String> headers,
    Map<String, dynamic>? body,
    required ResponseParser<T> parser,
    required int successCode,
    File? file = null,
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
