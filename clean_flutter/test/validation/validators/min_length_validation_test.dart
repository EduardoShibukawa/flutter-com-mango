import 'package:clean_flutter/presentation/presenters/protocols/validation.dart';
import 'package:clean_flutter/validation/protocols/field_validation.dart';
import 'package:test/test.dart';

void main() {
  test('Should return error if value is empty', () {
    final sut = MinLengthValidation(field: 'any_field', size: 5);
    final error = sut.validate('');

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    final sut = MinLengthValidation(field: 'any_field', size: 5);
    final error = sut.validate(null);

    expect(error, ValidationError.invalidField);
  });
}

class MinLengthValidation implements FieldValidation {
  final String field;
  final int size;

  MinLengthValidation({required this.field, required this.size});

  ValidationError? validate(String? value) {
    return ValidationError.invalidField;
  }
}
