import 'package:clean_flutter/presentation/presenters/presenters.dart';
import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  List<Object?> get props => [field];

  RequiredFieldValidation(this.field);

  ValidationError? validate(Map input) {
    final value = input[field];

    return value?.isNotEmpty == true ? null : ValidationError.requiredField;
  }
}
