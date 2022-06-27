import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';

class AppConsts {
  static const delayForEscapeVisualConflict = 100;
  static const exitTimeInMillis = 2000;
  static const showButton = 'showButton';
  static const skipPage = 'skipPage';
  static const isScrollableTabBarLength = 450;
  static const achievementsGroupTag = 'AchivementsGroupTag';
  static const subscriptionsGroupTag = 'SubscriptionsGroupTag';
  static const membersListGroupTag = 'MembersListGroupTag';
  static const preLoader = Center(
      child: CircularProgressIndicator(
    color: AppColors.gradientBottom,
  ));

  /// Некая вменяемая задержка для ряда ситуаций, когда следует придержать
  /// вывод, но чтобы не утомлять юзера
  /// Примеры:
  /// 1. Вывод сообщения после перехода на страницу
  /// 2. Задержка события после перехода, чтобы все подготовилось
  static const humanFriendlyDelay = 250;
}
