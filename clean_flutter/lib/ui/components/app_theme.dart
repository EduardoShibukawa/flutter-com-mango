import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData makeAppTheme() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  final primaryColor = Color.fromRGBO(136, 14, 79, 1);
  final primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  final primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
  final secondaryColorDark = Color.fromRGBO(0, 37, 26, 1);
  final secondaryColor = Color.fromRGBO(0, 77, 64, 1);
  final disableColor = Colors.grey[400];
  final dividersColor = Colors.grey;

  return ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      highlightColor: secondaryColor,
      secondaryHeaderColor: secondaryColorDark,
      disabledColor: disableColor,
      dividerColor: dividersColor,
      accentColor: primaryColor,
      backgroundColor: Colors.white,
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: primaryColorDark,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColorLight),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColorDark),
          ),
          alignLabelWithHint: true),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.light(primary: primaryColor),
        buttonColor: primaryColor,
        splashColor: primaryColorLight,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          shadowColor: primaryColorDark,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: primaryColor,
          shadowColor: primaryColorDark,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ));
}
