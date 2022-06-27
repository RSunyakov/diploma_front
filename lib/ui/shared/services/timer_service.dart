import 'dart:async';
import 'package:get/get.dart';
import 'package:sphere/core/utils/get_rx_wrapper.dart';
import 'package:sphere/core/utils/stream_subscriber.dart';

import '../../../logic/auth/auth_service.dart';

class TimerService extends GetxService with StreamSubscriberMixin {
  TimerService({AuthService? authService})
      : _authService = authService ?? Get.find();

  final AuthService _authService;

  final countdownValue = GetRxWrapper<int>(0);

  static const _timerStartValue = 10;

  Timer? _countdownTimer;

  void startCodeRepeatingCountdown() {
    _resetTimer();
    countdownValue.value = _timerStartValue;
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        countdownValue.value = countdownValue.value$ - 1;
        if (countdownValue.value$ == 0) {
          _resetTimer();
        }
      },
    );
  }

  fetchCodeAgain() {
    _authService.fetchCodeAgain();
    startCodeRepeatingCountdown();
  }

  @override
  void onClose() {
    _resetTimer();
    super.onClose();
  }

  void _resetTimer() => _countdownTimer?.cancel();
}
