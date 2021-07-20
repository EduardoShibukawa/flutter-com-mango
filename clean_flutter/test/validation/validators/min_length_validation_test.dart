import 'package:clean_flutter/presentation/presenters/protocols/validation.dart';
import 'package:clean_flutter/validation/protocols/field_validation.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

void main() {
  late MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 5);
  });
  test('Should return error if value is empty', () {
    expect(sut.validate(''), ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationError.invalidField);
  });

  test('Should return error if value is less than min size', () {
    expect(
        sut.validate(
          faker.randomGenerator.string(4, min: 1),
        ),
        ValidationError.invalidField);
  });

  test('Should return null if value is equal than min size', () {
    expect(sut.validate(faker.randomGenerator.string(5, min: 5)), null);
  });
}

class MinLengthValidation implements FieldValidation {
  final String field;
  final int size;

  MinLengthValidation({required this.field, required this.size});

  ValidationError? validate(String? value) {
    return value?.length == size ? null : ValidationError.invalidField;
  }
}
