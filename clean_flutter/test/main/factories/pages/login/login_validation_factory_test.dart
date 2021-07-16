import 'dart:math';

import 'package:clean_flutter/main/factories/factories.dart';
import 'package:clean_flutter/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  test('should return the correct validations', () {
    final validations = makeLoginValidations();

    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password')
    ]);
  });
}
