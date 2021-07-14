import 'package:clean_flutter/data/http/http.dart';

import 'package:clean_flutter/domain/entities/account_entity.dart';
import 'package:clean_flutter/domain/helpers/domain_error.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';

class RemoteAuthentication {
  HttpClient httpClient;
  String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      final httpResponse = await this.httpClient.request(
            url: url,
            method: 'post',
            body: body,
          );
      
      return AccountEntity.fromJson(httpResponse);
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentialsError
          : DomainError.unexpected;
    }
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
