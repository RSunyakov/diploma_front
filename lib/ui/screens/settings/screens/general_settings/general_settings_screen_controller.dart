import 'package:get/get.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import '../../../../../core/safe_coding/src/either.dart';
import '../../../../../core/utils/stream_subscriber.dart';
import '../../../../../domain/core/extended_errors.dart';
import '../../../../../domain/user_settings/user_settings.dart';
import '../../../../router/router.dart';
import '../../../../router/router.gr.dart';
import '../../src/settings_service.dart';

class GeneralSettingsScreenController extends StatexController
    with StreamSubscriberMixin {
  GeneralSettingsScreenController({SettingsService? service})
      : _service = service ?? Get.find();

  final SettingsService _service;

  final _email = ''.obs;

  String get email$ => _email();

  final _phone = ''.obs;

  get phone$ => _phone();

  @override
  void onInit() {
    super.onInit();
    subscribeIt(_service.userSettingsData.stream.listen(_processUserSettings));
    subscribeIt(_service.isCodeForChangeLoginFetched.stream
        .listen(_processCodeForChangeLogin));
  }

  @override
  void onWidgetInitState() {
    super.onWidgetInitState();
    _service.fetchUserSettings();
  }

  void _processUserSettings(Either<ExtendedErrors, UserSettings> info) {
    info.fold((l) {
      appAlert(value: l.error, color: AppColors.red);
    }, (r) {
      _phone.value = r.userInfo.phone.getOrElse();
      _email.value = r.userInfo.email.getOrElse();
    });
  }

  void _processCodeForChangeLogin(bool info) {
    if (info) {
      _service.isCodeForChangeLoginFetched.value = false;
      AppRouter.push(ChangeEmailRoute(isBindEmail: true, oldEmail: email$));
    }
  }

  void changeEmail() => email$.isNotEmpty
      ? fetchCode()
      : AppRouter.push(
          ChangeEmailRoute(isBindEmail: false, oldEmail: ''),
        );

  void fetchCode() {
    _service.fetchCodeForChangeLogin(email$, true);
  }

  void changePhone() => AppRouter.push(ChangePhoneRoute());
}
