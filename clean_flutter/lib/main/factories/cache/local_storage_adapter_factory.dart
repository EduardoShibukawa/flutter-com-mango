import 'package:localstorage/localstorage.dart';

import '../../../infra/cache/local_storage_adapter.dart';

LocalStorageAdapter makeLocalStorageAdapter() {
  return LocalStorageAdapter(localStorage: LocalStorage('cleanflutter'));
}
