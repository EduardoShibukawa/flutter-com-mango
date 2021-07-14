import 'package:clean_flutter/domain/entities/account_entity.dart';

class RemoteAccountModel  {
  final String token;

  RemoteAccountModel (this.token);

  factory RemoteAccountModel .fromJson(Map json) =>
      RemoteAccountModel (json['accessToken']);

  AccountEntity toEntity() => AccountEntity(token);    
}
