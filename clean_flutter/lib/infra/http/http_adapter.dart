import 'dart:convert';
import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<dynamic> request({
    required String url,
    required String method,
    Map? headers,
    Map? body,
  }) async {
    final Map<String, String> defaulHeader =
        headers?.cast<String, String>() ?? {}
          ..addAll({
            'content-type': 'application/json',
            'accept': 'application/json',
          });
    var jsonBody = body != null ? jsonEncode(body) : null;

    var response = Response('', 500);

    try {
      if (method == 'post') {
        response = await client
            .post(
              Uri.parse(url),
              headers: defaulHeader,
              body: jsonBody,
            )
            .timeout(Duration(seconds: 5));
      } else if (method == 'get') {
        response = await client
            .get(
              Uri.parse(url),
              headers: defaulHeader,
            )
            .timeout(Duration(seconds: 5));
      }
    } catch (error) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body.isNotEmpty ? jsonDecode(response.body) : null;
      case 204:
        return null;
      case 400:
        throw HttpError.badRequest;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        throw HttpError.notFound;
      default:
        throw HttpError.serverError;
    }
  }
}
