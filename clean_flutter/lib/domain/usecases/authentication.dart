import 'package:equatable/equatable.dart';

import '../entities/account_entity.dart';

abstract class Authentication {
  Future<AccountEntity> auth({required AuthenticationParams params});
}

class AuthenticationParams extends Equatable {
  final String email;
  final String secret;

  AuthenticationParams({required this.email, required this.secret});

  @override
  List<Object> get props => [email, secret];

  @override
  bool get stringify => true;
}
