import 'package:clean_flutter/ui/pages/login/login_presenter.dart';
import 'package:clean_flutter/ui/pages/pages.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter? presenter;

  LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginHeader(),
            HeadLine1(text: 'Login'),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: [
                    StreamBuilder<String>(
                        stream: presenter!.emailErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.email,
                                  color: Theme.of(context).primaryColorLight),
                              errorText: snapshot.data?.isNotEmpty == true
                                  ? snapshot.data
                                  : null,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: presenter!.validateEmail,
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                      child: StreamBuilder<String>(
                          stream: presenter!.passwordErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                icon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                errorText: snapshot.data?.isNotEmpty == true
                                    ? snapshot.data
                                    : null,
                              ),
                              obscureText: true,
                              onChanged: presenter!.validatePassword,
                            );
                          }),
                    ),
                    ElevatedButton(
                      onPressed: null,
                      child: Text('Entrar'.toUpperCase()),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.person),
                      label: Text('Criar Conta'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
