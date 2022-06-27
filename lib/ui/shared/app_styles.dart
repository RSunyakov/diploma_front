import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'app_colors.dart';

class AppStyles {
  static const _heightText = 1.0;
  static const font = 'Netflix';

  static const textLogo = TextStyle(
    fontSize: 32,
    fontFamily: font,
    fontWeight: FontWeight.w900,
  );

  static const text9 = TextStyle(
    fontSize: 9,
    height: _heightText,
    fontFamily: font,
    color: AppColors.plainText,
  );
  static const text10 = TextStyle(
    fontSize: 10,
    height: _heightText,
    fontFamily: font,
    color: AppColors.plainText,
  );

  static const text11 = TextStyle(
    fontSize: 11,
    height: _heightText,
    fontFamily: font,
    color: AppColors.plainText,
  );

  static const text12 = TextStyle(
    fontSize: 12,
    height: _heightText,
    fontFamily: font,
    color: AppColors.black,
  );

  static const text13 = TextStyle(
    fontSize: 13,
    height: _heightText,
    fontFamily: font,
    color: AppColors.plainText,
  );

  static const text14 = TextStyle(
    fontSize: 14,
    height: _heightText,
    fontFamily: font,
    color: AppColors.black,
  );

  static const text15 = TextStyle(
    fontSize: 15,
    height: _heightText,
    fontFamily: font,
    color: AppColors.plainText,
  );

  static const text16 = TextStyle(
    fontSize: 16,
    height: _heightText,
    fontFamily: font,
    color: AppColors.plainText,
  );

  static const text17 = TextStyle(
    fontSize: 17,
    height: _heightText,
    fontFamily: font,
    color: AppColors.plainText,
  );

  static const text18 = TextStyle(
    fontSize: 18,
    height: _heightText,
    fontFamily: font,
    color: AppColors.plainText,
  );

  static const text20 = TextStyle(
    fontSize: 20,
    height: _heightText,
    fontFamily: font,
    color: AppColors.plainText,
  );

  static const text22 = TextStyle(
    fontSize: 22,
    height: _heightText,
    fontFamily: font,
    color: AppColors.plainText,
  );

  static const text24 = TextStyle(
    fontSize: 24,
    height: _heightText,
    fontFamily: font,
    color: AppColors.plainText,
  );

  static const text25 = TextStyle(
    fontSize: 25,
    height: _heightText,
    fontFamily: font,
    color: AppColors.plainText,
  );

  /// Семантический класс для лейблов TextField
  static const textFieldLabel = TextStyle(
    fontSize: 12,
    height: _heightText,
    fontFamily: font,
    fontWeight: FontWeight.bold,
    color: AppColors.plainText,
  );
}

extension TextStyleX on TextStyle {
  TextStyle andSize(double size) => copyWith(fontSize: size);

  TextStyle andWeight(FontWeight weight) => copyWith(fontWeight: weight);

  TextStyle andHeight(double height) => copyWith(height: height);

  TextStyle andColor(Color color) => copyWith(color: color);

  TextStyle andUnderline() => copyWith(decoration: TextDecoration.underline);
}
