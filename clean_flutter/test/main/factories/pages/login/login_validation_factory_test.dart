import 'package:test/test.dart';

import 'package:clean_flutter/validation/validators/validators.dart';
import 'package:clean_flutter/main/factories/factories.dart';

void main() {
  test('should return the correct validations', () {
    final validations = makeLoginValidations();

    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', size: 3)
    ]);
  });
}
