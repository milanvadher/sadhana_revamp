// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._(this.name, this.data);

  final String name;
  final ThemeData data;
}

final AppTheme kDarkAppTheme = AppTheme._('Dark', _buildDarkTheme());
final AppTheme kLightAppTheme = AppTheme._('Light', _buildLightTheme());

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        title: base.title.copyWith(
          fontFamily: 'GoogleSans',
        ),
      )
      .apply(fontFamily: 'GoogleSans');
}

ThemeData _buildDarkTheme() {
//  const Color primaryColor = Color(0xFF0175c2);
//  const Color secondaryColor = Color(0xFF13B9FD);
  const Color primaryColor = Color(0xFF9D0C0E);
  const Color secondaryColor = Color(0xFFce0e11);
  final ThemeData base = ThemeData.dark();
  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  return base.copyWith(
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    accentColor: secondaryColor,
    canvasColor: const Color(0xFF202124),
    scaffoldBackgroundColor: const Color(0xFF24252B),
    backgroundColor: const Color(0xFF202124),
    errorColor: const Color(0xFFB00020),
    cardColor: const Color(0xFF1A1E1E),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

ThemeData _buildLightTheme() {
//  const Color primaryColor = Color(0xFF0175c2);
//  const Color secondaryColor = Color(0xFF13B9FD);
  const Color primaryColor = Color(0xFF9D0C0E);
  const Color secondaryColor = Color(0xFFce0e11);
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: colorScheme,
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    splashColor: Colors.white24,
    splashFactory: InkRipple.splashFactory,
    accentColor: secondaryColor,
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}
