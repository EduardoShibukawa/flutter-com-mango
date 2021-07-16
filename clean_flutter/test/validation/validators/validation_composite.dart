import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/presentation/presents/protocols/protocols.dart';
import 'package:clean_flutter/validation/protocols/protocols.dart';

class FieldValidationSpy extends Mock implements FIeldValidation {};
void main() {
  test('Should return empty if all validations return empty', () {
    final validationEmpty = FieldValidationSpy();
    final sut = ValidationComposite([validationEmpty]);

    when(() => validationEmpty.field).thenReturn('any_field');
    when(() => validationEmpty.field).thenReturn('');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, '');
  });
}

class ValidationComposite implements Validation {
  final List<FIeldValidation> validations;

  ValidationComposite(this.validations);

  String validate({required String field, required String value}) {
    return '';
  }
}
