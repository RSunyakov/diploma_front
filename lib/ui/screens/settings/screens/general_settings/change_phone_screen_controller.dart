import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import '../../../../../core/utils/get_rx_wrapper.dart';
import '../../../../../core/utils/stream_subscriber.dart';
import '../../../../shared/services/timer_service.dart';
import '../../src/settings_service.dart';

enum ChangePhoneSteps {
  enterOldPhone,
  enterPinOldPhone,
  enterNewPhone,
  enterPinNewPhone,
  success
}

final _pageMap = <ChangePhoneSteps, int>{
  ChangePhoneSteps.enterOldPhone: 0,
  ChangePhoneSteps.enterPinOldPhone: 1,
  ChangePhoneSteps.enterNewPhone: 2,
  ChangePhoneSteps.enterPinNewPhone: 3,
  ChangePhoneSteps.success: 4,
};

class ChangePhoneScreenController extends StatexController
    with StreamSubscriberMixin {
  ChangePhoneScreenController(
      {TimerService? timerService, SettingsService? settingsService})
      : _timerService = timerService ?? Get.find(),
        _settingsService = settingsService ?? Get.find();

  final TimerService _timerService;

  final SettingsService _settingsService;

  late PageController pageController;

  late TextEditingController oldPhoneTextEditingController;

  late TextEditingController newPhoneTextEditingController;

  final _step = ChangePhoneSteps.enterOldPhone.obs;

  ChangePhoneSteps get step$ => _step();

  final allowCodeFetch = GetRxWrapper<bool>(false);

  GetRxWrapper get countdownValue => _timerService.countdownValue;

  void fetchCodeAgain() => _timerService.fetchCodeAgain();

  final _codeForOldPhone = ''.obs;

  final _codeForNewPhone = ''.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    oldPhoneTextEditingController = TextEditingController(text: "+7");
    newPhoneTextEditingController = TextEditingController(text: "+7");
    subscribeIt(
        _settingsService.isLoginUpdated.stream.listen(_processLoginUpdated));
    subscribeIt(_settingsService.isCodeForChangeLoginFetched.stream
        .listen(_processCodeForChangeLogin));
    subscribeIt(_settingsService.isCodeForChangeLoginRepeatedFetched.stream
        .listen(_processCodeForChangeLoginRepeated));
  }

  void _processCodeForChangeLogin(bool info) {
    if (info) {
      _settingsService.isCodeForChangeLoginFetched.value = false;
      chooseStep(ChangePhoneSteps.enterPinOldPhone);
    }
  }

  void _processCodeForChangeLoginRepeated(bool info) {
    if (info) {
      _settingsService.isCodeForChangeLoginFetched.value = false;
      chooseStep(ChangePhoneSteps.enterPinNewPhone);
    }
  }

  void _processLoginUpdated(bool info) {
    if (info) {
      _settingsService.isLoginUpdated.value = false;
      chooseStep(ChangePhoneSteps.success);
    }
  }

  void chooseStep(ChangePhoneSteps step) {
    _step(step);
    pageController.animateToPage(_pageMap[step]!,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void stepBack() {
    switch (step$) {
      case ChangePhoneSteps.enterNewPhone:
        chooseStep(ChangePhoneSteps.enterPinOldPhone);
        break;
      case ChangePhoneSteps.enterOldPhone:
        // TODO: Handle this case.
        break;
      case ChangePhoneSteps.enterPinOldPhone:
        // TODO: Handle this case.
        break;
      case ChangePhoneSteps.enterPinNewPhone:
        // TODO: Handle this case.
        break;
      case ChangePhoneSteps.success:
        // TODO: Handle this case.
        break;
    }
  }

  void complete(String value, bool isForOldPhone) {
    if (isForOldPhone) {
      chooseStep(ChangePhoneSteps.enterNewPhone);
      _codeForOldPhone.value = value;
    } else {
      _codeForNewPhone.value = value;
      updateUserLogin();
    }
  }

  @override
  void onClose() {
    // FIXME(vvk): textEditingController.dispose() не нужен, если контроллер
    // приаттачен к виджету. В этом случае его диспоз вызывается автоматически.
    // textEditingController.dispose();
    pageController.dispose();
    super.onClose();
  }

  void fetchCode(bool isForOldPhone) {
    _settingsService.fetchCodeForChangeLogin(
        isForOldPhone
            ? oldPhoneTextEditingController.text.replaceAll('+', '')
            : newPhoneTextEditingController.text.replaceAll('+', ''),
        isForOldPhone);
  }

  void updateUserLogin() {
    _settingsService.updateUserLogin(
      login: newPhoneTextEditingController.text,
      oldCode: _codeForOldPhone.value,
      newCode: _codeForNewPhone.value,
    );
  }
}
