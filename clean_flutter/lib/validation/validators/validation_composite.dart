import '../protocols/protocols.dart';
import '../../presentation/presenters/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  ValidationError? validate({required String field, required String value}) {
    for (final v in validations.where((v) => v.field == field)) {
      final error = v.validate(value);

      if (error != null) {
        return error;
      }
    }

    return null;
  }
}
