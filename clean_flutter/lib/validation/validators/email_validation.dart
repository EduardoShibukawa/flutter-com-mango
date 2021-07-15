import 'package:clean_flutter/validation/protocols/protocols.dart';

class EmailValidation implements FIeldValidation {
  final String field;

  EmailValidation(this.field);

  String validate(String? value) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (value?.isNotEmpty == true && !regex.hasMatch(value!)) {
      return 'Campo inválido!';
    }

    return '';
  }
}
