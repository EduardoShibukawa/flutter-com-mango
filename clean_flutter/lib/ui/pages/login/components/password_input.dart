import 'package:clean_flutter/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter?>(context);

    return StreamBuilder<String>(
        stream: presenter!.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: 'Senha',
              icon: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColorLight,
              ),
              errorText:
                  snapshot.data?.isNotEmpty == true ? snapshot.data : null,
            ),
            obscureText: true,
            onChanged: presenter.validatePassword,
          );
        });
  }
}
