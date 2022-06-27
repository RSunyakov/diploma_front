import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import '../../../../../core/utils/get_rx_wrapper.dart';
import '../../../../../core/utils/stream_subscriber.dart';
import '../../../../router/router.dart';
import '../../../../shared/services/timer_service.dart';
import '../../src/settings_service.dart';

enum ChangeEmailSteps {
  enterPinOldEmail,
  enterNewEmail,
  enterPinNewEmail,
  success
}

final _pageMapBindEmail = <ChangeEmailSteps, int>{
  ChangeEmailSteps.enterNewEmail: 0,
  ChangeEmailSteps.enterPinNewEmail: 1,
  ChangeEmailSteps.success: 2,
};

final _pageMapChangeEmail = <ChangeEmailSteps, int>{
  ChangeEmailSteps.enterPinOldEmail: 0,
  ChangeEmailSteps.enterNewEmail: 1,
  ChangeEmailSteps.enterPinNewEmail: 2,
  ChangeEmailSteps.success: 3,
};

class ChangeEmailScreenController extends StatexController
    with StreamSubscriberMixin {
  ChangeEmailScreenController(this.isBindEmail,
      {TimerService? timerService, SettingsService? settingsService})
      : _timerService = timerService ?? Get.find(),
        _settingsService = settingsService ?? Get.find();

  final TimerService _timerService;

  final SettingsService _settingsService;

  final bool isBindEmail;

  late PageController pageController;

  final _step = ChangeEmailSteps.enterPinOldEmail.obs;

  ChangeEmailSteps get step$ => _step();

  final allowCodeFetch = GetRxWrapper<bool>(false);

  GetRxWrapper get countdownValue => _timerService.countdownValue;

  void fetchCodeAgain() => _timerService.fetchCodeAgain();

  final _codeForOldEmail = ''.obs;

  final _codeForNewEmail = ''.obs;

  late TextEditingController newEmailTextEditingController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    newEmailTextEditingController = TextEditingController();
    subscribeIt(_settingsService.isCodeForChangeLoginFetched.stream
        .listen(_processCodeForChangeLogin));
    subscribeIt(
        _settingsService.isLoginUpdated.stream.listen(_processLoginUpdated));
    subscribeIt(_settingsService.isCodeForChangeLoginRepeatedFetched.stream
        .listen(_processCodeForChangeLoginRepeated));
  }

  void _processCodeForChangeLogin(bool info) {
    if (info) {
      _settingsService.isCodeForChangeLoginFetched.value = false;
      chooseStep(ChangeEmailSteps.enterPinOldEmail, isBindEmail);
    }
  }

  void _processCodeForChangeLoginRepeated(bool info) {
    if (info) {
      _settingsService.isCodeForChangeLoginFetched.value = false;
      chooseStep(ChangeEmailSteps.enterPinNewEmail, isBindEmail);
    }
  }

  void _processLoginUpdated(bool info) {
    if (info) {
      _settingsService.isLoginUpdated.value = false;
      chooseStep(ChangeEmailSteps.success, isBindEmail);
    }
  }

  void back() => AppRouter.navigateBack();

  void chooseStep(ChangeEmailSteps step, bool isBindEmail) {
    _step(step);
    if (isBindEmail) {
      pageController.animateToPage(_pageMapChangeEmail[step]!,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      pageController.animateToPage(_pageMapBindEmail[step]!,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void stepBack() {
    switch (step$) {
      case ChangeEmailSteps.enterNewEmail:
        chooseStep(ChangeEmailSteps.enterPinOldEmail, isBindEmail);
        break;
      case ChangeEmailSteps.enterPinOldEmail:
        // TODO: Handle this case.
        break;
      case ChangeEmailSteps.enterPinNewEmail:
        // TODO: Handle this case.
        break;
      case ChangeEmailSteps.success:
        // TODO: Handle this case.
        break;
    }
  }

  void complete(String value, bool isForOldPhone) {
    if (isForOldPhone) {
      chooseStep(ChangeEmailSteps.enterNewEmail, isBindEmail);
      _codeForOldEmail.value = value;
    } else {
      _codeForNewEmail.value = value;
      updateUserLogin();
    }
  }

  void fetchCode(bool isForOldEmail, String oldEmail) {
    _settingsService.fetchCodeForChangeLogin(
        isForOldEmail ? oldEmail : newEmailTextEditingController.text,
        isForOldEmail);
  }

  void updateUserLogin() {
    _settingsService.updateUserLogin(
      login: newEmailTextEditingController.text,
      oldCode: _codeForOldEmail.value,
      newCode: _codeForNewEmail.value,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
