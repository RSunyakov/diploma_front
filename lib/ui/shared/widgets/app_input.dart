import 'package:flutter/material.dart';

import 'package:sphere/ui/shared/app_extensions.dart';
import 'package:sphere/ui/shared/app_icons.dart';

import '../app_colors.dart';
import '../app_styles.dart';
import 'app_testable_widget.dart';

/// Стандартный инпут-филд.
/// Наследуется от виджета со свойствами тестинга.

class AppInput extends AppTestableWidget {
  AppInput(
      {Key? key,
      TextEditingController? controller,
      this.label,
      this.height = 30,
      this.width,
      this.onChanged,
      this.obscureText = false,
      this.maxLines = 1,
      this.textColor = AppColors.plainText,
      this.readOnly = false,
      this.isValid = true,
      this.autofocus = false,
      this.focusNode,
      this.value = '',
      this.hintText = '',
      this.keyboardType,
      this.onIconTap,
      this.validator,
      this.fontSize = 11.0,
      this.borderRadius = 10.0,
      this.iconSvg = '',
      this.iconData,
      this.customIconWidget,
      this.isNeedAcceptButton = false,
      this.onAcceptButtonTap,
      this.shadow,
      this.customAcceptButton,
      this.textPadding,
      AppTestableData? testableData,
      EdgeInsetsGeometry? margin})
      : controller = controller ?? TextEditingController(),
        margin = margin ?? EdgeInsets.symmetric(horizontal: 15.kW),
        super(
          // Если клиент ничего не передает или передает с маркером
          // отдаем в [TestableWidget] как есть.
          // Иначе перестроим маркер по-своему (для демонстрации возможностей)
          testableData: testableData == null || testableData.marker != null
              ? testableData
              : testableData.copyWith(
                  marker: const Icon(
                  Icons.adb,
                  color: Colors.red,
                )),
          key: key,
        );

  final TextEditingController controller;
  final String? label;

  /// минимальная высота = 30, ниже не будет работать!
  final double height;
  final double? width;
  final bool obscureText;
  final int? maxLines;
  final Color textColor;
  final Function(String)? onChanged;
  final bool readOnly;
  final bool isValid;
  final String value;
  final String hintText;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry margin;
  final bool autofocus;
  final FocusNode? focusNode;
  final Function()? onIconTap;
  final FormFieldValidator<String>? validator;
  final double fontSize;
  final double borderRadius;
  final String iconSvg;
  final IconData? iconData;
  final Widget? customIconWidget;
  final bool isNeedAcceptButton;
  final Widget? customAcceptButton;
  final EdgeInsets? textPadding;
  final Function()? onAcceptButtonTap;
  final List<BoxShadow>? shadow;

  @override
  Widget buildMain(BuildContext context) {
    double h = height < 30.kH ? 30.kH : height;
    final textStyle = AppStyles.text14
        .andSize(fontSize)
        .andColor(AppColors.lightGreyText)
        .andWeight(FontWeight.w300);
    return Container(
      margin: margin,
      // height: h,
      decoration: BoxDecoration(
          boxShadow: shadow ?? AppColors.boxShadow,
          borderRadius:
              shadow != null ? BorderRadius.circular(5) : BorderRadius.zero),
      child: Stack(children: [
        TextFormField(
          validator: validator,
          autofocus: autofocus,
          focusNode: focusNode,
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: textStyle.andColor(
            isValid ? textColor : AppColors.red,
          ),
          readOnly: readOnly,
          cursorColor: AppColors.grey,
          obscureText: obscureText,
          maxLines: maxLines,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: textPadding != null
                ? textPadding!
                : EdgeInsets.fromLTRB(
                    20, (h - fontSize) / 2, 20, (h - fontSize) / 2),
            hintText: hintText,
            fillColor: AppColors.white,
            filled: true,
            hintStyle: textStyle,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide:
                  BorderSide(width: 0, color: AppColors.white.withOpacity(0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide:
                  const BorderSide(width: 0, color: AppColors.mainColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide:
                  BorderSide(width: 0, color: AppColors.white.withOpacity(0)),
            ),
            suffixIconConstraints: BoxConstraints(minHeight: h, minWidth: h),
            suffixIcon: iconSvg != ''
                ? _SvgIcon(
                    width: h,
                    icon: iconSvg,
                    onIconTap: onIconTap,
                  )
                : iconData != null
                    ? _IconData(
                        width: h,
                        iconData: iconData,
                        onIconTap: onIconTap,
                      )
                    : customIconWidget,
          ),
        ),
        if (isNeedAcceptButton)
          customAcceptButton != null
              ? customAcceptButton!
              : Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: onAcceptButtonTap,
                    child: Container(
                      width: height * 1.07,
                      height: height,
                      decoration: BoxDecoration(
                        gradient: AppColors.stdVGradient,
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius)),
                      ),
                      child:
                          Center(child: svgPicture(AppIcons.arrowForwardSharp)),
                    ),
                  ),
                ),
      ]),
    );
  }
}

class _SvgIcon extends StatelessWidget {
  const _SvgIcon({
    Key? key,
    required this.icon,
    this.onIconTap,
    this.width,
  }) : super(key: key);
  final String icon;
  final Function()? onIconTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onIconTap,
      child: Container(
        width: width,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: AppColors.stdHGradient,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: svgPicture(
          icon,
          width: 10,
          height: 10,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _IconData extends StatelessWidget {
  const _IconData(
      {Key? key, required this.iconData, this.onIconTap, this.width})
      : super(key: key);
  final double? width;
  final IconData? iconData;
  final Function()? onIconTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onIconTap,
      child: Container(
        width: width,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: AppColors.stdHGradient,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Icon(
          iconData,
          size: 15,
          color: AppColors.white,
        ),
      ),
    );
  }
}
