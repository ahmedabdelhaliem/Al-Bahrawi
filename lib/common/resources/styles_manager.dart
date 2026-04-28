import 'package:al_bahrawi/common/resources/font_manager.dart';
import 'package:flutter/material.dart';

TextStyle _getTextStyle(
  double fontSize,
  FontWeight fontWeight,
  Color color,
  double? height,
  TextDecoration? decoration,
  double? letterSpacing,
) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    height: height,
    decoration: decoration,
    letterSpacing: letterSpacing,
  );
}

// light style

TextStyle getLightStyle({
  required double fontSize,
  required Color color,
  double? height,
  TextDecoration? decoration,
  double? letterSpacing,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.light,
    color,
    height,
    decoration,
    letterSpacing,
  );
}

// regular style

TextStyle getRegularStyle({
  required double fontSize,
  required Color color,
  double? height,
  TextDecoration? decoration,
  double? letterSpacing,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.regular,
    color,
    height,
    decoration,
    letterSpacing,
  );
}

// medium style

TextStyle getMediumStyle({
  required double fontSize,
  required Color color,
  double? height,
  TextDecoration? decoration,
  double? letterSpacing,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.medium,
    color,
    height,
    decoration,
    letterSpacing,
  );
}

// semi bold style

TextStyle getSemiBoldStyle({
  required double fontSize,
  required Color color,
  double? height,
  TextDecoration? decoration,
  double? letterSpacing,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.semiBold,
    color,
    height,
    decoration,
    letterSpacing,
  );
}

// bold style

TextStyle getBoldStyle({
  required double fontSize,
  required Color color,
  double? height,
  TextDecoration? decoration,
  double? letterSpacing,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.bold,
    color,
    height,
    decoration,
    letterSpacing,
  );
}
