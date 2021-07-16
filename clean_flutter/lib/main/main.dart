import 'package:clean_flutter/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import 'factories/factories.dart';
import '../ui/components/components.dart';

void main() {
  // Getx Provider bug
  final previousCheck = Provider.debugCheckInvalidValueType;
  Provider.debugCheckInvalidValueType = <T>(T value) {
    if (value is LoginPresenter) return;
    previousCheck!<T>(value);
  };

  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '4Dev',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: makeLoginPage,
        ),
        GetPage(
          name: '/surveys',
          page: () => Scaffold(
            body: Text('Enquetes'),
          ),
        )
      ],
    );
  }
}
