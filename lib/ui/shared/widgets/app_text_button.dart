import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/app_colors.dart';
import 'package:sphere/ui/shared/app_styles.dart';

/// Это решение взято отсюда
/// чтобы декоратор не перекрывал риппл-эффект.
/// from https://stackoverflow.com/questions/51463515/inkwell-not-showing-ripple-when-used-with-container-decoration
/// ```
/// I found the solution:
///
/// I need one Material for Inkwell, and one Material for elevation
/// and rounded borders. The inner Material has a type
/// of MaterialType.transparency so that it doesn't draw anything
/// over the box decoration of its parent and still preserve the ink effect.
/// The shadow and borders are controlled by outer Material.
/// ```
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    this.width = 100,
    this.height = 30,
    this.onPressed,
    this.borderRadius = 10,
    this.gradient = AppColors.stdHGradient,
    required this.text,
    this.shadow,
    Key? key,
  }) : super(key: key);

  final double width;
  final double height;
  final Function()? onPressed;
  final double borderRadius;
  final LinearGradient gradient;
  final String text;
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    return onPressed == null
        ? _Disabled(
            width: width,
            height: height,
            borderRadius: borderRadius,
            text: text,
          )
        : _Enabled(
            width: width,
            height: height,
            shadow: shadow,
            borderRadius: borderRadius,
            text: text,
            onPressed: onPressed!,
            gradient: gradient,
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
      required this.gradient,
      this.shadow,
      Key? key})
      : super(
            width: width,
            height: height,
            borderRadius: borderRadius,
            boxDecoration: BoxDecoration(
              boxShadow: shadow ?? AppColors.boxShadowButton,
              gradient: gradient,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            text: text,
            key: key);

  final List<BoxShadow>? shadow;
  final Function() onPressed;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: boxDecoration,
      alignment: Alignment.center,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withOpacity(0.5),
          highlightColor: Colors.white.withOpacity(0.5),
          onTap: onPressed,
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: Text(
              text,
              style: AppStyles.text12.andColor(AppColors.white),
            ),
          ),
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
  }) : super(key: key);

  final double width;
  final double height;
  final double borderRadius;
  final BoxDecoration boxDecoration;
  final String text;
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
