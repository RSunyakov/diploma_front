import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/app_colors.dart';
import 'package:sphere/ui/shared/app_styles.dart';

/// Это решение для нового дизайна, когда кнопки всегда белые,
/// пока не нажмешь.
class AppCheckableButton extends StatefulWidget {
  const AppCheckableButton({
    this.width = 100,
    this.height = 30,
    this.onPressed,
    this.borderRadius = 10,
    required this.text,
    this.isChosen = false,
    Key? key,
  }) : super(key: key);

  final double width;
  final double height;
  final Function()? onPressed;
  final double borderRadius;
  final String text;
  final bool isChosen;

  @override
  State<AppCheckableButton> createState() => _AppCheckableButtonState();
}

class _AppCheckableButtonState extends State<AppCheckableButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.onPressed == null
          ? _Disabled(
              width: widget.width,
              height: widget.height,
              borderRadius: widget.borderRadius,
              text: widget.text,
            )
          : _Enabled(
              width: widget.width,
              height: widget.height,
              borderRadius: widget.borderRadius,
              text: widget.text,
              onPressed: widget.onPressed!,
              isChosen: widget.isChosen,
            ),
    );
  }
}

class _Enabled extends _Base {
  _Enabled(
      {required double width,
      required double height,
      required double borderRadius,
      required String text,
      required this.onPressed,
      required this.isChosen,
      Key? key})
      : super(
            width: width,
            height: height,
            borderRadius: borderRadius,
            boxDecoration: isChosen
                ? BoxDecoration(
                    boxShadow: AppColors.boxShadowButton,
                    gradient: AppColors.stdHGradient,
                    borderRadius: BorderRadius.circular(borderRadius),
                  )
                : BoxDecoration(
                    boxShadow: AppColors.boxShadowButton,
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: AppColors.mainBG),
            text: text,
            textColor: isChosen ? AppColors.white : AppColors.black,
            key: key);

  final Function() onPressed;
  final bool isChosen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: boxDecoration,
        child: Text(
          text,
          style: AppStyles.text12.andColor(textColor),
        ),
      ),
    );
  }
}

class _Disabled extends _Base {
  _Disabled(
      {required double width,
      required double height,
      required double borderRadius,
      required String text,
      Key? key})
      : super(
            width: width,
            height: height,
            borderRadius: borderRadius,
            boxDecoration: BoxDecoration(
                boxShadow: AppColors.boxShadowButton,
                borderRadius: BorderRadius.circular(borderRadius),
                color: AppColors.mainBG),
            text: text,
            textColor: AppColors.white,
            key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          boxShadow: AppColors.boxShadowButton,
          borderRadius: BorderRadius.circular(borderRadius),
          color: AppColors.mainBG),
      alignment: Alignment.center,
      child: Text(
        text,
        style: AppStyles.text12.andColor(AppColors.plainText),
      ),
    );
  }
}

abstract class _Base extends StatelessWidget {
  const _Base({
    Key? key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.boxDecoration,
    required this.text,
    required this.textColor,
  }) : super(key: key);

  final double width;
  final double height;
  final double borderRadius;
  final BoxDecoration boxDecoration;
  final String text;
  final Color textColor;
}

//////////////////////////////////////////////////////////////////////////////

// TODO(vvk): впоследствии удалить - только для примера

/// Это решение показывает, что декоратор контейнера
/// скрывает декоратор риппл-эффекта
class AppButtonFailed extends StatelessWidget {
  final double width;
  final double height;
  final Function() onPressed;
  final double borderRadius;
  final Widget child;

  const AppButtonFailed({
    this.width = 100,
    this.height = 40,
    required this.onPressed,
    this.borderRadius = 10,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.button,
      color: Colors.transparent,
      child: Ink(
        width: 100,
        height: 30,
        decoration: BoxDecoration(
          boxShadow: AppColors.boxShadowButton,
          gradient: AppColors.stdHGradient,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: Colors.white.withOpacity(0.5),
          highlightColor: Colors.white.withOpacity(0.5),
          onTap: () {},
          child: Container(
            // Этот декоратор сткрывает риппл эффект
            decoration: BoxDecoration(
              boxShadow: AppColors.boxShadowButton,
              gradient: AppColors.stdHGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              'Text',
              style: AppStyles.text14.andColor(AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
