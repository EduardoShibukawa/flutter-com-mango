import '../../factories.dart';
import '../../../../ui/pages/pages.dart';

LoginPage makeLoginPage() {
  return LoginPage(makeGetxLoginPresenter());
}
