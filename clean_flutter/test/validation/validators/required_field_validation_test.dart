import 'package:test/test.dart';

import 'package:clean_flutter/validation/validators/validators.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('should return empty error if value is not empty', () {
    expect(sut.validate('any_value'), '');
  });

  test('should return error if value is empty', () {
    expect(sut.validate(''), 'Campo obrigatório!');
  });

  test('should return error if value is null', () {
    expect(sut.validate(null), 'Campo obrigatório!');
  });
}
