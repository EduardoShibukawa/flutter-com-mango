import '../../validation/protocols/field_validation.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  late String fieldName;
  List<FieldValidation> validations = [];

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

  ValidationBuilder min(int size) {
    this.validations.add(MinLengthValidation(field: fieldName, size: size));

    return this;
  }

  ValidationBuilder sameAs(String fieldToCompare) {
    validations.add(CompareFieldsValidation(
      field: fieldName,
      fieldToCompare: fieldToCompare,
    ));

    return this;
  }

  List<FieldValidation> build() => validations;
}
