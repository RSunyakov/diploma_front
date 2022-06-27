import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';

class AppPlusButton extends StatelessWidget {
  const AppPlusButton({
    Key? key,
    required this.size,
    required this.onPressed,
    this.appPlusButtonStyle = const AppPlusButtonStyle(),
  }) : super(key: key);

  final double size;
  final Function()? onPressed;
  final AppPlusButtonStyle appPlusButtonStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: appPlusButtonStyle.disabled ? null : AppColors.stdVGradient,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(size),
            bottomRight: Radius.circular(size),
            bottomLeft: Radius.circular(size),
          ),
          color: appPlusButtonStyle.disabledColor),
      child: AnimatedContainer(
        duration: const Duration(seconds: 2),
        height: size,
        width: size,
        child: Material(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(size),
              bottomRight: Radius.circular(size),
              bottomLeft: Radius.circular(size)),
          color: AppColors.buttonGreen.withOpacity(0),
          child: InkWell(
            ///Условие для того, чтобы у задизейбленной
            ///кнопки не был доступен функционал
            onTap: appPlusButtonStyle.disabled ? null : onPressed,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(size),
                bottomRight: Radius.circular(size),
                bottomLeft: Radius.circular(size)),
            splashColor: Colors.white.withOpacity(0.5),
            highlightColor: Colors.white.withOpacity(0.5),
            child: Icon(
              Icons.add,
              color: AppColors.white,
              size: appPlusButtonStyle.plusSize ?? size / 2,
            ),
          ),
        ),
      ),
    );
  }
}

class AppPlusButtonStyle {
  const AppPlusButtonStyle({
    this.disabled = false,
    this.disabledColor = AppColors.lightGrey,
    this.plusSize,
  });

  //Состояние активности у кнопки
  final bool disabled;

  //Цвет для этого состояния
  final Color disabledColor;
  final double? plusSize;
}
