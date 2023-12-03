import 'package:flutter/material.dart';

extension ThemeDataX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  NavigatorState get navigator => Navigator.of(this);
}
