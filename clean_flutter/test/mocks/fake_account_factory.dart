import 'package:clean_flutter/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAccountEntity extends Fake implements AccountEntity {}

class FakeAccountFactory {
  static Map makeApiJson() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  static AccountEntity makeEntity() => AccountEntity(faker.guid.guid());

  static AccountEntity makeEntityWithoutToken() => AccountEntity('');
}
