import '../../../../presentation/presenters/protocols/protocols.dart';
import '../../../../validation/valdation.dart';
import '../../../builders/validation_builder.dart';
import '../../../composites/composites.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
  ];
}
