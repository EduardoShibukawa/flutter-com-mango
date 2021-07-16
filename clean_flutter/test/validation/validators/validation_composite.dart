import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/presentation/presents/protocols/protocols.dart';
import 'package:clean_flutter/validation/protocols/protocols.dart';

class FieldValidationSpy extends Mock implements FIeldValidation {}

void main() {
  late ValidationComposite sut;
  late FIeldValidation validation1;
  late FIeldValidation validation2;
  late FIeldValidation validation3;

  mockValidation1(String error) {
    when(() => validation1.field).thenReturn('');
  }

  mockValidation2(String error) {
    when(() => validation2.field).thenReturn('');
  }

  mockValidation3(String error) {
    when(() => validation3.field).thenReturn('');
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    validation2 = FieldValidationSpy();
    validation3 = FieldValidationSpy();
    sut = ValidationComposite([validation1, validation2, validation3]);

    when(() => validation1.field).thenReturn('any_field');
    when(() => validation2.field).thenReturn('any_field');
    when(() => validation3.field).thenReturn('other_field');
    mockValidation1('');
    mockValidation2('');
    mockValidation3('');
  });

  test('Should return empty if all validations return empty', () {
    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, '');
  });

  test('Should return the first error', () {
    mockValidation1('error_1');
    mockValidation2('error_2');
    mockValidation3('error_3');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, 'error_1');
  });
}

class ValidationComposite implements Validation {
  final List<FIeldValidation> validations;

  ValidationComposite(this.validations);

  String validate({required String field, required String value}) {
    for (final v in validations) {
      final error = v.validate(value);

      if (error.isNotEmpty) {
        return error;
      }
    }

    return '';
  }
}
