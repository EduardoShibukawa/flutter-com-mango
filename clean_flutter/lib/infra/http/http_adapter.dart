import 'dart:convert';
import 'package:http/http.dart';

import 'package:clean_flutter/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    var jsonBody = body != null ? jsonEncode(body) : null;

    var response = Response('', 500);
    if (method == 'post') {
      response =
          await client.post(Uri.parse(url), headers: headers, body: jsonBody);
    }

    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    switch(response.statusCode) {
      case 200: return response.body.isNotEmpty ? jsonDecode(response.body) : {};
      case 204: return {};
      case 400: throw HttpError.badRequest;
      case 401: throw HttpError.unauthorized;
      case 403: throw HttpError.forbidden;
      case 404: throw HttpError.notFound;
      default:
        throw HttpError.serverError;
    }
  }
}
