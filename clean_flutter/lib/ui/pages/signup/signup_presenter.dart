import '../pages.dart';
import '../../helpers/errors/errors.dart';

abstract class SignUpPresenter extends Presenter {
  Stream<UIError?> get nameErrorStream;
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<UIError?> get passwordConfirmationErrorStream;
  Stream<UIError?> get mainErrorStream;

  Stream<String> get navigateToStream;

  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateName(String name);
  void validateEmail(String email);
  void validatePassword(String password);
  void validatePasswordConfirmation(String password);

  Future<void> signUp();
  void goToLogin();
}
