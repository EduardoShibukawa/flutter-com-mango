import 'package:equatable/equatable.dart';

import '../../presentation/presenters/presenters.dart';
import '../protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  final String field;
  final String fieldToCompare;

  List<Object> get props => [field, fieldToCompare];

  CompareFieldsValidation({required this.field, required this.fieldToCompare});

  ValidationError? validate(Map input) {
    if (input[field] == null || input[fieldToCompare] == null) {
      return null;
    }

    return input[field] == input[fieldToCompare]
        ? null
        : ValidationError.invalidField;
  }
}
