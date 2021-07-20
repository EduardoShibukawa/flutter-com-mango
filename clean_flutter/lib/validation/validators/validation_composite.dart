import '../protocols/protocols.dart';
import '../../presentation/presenters/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  ValidationError? validate({required String field, required Map input}) {
    for (final v in validations.where((v) => v.field == field)) {
      final error = v.validate(input);

      if (error != null) {
        return error;
      }
    }

    return null;
  }
}
