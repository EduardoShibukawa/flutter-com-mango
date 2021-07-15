import 'package:test/test.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('should return empty error if value is not empty', () {
    expect(sut.validate('any_value'), '');
  });

  test('should return error if value is empty', () {
    expect(sut.validate(''), 'Campo obrigatório!');
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
