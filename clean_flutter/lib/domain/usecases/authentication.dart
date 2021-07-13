import 'package:meta/meta.dart';

import 'package:clean_flutter/domain/entities/account_entity.dart';

abstract class Authentication {
  Future<AccountEntity> auth({
    @required String email,
    @required String password
  });
}
