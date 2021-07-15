import 'package:clean_flutter/validation/validators/protocols/protocols.dart';
import 'package:test/test.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return blank if email is empty', () {
    expect(sut.validate(''), '');
  });

  test('Should return blank if email is empty', () {
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
