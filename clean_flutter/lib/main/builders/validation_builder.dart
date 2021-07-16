import '../../validation/protocols/field_validation.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  late String fieldName;
  List<FieldValidation> validations = [];

  ValidationBuilder() {
    throw Exception('public constructor not allowed for builders');
  }

  ValidationBuilder._(this.fieldName);

  static ValidationBuilder field(String fieldName) {
    return ValidationBuilder._(fieldName);
  }

  ValidationBuilder required() {
    this.validations.add(RequiredFieldValidation(fieldName));

    return this;
  }

  ValidationBuilder email() {
    this.validations.add(EmailValidation(fieldName));

    return this;
  }

  List<FieldValidation> build() => validations;
}
