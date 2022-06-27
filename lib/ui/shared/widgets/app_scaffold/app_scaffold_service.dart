import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/core/utils/stream_subscriber.dart';
import 'package:sphere/ui/router/router.dart';
import 'package:sphere/ui/router/router.gr.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:vfx_flutter_common/get_rx_decorator.dart';
import 'package:easy_localization/easy_localization.dart';

class AppScaffoldService extends GetxService with StreamSubscriberMixin {
  AppScaffoldService();


  late var currentNavIndex = (_listBottomNav.length - 1).obsDeco();

  final _listBottomNav = <BottomNavModel>[
    /*BottomNavModel(
      text: 'general.ribbon'.tr(),
      icon: AppIcons.news,
      iconActive: AppIcons.activeNews,
      router: LentaRoute(),
    ),
    BottomNavModel(
      text: 'general.meta_live'.tr(),
      icon: AppIcons.metaLife,
      iconActive: AppIcons.activeMetaLife,
      router: MetaLiveRoute(),
    ),
    BottomNavModel(
      text: 'general.goals'.tr(),
      icon: AppIcons.goals,
      iconActive: AppIcons.activeGoals,
      router: GoalsRoute(),
    ),
    BottomNavModel(
      text: 'general.mentors'.tr(),
      icon: AppIcons.mentor,
      iconActive: AppIcons.activeMentor,
      router: MentorsRoute(),
    ),
    BottomNavModel(
      text: 'general.profile'.tr(),
      icon: AppIcons.profile,
      iconActive: AppIcons.activeProfile,
      router: ProfileRoute(),
    ),*/
  ].obs;

  List<BottomNavModel> get listBottomNav => _listBottomNav();

  void goToPage(int index) {
    AppRouter.replace(_listBottomNav[index].router);
    currentNavIndex(index);
  }

  int? _lastTimeBackButtonWasTapped;
  Future<bool> doubleExit() async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (_lastTimeBackButtonWasTapped != null &&
        (currentTime - (_lastTimeBackButtonWasTapped ?? 0)) <
            AppConsts.exitTimeInMillis) {
      return Future.value(true);
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      appAlert(
          value: 'general.press_back_button'.tr(), color: AppColors.activeText);
      return Future.value(false);
    }
  }

  Future<bool> tryExit() async {
    if (currentNavIndex.value == 0) {
      return await doubleExit();
    }
    // Get.back();
    // AppRouter.pop();
    return Future.value(false);
  }
}

class BottomNavModel {
  Color? activeColor;
  String icon;
  String iconActive;
  String text;
  PageRouteInfo router;

  BottomNavModel({
    this.activeColor,
    required this.icon,
    required this.iconActive,
    required this.text,
    required this.router,
  });
}
