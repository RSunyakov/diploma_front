import 'package:flutter/material.dart';

class AppColors {
  // семантика

  static const MaterialColor primary = MaterialColor(
    0xfffee8e6,
    <int, Color>{
      50: Color(0xff93DCDF),
      100: Color(0xff93DCDF),
      200: Color(0xff93DCDF),
      300: Color(0xff93DCDF),
      400: Color(0xff93DCDF),
      500: Color(0xff93DCDF),
      600: Color(0xff93DCDF),
      700: Color(0xff93DCDF),
      800: Color(0xff93DCDF),
      900: Color(0xff93DCDF),
    },
  );

  static const mainBG = Color(0xffFAF9FF);
  static const gradientTop = Color(0xff93DCDF);
  static const gradientBottom = Color(0xff78CDA8);
  static const textColor = Color(0xff808191);
  static const shadowColor = Color(0xff7acdac);
  static const goalDeadline = Color(0xFFFF3838);
  static const goalDeadlineShadow = Color(0x33ff4747);
  static const goalDone = Color(0xFFFFDF60);
  static const goalPaused = Color(0x66c4c4c4);
  static const shadowWrongColor = Color(0xffff4747);
  static const mainColor = Color(0xff7BCEAD);
  static const mainBk = Color(0xffF6F6F6);
  static const mainStroke = Color(0xffb7b6b6);
  static const infoBody = Color(0xffFBFBFF);
  static const lightGreyText = Color(0xffb7b6b6);
  static const plainText = Color(0xff696969);
  static const activeText = Color(0xff7ACDAC);
  static const branded = Color(0xff7ACDAC);
  static const inboxMessageContainer = Color(0xfff1eeff);
  static const buttonGreen = Color(0xff7acdac);
  static const textBlack = Color(0xff363636);
  static const textGreen = Color(0xff79ccb9);
  static const firstCircularGradientColor = Color(0xff91dbda);
  static const secondCircularGradientColor = Color(0xff7bceac);
  static const invisible = Color(0x00000000);
  static const link = Color(0xff4BA89D);
  static const lightGrey = Color(0xffc4c4c4);
  static const globalSearchText = Color(0xff707070);
  static const dividerColor = Color(0xffECECEC);
  static const deafGrey = Color(0xff707070);
  static const semiPurple = Color(0xffF2F0FD);
  static const subtaskBackground = Color(0x66516d73);

  // ~семантика

  // просто цвета
  static const black = Color(0xff000000);
  static const white = Color(0xffffffff);
  static const grey = Color(0xff242b33);
  static const red = Color(0xfff91a07);
  static const whiteGrey = Color(0xffe7e8ea);
  static const backgroundDirtyWhite = Color(0xfffaf9ff);
  static const lightGrey2 = Color(0xffc4c4c4);
  static const semiGrey = Color(0xff74859f);
  static const opacity = 0.3;

  //slider
  static const trackBar = Color(0xfffaf9ff);
  static const innerHandler = Color(0xff696969);
  static const tooltipBg = Color(0xff7BCEAD);

  /// Стандартная тень
  static final boxShadow = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowColor.withOpacity(opacity),
      blurRadius: 10.0,
      offset: const Offset(-4.0, 0.0),
    )
  ];

  /// Стандартная тень для кнопок согласно изменений 18/03 (Яна)
  static final boxShadowButton = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowColor.withOpacity(opacity),
      blurRadius: 7.0,
      offset: const Offset(-4.0, 4.0),
    )
  ];

  //Тень для цели, которая имеет статус (Завершена, Пауза, Просрочена)
  static final goalShadow = <BoxShadow>[
    BoxShadow(
        color: AppColors.shadowColor.withOpacity(0.2),
        blurRadius: 15,
        blurStyle: BlurStyle.outer)
  ];

  static const stdHGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xff93dbdf),
      Color(0xff77cca4),
    ],
  );

  static const stdVGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xff93DBDF),
      Color(0xff77CCA4),
    ],
  );

  static const lightVGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffFFFFFF),
      Color(0xff7ACDAC),
    ],
  );

  static const roundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xff80D2B6),
      Color(0xff91DBDB),
    ],
  );

  static const yellowHGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xffFFFFFF),
      Color(0xffFFCB00),
    ],
  );
}
