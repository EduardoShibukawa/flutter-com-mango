import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/presentation/presents/protocols/protocols.dart';
import 'package:clean_flutter/validation/protocols/protocols.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  late ValidationComposite sut;
  late FieldValidation validation1;
  late FieldValidation validation2;
  late FieldValidation validation3;

  mockValidation1(String error) {
    when(() => validation1.validate(any())).thenReturn(error);
  }

  mockValidation2(String error) {
    when(() => validation2.validate(any())).thenReturn(error);
  }

  mockValidation3(String error) {
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
    mockValidation1('');
    mockValidation2('');
    mockValidation3('');
  });

  test('Should return empty if all validations return empty', () {
    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, '');
  });

  test('Should return the first error found', () {
    mockValidation1('error_1');
    mockValidation2('error_2');
    mockValidation3('error_3');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, 'error_2');
  });
}

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  String validate({required String field, required String value}) {
    for (final v in validations.where((v) => v.field == field)) {
      print(value);
      final error = v.validate(value);
      print(v.field);
      print(v);
      print(error);

      if (error.isNotEmpty) {
        return error;
      }
    }

    return '';
  }
}
