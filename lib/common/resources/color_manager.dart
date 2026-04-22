import 'package:flutter/material.dart';

class ColorManager {
  ColorManager._();
  static const Color primary = Color(0xff043180);
  static const Color primaryLight = Color(0xffDDDEFB);
  static const Color green = Color(0xff008000);
  static const Color successGreen = Color(0xff00ce21);
  static const Color blue = Color(0xff010B38);
  static const Color primaryGradientStart = Color(0xff043180);
  static const Color primaryGradientEnd = Color(0xff0081E9);

  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const Color lightBlue = Color(0xff4E74F9);
  static const Color lightBlueSky = Color(0xff85C8F8);
  static const Color textColor = Color(0xff202244);
  static const Color lightColor = Color(0xffD5E2F5); // onboarding dots
  static const Color hintTextColor = Color(0xffB7B7B7);
  static Color greyTextColor = blue.withValues(alpha: .6);
  // static const Color greyTextColor = Color(0xff7C7C7C);
  static const Color lightGreyTextColor = Color(0xffC7C7C7);
  static const Color lightGreyTextColor2 = Color(0xffB4B4B4);
  static const Color lightGrey = Color(0xffDCDCDE); // banner dots
  static const Color lightGrey2 = Color(0xffE1E0E3); // home-> start with trevo
  static const Color bg = Color(0xffF3F4F5);
  static const Color white = Color(0xffffffff);
  static Color black = Color(0xff000000).withValues(alpha: .7);
  static const Color lightBlackText = Color(0xff52525B);
  static Color blackText = Color(0xff030303).withValues(alpha: .7);
  static const Color red = Color(0xffE90000);
  static const Color grey = Color(0xff999DAF);
  static const Color greyButtonColor = Color(0xffD9D9D9);
  static const Color shimmerBaseColor = Color(0xfff2f4f5);
  static const Color shimmerHighlightColor = Color(0xffffffff);
  static const Color greyBorder = Color(0xffE1E2E5);
  // static const Color greyBorder = Color(0xffd5dae1);
  static const Color fillColor = Color(0xffF7F8F9);
  static const Color yellow = Color(0xffF4B400);
  static const Color azureBlue = Color(0xff386BF6);
  static const Color grey2 = Color(0xffB8B8B8);
  static const List<Color> gradientPrimary = [
    Color(0xff2563EB),
    Color(0xff1A4DBF),
  ];
  static const Color dividerColor = Color(0xffd8d8d8);
  static const Color greyText = Color(0xff717579);
}
