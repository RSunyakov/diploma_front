import 'package:get/get.dart' hide Trans;
import 'package:sphere/logic/auth/auth_service.dart';
import 'package:sphere/ui/router/router.dart';
import 'package:sphere/ui/router/router.gr.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

class SettingsScreenController extends StatexController {
  final _listSettings = <SettingModel>[
    /*SettingModel(
      title: 'general.page_settings',
      onTap: () => AppRouter.push(PageSettingsRoute()),
    ),*/
    SettingModel(
      title: 'settings.common',
      onTap: () => AppRouter.push(GeneralSettingsRoute()),
    ),
   /* SettingModel(
      title: 'settings.mentorship',
      onTap: () => AppRouter.push(MentorSettingsRoute()),
    ),*/
    SettingModel(
      title: 'settings.wallet',
      onTap: () => AppRouter.push(WalletSettingsRoute()),
    ),
    SettingModel(
      title: 'settings.notifications',
      onTap: () => AppRouter.push(NotificationSettingsRoute()),
    ),
    SettingModel(
      title: 'settings.privacy',
      onTap: () => AppRouter.push(PrivateSettingsRoute()),
    ),
    SettingModel(
      title: 'settings.safety',
      onTap: () => AppRouter.push(SafetySettingsRoute()),
    ),
    SettingModel(
      title: 'settings.agreement',
      onTap: () => AppRouter.push(LicenseAgreementRoute()),
    ),
    SettingModel(
      title: 'settings.generate_report',
      onTap: () => AppRouter.push(GenerateReportRoute()),
    ),
  ];

  List<SettingModel> get listSettings => _listSettings;

  void logout() => Get.find<AuthService>().logout();
}

class SettingModel {
  final String title;
  final Function() onTap;
  SettingModel({
    required this.title,
    required this.onTap,
  });
}
