import 'package:clean_flutter/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'factories/factories.dart';

import '../ui/pages/pages.dart';

import '../ui/components/components.dart';

void main() {
  // Getx Provider bug
  final previousCheck = Provider.debugCheckInvalidValueType;
  Provider.debugCheckInvalidValueType = <T>(T value) {
    if (value is Presenter) return;
    previousCheck!<T>(value);
  };

  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting(R.locale.toString(), null);

    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

    return GetMaterialApp(
      title: '4Dev',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      navigatorObservers: [routeObserver],
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: makeSplashPage,
          transition: Transition.fade,
        ),
        GetPage(
          name: '/login',
          page: makeLoginPage,
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/signup',
          page: makeSignUpPage,
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/surveys',
          page: makeSurveyPage,
          transition: Transition.fadeIn,
        ),
        GetPage(name: '/survey_result/:survey_id', page: makeSurveyResultPage)
      ],
    );
  }
}
