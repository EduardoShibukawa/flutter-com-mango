import 'package:flutter/material.dart';

import 'package:clean_flutter/ui/pages/login_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black
        /* dark theme settings */
      ),
      title: '4Dev',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
