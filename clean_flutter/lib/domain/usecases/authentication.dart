import 'package:meta/meta.dart';

import 'package:clean_flutter/domain/entities/account_entity.dart';

abstract class Authentication {
  Future<AccountEntity> auth({
    required AuthenticationParams params
  });
}

class AuthenticationParams {
  final String email;
  final String secret;

  AuthenticationParams({
    required this.email,
    required this.secret
  });
}