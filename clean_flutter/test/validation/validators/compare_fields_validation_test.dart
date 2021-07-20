import 'package:test/test.dart';

import 'package:clean_flutter/presentation/presenters/protocols/validation.dart';
import 'package:clean_flutter/validation/valdation.dart';

void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', valueToCompare: 'any_value');
  });
  test('Should return error if values are not equal', () {
    expect(sut.validate('wrong_value'), ValidationError.invalidField);
  });

  test('Should return null if values are equal', () {
    expect(sut.validate('wrong_value'), ValidationError.invalidField);
  });
}
