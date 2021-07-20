import 'package:clean_flutter/presentation/presenters/presenters.dart';
import 'package:clean_flutter/validation/protocols/protocols.dart';
import 'package:equatable/equatable.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String field;

  List<Object?> get props => [field];

  EmailValidation(this.field);

  ValidationError? validate(Map input) {
    final value = input[field];
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (value?.isNotEmpty == true && !regex.hasMatch(value!)) {
      return ValidationError.invalidField;
    }

    return null;
  }
}
