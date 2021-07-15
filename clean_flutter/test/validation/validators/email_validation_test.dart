import 'package:clean_flutter/validation/validators/validators.dart';
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

  test('Should return blank if email is valid', () {
    expect(sut.validate('eduardoshibuka@gmail.com'), '');
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('eduardoshibuka@gmail'), 'Campo inválido!');
  });
}
