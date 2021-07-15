import 'package:clean_flutter/validation/validators/protocols/protocols.dart';
import 'package:test/test.dart';

void main() {
  test('Should return blank if email is empty', () {
    final sut = EmailValidation('any_field');

    expect(sut.validate(''), '');
  });

  test('Should return blank if email is empty', () {
    final sut = EmailValidation('any_field');

    expect(sut.validate(null), '');
  });
}

class EmailValidation implements FIeldValidation {
  final String field;

  EmailValidation(this.field);

  String validate(String? value) {
    return '';
  }
}
