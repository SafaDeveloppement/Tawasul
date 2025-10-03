import 'package:http/http.dart' as http;

class RequestDebugger {
  static void debugRequest(String method, String url, Map<String, String> headers, [String? body]) {
    print(' REQUEST DEBUG:');
    print(' Method: $method');
    print(' URL: $url');
    print(' Headers:');
    headers.forEach((key, value) {
      print('  $key: $value');
    });
    if (body != null) {
      print(' Body: $body');
    }
    print(' END DEBUG');
  }

  static void debugResponse(http.Response response) {
    print('RESPONSE DEBUG:');
    print(' Status Code: ${response.statusCode}');
    print(' Headers:');
    response.headers.forEach((key, value) {
      print('  $key: $value');
    });
    print(' Body: ${response.body}');
    print('END DEBUG');
  }
}