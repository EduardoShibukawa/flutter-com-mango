import 'package:clean_flutter/data/http/http.dart';

import '../../models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteAuthentication implements Authentication {
  HttpClient<Map> httpClient;
  String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<AccountEntity> auth({required AuthenticationParams params}) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      final httpResponse = await this.httpClient.request(
            url: url,
            method: 'post',
            body: body,
          );

      return RemoteAccountModel.fromJson(httpResponse).toEntity();
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
