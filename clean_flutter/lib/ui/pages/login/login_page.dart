import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            isLoading ? showLoading(context) : hideLoading(context);
          });

          presenter.mainErrorStream.listen((error) {
            showErrorMessage(context, error);
          });

          presenter.navigateToStream.listen((page) {
            if (page.isNotEmpty) {
              Get.offAllNamed(page);
            }
          });

          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  HeadLine1(text: 'Login'),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Provider<LoginPresenter>(
                      create: (_) => presenter,
                      child: Form(
                        child: Column(
                          children: [
                            EmailInput(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 32.0),
                              child: PasswordInput(),
                            ),
                            LoginButton(),
                            TextButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.person),
                              label: Text('Criar Conta'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
