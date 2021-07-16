import '../../factories.dart';
import '../../../../presentation/presents/presents.dart';
import '../../../../ui/pages/pages.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
  );
}
