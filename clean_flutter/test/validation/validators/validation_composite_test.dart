import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/presentation/presenters/presenters.dart';

import 'package:clean_flutter/validation/protocols/protocols.dart';
import 'package:clean_flutter/validation/validators/validators.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  late ValidationComposite sut;
  late FieldValidation validation1;
  late FieldValidation validation2;
  late FieldValidation validation3;

  mockValidation1(ValidationError? error) {
    when(() => validation1.validate(any())).thenReturn(error);
  }

  mockValidation2(ValidationError? error) {
    when(() => validation2.validate(any())).thenReturn(error);
  }

  mockValidation3(ValidationError? error) {
    when(() => validation3.validate(any())).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    validation2 = FieldValidationSpy();
    validation3 = FieldValidationSpy();
    sut = ValidationComposite([validation1, validation2, validation3]);

    when(() => validation1.field).thenReturn('other_field');
    when(() => validation2.field).thenReturn('any_field');
    when(() => validation3.field).thenReturn('any_field');
    mockValidation1(null);
    mockValidation2(null);
    mockValidation3(null);
  });

  test('Should return null if all validations return null', () {
    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });

  test('Should return the first error found', () {
    mockValidation1(ValidationError.requiredField);
    mockValidation2(ValidationError.requiredField);
    mockValidation3(ValidationError.invalidField);

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, ValidationError.requiredField);
  });
}
