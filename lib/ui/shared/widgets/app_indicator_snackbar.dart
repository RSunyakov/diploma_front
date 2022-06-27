import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:easy_localization/easy_localization.dart';

///На экраны, на которых находится appIndicatorSnackBar необходимо
///попадать при помощи AppRouter.replace(RouteName());
///с .push - работает некорректно (не подхватывает норм GlobalKey)
appIndicatorSnackBar({
  required BuildContext context,
  required String contentText,
  Widget? buttonPrefixWidget,
//  String buttonLabel = 'Отмена',
  String? label,
  required void Function() afterTimeExecute,

  ///Какое действие необходимо выполнить после нажатия кнопки
  required void Function() tapInCancelButton,
  int second = 5,
  Color? backgroundColor,
  TextStyle? contentTextStyle,
  required GlobalKey snackBarKey,
}) {
  final buttonLabel = label ?? 'general.cancel'.tr();
  bool isExecute = true;
  bool isCancel = false;
  final snackBar = SnackBar(
    //kki: key необходим для корректной работы кнопки "Отмена"
    key: snackBarKey,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Text(contentText,
                style: contentTextStyle ?? const TextStyle())),
        Container(
          constraints: const BoxConstraints(maxHeight: 22),
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: second * 1000),
            duration: Duration(seconds: second),
            builder: (context, double value, child) {
              return Stack(
                fit: StackFit.loose,
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: value / (second * 1000),
                      color: AppColors.lightGrey,
                      backgroundColor: AppColors.white,
                    ),
                  ),
                  Center(
                    child: Text(
                      (second - (value / 1000)).toInt().toString(),
                      textScaleFactor: 0.85,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        8.w,
        InkWell(
          splashColor: Colors.white,
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            isExecute = !isExecute;
            return;
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (buttonPrefixWidget != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: buttonPrefixWidget,
                ),
              GestureDetector(
                onTap: () {
                  ///Для корректной работы кнопки "Отмена" по месту необходимо
                  ///обращаться непосредственно к контексту GlobalKey.
                  ScaffoldMessenger.of(snackBarKey.currentContext!)
                      .hideCurrentSnackBar();
                  isCancel = !isCancel;
                  tapInCancelButton();
                  return;
                },
                child: Text(
                  buttonLabel,
                  style: AppStyles.text14
                      .andWeight(FontWeight.w400)
                      .andColor(AppColors.white),
                  textScaleFactor: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    backgroundColor: backgroundColor ?? AppColors.mainColor,
    duration: Duration(seconds: second),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);

  /// Если пользователь не нажимал на кнопку отмены, то по истечению счетчика происходит это действие
  Timer(Duration(seconds: second), () {
    if (isExecute && !isCancel) afterTimeExecute();
  });
}
