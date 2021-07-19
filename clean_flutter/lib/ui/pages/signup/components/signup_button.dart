import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(R.strings.addAccount.toUpperCase()),
      onPressed: null,
    );
  }
}
