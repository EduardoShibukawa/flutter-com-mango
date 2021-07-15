import '../protocols/protocols.dart';

class RequiredFieldValidation implements FIeldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String validate(String? value) {
    return value?.isNotEmpty == true ? '' : 'Campo obrigatório!';
  }
}
