import 'package:clean_flutter/data/http/http.dart';

import '../../models/models.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteAddAccount implements AddAccount {
  HttpClient httpClient;
  String url;

  RemoteAddAccount({required this.httpClient, required this.url});

  Future<AccountEntity> add({required AddAccountParams params}) async {
    final body = RemoteAddAccountParams.fromDomain(params).toJson();
    try {
      final httpResponse = await this.httpClient.request(
            url: url,
            method: 'post',
            body: body,
          );

      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.emailInUse
          : DomainError.unexpected;
    }
    return Future.value(AccountEntity(''));
  }
}

class RemoteAddAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RemoteAddAccountParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory RemoteAddAccountParams.fromDomain(AddAccountParams params) =>
      RemoteAddAccountParams(
        name: params.name,
        email: params.email,
        password: params.password,
        passwordConfirmation: params.passwordConfirmation,
      );

  Map toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'passwordConfirmation': passwordConfirmation
    };
  }
}
