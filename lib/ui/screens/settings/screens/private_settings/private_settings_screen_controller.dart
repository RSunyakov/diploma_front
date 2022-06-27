import 'package:get/get.dart';
import 'package:sphere/core/utils/stream_subscriber.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import 'private_settings_screen_service.dart';

class PrivateSettingsScreenController extends StatexController
    with StreamSubscriberMixin {
  PrivateSettingsScreenController({PrivateSettingsScreenService? service})
      : _service = service ?? Get.find();

  final PrivateSettingsScreenService _service;

  double get height => _service.height.value$;
  bool get isOpened => _service.isOpened.value$;

  List<String> get privateSettingsList => _service.privateSettingsList;

  RxList<SettingsModel> get listSettingsProfile => _service.listSettingsProfile;
  RxList<SettingsModel> get listSettingsGolas => _service.listSettingsGolas;
  RxList<SettingsModel> get listSettingsMentors => _service.listSettingsMentors;
  RxList<SettingsModel> get listSettingsReports => _service.listSettingsReports;

  String convertSettingValuesFromApi(String apiName) =>
      _service.convertSettingValuesFromApi(apiName);

  String convertSettingValuesToApi(String value) =>
      _service.convertSettingValuesToApi(value);

  void updateUserSettings({
    required String apiValue,
    required String value,
  }) =>
      _service.updateUserSettings(apiValue: apiValue, value: value);

  void updateSize({
    required String title,
    required RxList<SettingsModel> listSetting,
    String? value,
  }) =>
      _service.updateSize(title: title, listSetting: listSetting, value: value);
}
