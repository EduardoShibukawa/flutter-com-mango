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
    final response =
        await client.post(Uri.parse(url), headers: headers, body: jsonBody);

    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : {};
    }

    if (response.statusCode == 204) {
      return {};
    }

    if (response.statusCode == 400) {
      throw HttpError.badRequest;
    }

    if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    }

    throw HttpError.serverError;
  }
}
