import 'package:test/test.dart';

void main() {
  test('should return empty error if value is not empty', () {
    final sut = RequiredFieldValidation('any_field');

    final error = sut.validate('any_value');

    expect(error, '');
  });

  test('should return error if value is empty', () {
    final sut = RequiredFieldValidation('any_field');

    final error = sut.validate('');

    expect(error, 'Campo obrigatório!');
  });
}

abstract class FIeldValidation {
  String get field;
  String validate(String value);
}

class RequiredFieldValidation implements FIeldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String validate(String value) {
    return value.isEmpty ? 'Campo obrigatório!' : '';
  }
}
