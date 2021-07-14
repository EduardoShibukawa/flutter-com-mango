import 'package:clean_flutter/data/http/http.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';

class RemoteAuthentication {
  HttpClient httpClient;
  String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    await this.httpClient.request(
          url: url,
          method: 'post',
          body: body,
        );
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({required this.email, required this.password});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(email: params.email, password: params.secret);

  Map toJson() {
    return {'email': email, 'password': password};
  }
}
