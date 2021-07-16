import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'factories/factories.dart';
import '../ui/components/components.dart';

void main() {
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
        )
      ],
    );
  }
}
