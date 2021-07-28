import 'package:clean_flutter/ui/mixins/mixins.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash.dart';

class SplashPage extends StatelessWidget with NavigationManager {
  final SplashPresenter presenter;

  SplashPage({required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();

    return Scaffold(
      appBar: AppBar(
        title: Text('4Dev'),
      ),
      body: Builder(builder: (context) {
        handleNavigation(presenter.navigateToStream, clear: true);

        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
