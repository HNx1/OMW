import 'package:flutter/material.dart';
import 'package:omw/utils/colorUtils.dart';

import 'constants.dart';

class AppTheme {
  static bool islight = false;

  static ThemeData getTheme() {
    if (islight) {
      return lightTheme();
    } else {
      return darkTheme();
    }
  }

  static TextTheme buildTextTheme(TextTheme base) {
    return base.copyWith(
      bodyText1: TextStyle(
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w400,
          fontFamily: "CORBEL",
          color: ConstColor.black_Color),
      bodyText2: TextStyle(
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w700,
          fontFamily: "Corbel",
          color: ConstColor.black_Color),
      subtitle1: TextStyle(
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w400,
          fontFamily: "Aharoni",
          color: ConstColor.black_Color),
    );
  }

  static ThemeData lightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      appBarTheme: AppBarTheme(color: Colors.white),
      popupMenuTheme: PopupMenuThemeData(color: Colors.white),
      iconTheme: IconThemeData(color: Color(0xff2b2b2b)),
      primaryColor: primaryColor,
      splashColor: Colors.white.withOpacity(0.1),
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Color(0xffffffff),
      backgroundColor: Colors.white,
      errorColor: Colors.red,
      textTheme: buildTextTheme(base.textTheme),
      primaryTextTheme: buildTextTheme(base.textTheme),
      platform: TargetPlatform.android,
      indicatorColor: primaryColor,
    );
  }

  static ThemeData darkTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      appBarTheme: AppBarTheme(color: Colors.grey[700]),
      popupMenuTheme: PopupMenuThemeData(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.white),
      primaryColor: primaryColor,
      splashColor: Colors.white24,
      canvasColor: Colors.grey[900],
      scaffoldBackgroundColor: ConstColor.black_Color,
      backgroundColor: ConstColor.black_Color,
      errorColor: Colors.red,
      textTheme: buildTextTheme(base.textTheme),
      primaryTextTheme: buildTextTheme(base.primaryTextTheme),
      platform: TargetPlatform.android,
      indicatorColor: primaryColor,
    );
  }
}
