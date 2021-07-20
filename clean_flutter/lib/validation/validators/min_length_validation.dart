import 'package:equatable/equatable.dart';

import '../../presentation/presenters/presenters.dart';
import '../protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int size;

  List<Object?> get props => [field, size];

  MinLengthValidation({required this.field, required this.size});

  ValidationError? validate(Map input) {
    final value = input[field];
    return value != null && value.length >= size
        ? null
        : ValidationError.invalidField;
  }
}
