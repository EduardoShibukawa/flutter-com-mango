import 'dart:convert';
import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapter<ResponseType> implements HttpClient<ResponseType> {
  final Client client;

  HttpAdapter(this.client);

  Future<ResponseType> request({
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

    try {
      if (method == 'post') {
        response =
            await client.post(Uri.parse(url), headers: headers, body: jsonBody);
      }
    } catch (error) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body.isNotEmpty ? jsonDecode(response.body) : {};
      case 204:
        return {};
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
