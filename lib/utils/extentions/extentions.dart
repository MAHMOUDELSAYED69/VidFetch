import 'package:flutter/material.dart';

//! THEME EXTENSION
extension ThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  IconThemeData get iconTheme => Theme.of(this).iconTheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  AppBarTheme get appBarTheme => Theme.of(this).appBarTheme;
  InputDecorationTheme get inputDecoration =>
      Theme.of(this).inputDecorationTheme;
  CheckboxThemeData get checkboxTheme => Theme.of(this).checkboxTheme;
  ElevatedButtonThemeData get elevatedButtonTheme =>
      Theme.of(this).elevatedButtonTheme;
  OutlinedButtonThemeData get outlinedButtonTheme =>
      Theme.of(this).outlinedButtonTheme;
}

//! SCREEN EXTENSION
extension MediaQueryExtensions on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
}

//! ITERABLE EXTENSION
extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
