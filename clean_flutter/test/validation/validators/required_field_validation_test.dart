import 'package:clean_flutter/presentation/presenters/presenters.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/validation/validators/validators.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('should return null if value is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  test('should return error if value is empty', () {
    expect(sut.validate(''), ValidationError.requiredField);
  });

  test('should return error if value is null', () {
    expect(sut.validate(null), ValidationError.requiredField);
  });
}
