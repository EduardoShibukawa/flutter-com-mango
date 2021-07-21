import 'package:http/http.dart';

import '../../../infra/http/http.dart';
import '../../../data/http/http.dart';

HttpClient<ResponseType> makeHttpAdapter<ResponseType>() {
  return HttpAdapter<ResponseType>(Client());
}
