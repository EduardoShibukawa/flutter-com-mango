import 'package:clean_flutter/presentation/presenters/presenters.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/validation/validators/validators.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('should return null if value is not empty', () {
    final formData = {'any_field': 'any_value'};

    expect(sut.validate(formData), null);
  });

  test('should return error if value is empty', () {
    final formData = {'any_field': ''};

    expect(sut.validate(formData), ValidationError.requiredField);
  });

  test('should return error if value is null', () {
    final formData = {'any_field': null};

    expect(sut.validate(formData), ValidationError.requiredField);
  });
}
