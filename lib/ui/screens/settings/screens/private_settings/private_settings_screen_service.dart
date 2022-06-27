import 'package:get/get.dart' hide Trans;
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/core/utils/get_rx_wrapper_2.dart';
import 'package:sphere/core/utils/stream_subscriber.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';
import 'package:sphere/ui/screens/settings/src/settings_service.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:easy_localization/easy_localization.dart';

class PrivateSettingsScreenService extends GetxService
    with StreamSubscriberMixin {
  PrivateSettingsScreenService({SettingsService? service})
      : _service = service ?? Get.find();

  final SettingsService _service;

  static const minHeight = 40.0;
  final height = GetRxWrapper2(minHeight);
  final isOpened = GetRxWrapper2(false);

  final privateSettingsList = [
    'general.all_users'.tr(),
    'general.subscribers_only'.tr(),
    'general.my_mentors'.tr(),
    'general.none'.tr(),
  ];

  final listSettingsProfile = <SettingsModel>[
    SettingsModel(
      title: 'settings.who_see_me'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'main_info_visible',
    ),
    SettingsModel(
      title: 'settings.who_see_my_stat'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'statistics_visible',
    ),
    SettingsModel(
      title: 'settings.show_my_profile'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'search_visible',
    ),
  ].obs;

  final listSettingsGolas = <SettingsModel>[
    SettingsModel(
      title: 'setting.who_see_my_progress'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'goals_in_progress_visible',
    ),
    SettingsModel(
      title: 'settings.who_see_my_achievements'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'achievements_visible',
    ),
    SettingsModel(
      title: 'settings.who_see_my_completed_goals'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'goals_complete_visible',
    ),
    SettingsModel(
      title: 'settings.who_see_my_expired_goals'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'goals_overdue_visible',
    ),
    SettingsModel(
      title: 'settings.who_see_my_pending_goals'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'goals_paused_visible',
    ),
    SettingsModel(
      title: 'settings.who_can_open_goals_details'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'goals_details_open',
    ),
    SettingsModel(
      title: 'settings.who_can_add_goals_to_favorite'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'goals_favorites_add',
    ),
    SettingsModel(
      title: 'settings.who_can_copy_goals'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'goals_copy',
    ),
    SettingsModel(
      title: 'settings.who_can_see_my_goals_comments'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'goals_comments_visible',
    ),
    SettingsModel(
      title: 'settings.who_can_comment_my_goals'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'goals_comments_write',
    ),
  ].obs;

  final listSettingsMentors = <SettingsModel>[
    SettingsModel(
      title: 'settings.who_can_ask_me_mentor'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'mentoring_offer',
    ),
    SettingsModel(
      title: 'settings.who_can_be_mentor'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'mentoring_become',
    ),
  ].obs;

  final listSettingsReports = <SettingsModel>[
    SettingsModel(
      title: 'settings.who_see_daily_reports'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'reports_visible',
    ),
    SettingsModel(
      title: 'settings.who_can_comment_daly_reports'.tr(),
      setting: GetRxWrapper2('general.all_users'.tr()),
      fromAPI: 'reports_comments',
    ),
  ].obs;

  void _processUserSettings(Either<ExtendedErrors, UserSettings> info) {
    info.fold((l) {
      appAlert(value: l.error, color: AppColors.red);
    }, (r) async {
      for (Setting setting in r.settings.getOrElse(() => [])) {
        await _convertFromAPI(list: listSettingsProfile, setting: setting);
        await _convertFromAPI(list: listSettingsGolas, setting: setting);
        await _convertFromAPI(list: listSettingsMentors, setting: setting);
        await _convertFromAPI(list: listSettingsReports, setting: setting);
      }
    });
  }

  Future _convertFromAPI(
      {required RxList<SettingsModel> list, required Setting setting}) async {
    for (SettingsModel v in list) {
      if (v.fromAPI == setting.name.getOrElse()) {
        v.setting.value(convertSettingValuesFromApi(setting.value.getOrElse()));
        list.refresh();
      }
    }
  }

  String convertSettingValuesFromApi(String apiName) {
    switch (apiName) {
      case 'all':
        return 'general.all_users'.tr();
      case 'mentors':
        return 'general.my_mentors'.tr();
      case 'private':
        return 'general.subscribers_only'.tr();
      case 'none':
        return 'general.none'.tr();
    }
    return 'general.all_users'.tr();
  }

  String convertSettingValuesToApi(String value) {
    //TODO(Iosif): !!!Переделать. Нельзя в case использовать переменные, только консатнты. Вылезло при локализации, т.к. локализуемые литералы становятся переменными!!!
    switch (value) {
      case 'general.all_users':
        return 'all';
      case 'general.my_mentors':
        return 'mentors';
      case 'general.subscribers_only':
        return 'private';
      case 'general.none':
        return 'none';
    }
    return 'all';
  }

  void updateUserSettings({required String apiValue, required String value}) {
    switch (value) {
      case 'main_info_visible':
        return _service.updateUserSettings(
            mainInfoVisible: convertSettingValuesToApi(value));
      case 'statistics_visible':
        return _service.updateUserSettings(
            statisticsVisible: convertSettingValuesToApi(value));
      case 'search_visible':
        return _service.updateUserSettings(
            searchVisible: convertSettingValuesToApi(value));
      case 'goals_in_progress_visible':
        return _service.updateUserSettings(
            goalsInProgressVisible: convertSettingValuesToApi(value));
      case 'achievements_visible':
        return _service.updateUserSettings(
            achievementsVisible: convertSettingValuesToApi(value));
      case 'goals_complete_visible':
        return _service.updateUserSettings(
            goalsCompleteVisible: convertSettingValuesToApi(value));
      case 'goals_overdue_visible':
        return _service.updateUserSettings(
            goalsOverdueVisible: convertSettingValuesToApi(value));
      case 'goals_paused_visible':
        return _service.updateUserSettings(
            goalsPausedVisible: convertSettingValuesToApi(value));
      case 'goals_details_open':
        return _service.updateUserSettings(
            goalsDetailsOpen: convertSettingValuesToApi(value));
      case 'goals_favorites_add':
        return _service.updateUserSettings(
            goalsFavoritesAdd: convertSettingValuesToApi(value));
      case 'goals_copy':
        return _service.updateUserSettings(
            goalsCopy: convertSettingValuesToApi(value));
      case 'goals_comments_visible':
        return _service.updateUserSettings(
            goalsCommentsVisible: convertSettingValuesToApi(value));
      case 'goals_comments_write':
        return _service.updateUserSettings(
            goalsCommentsWrite: convertSettingValuesToApi(value));
      case 'mentoring_offer':
        return _service.updateUserSettings(
            mentoringOffer: convertSettingValuesToApi(value));
      case 'mentoring_become':
        return _service.updateUserSettings(
            mentoringBecome: convertSettingValuesToApi(value));
      case 'reports_visible':
        return _service.updateUserSettings(
            reportsVisible: convertSettingValuesToApi(value));
      case 'reports_comments':
        return _service.updateUserSettings(
            reportsComments: convertSettingValuesToApi(value));
    }
  }

  void updateSize({
    required String title,
    required RxList<SettingsModel> listSetting,
    String? value,
    bool isOpne = false,
  }) {
    for (SettingsModel setting in listSetting) {
      if (setting.title == title) {
        setting.isOpen = !setting.isOpen;
        setting.setting.value(value ?? setting.setting.value$);
      }
    }
    listSetting.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    _service.fetchUserSettings();

    subscribeIt(_service.userSettingsData.stream.listen(_processUserSettings));
  }
}

class SettingsModel {
  String title;
  GetRxWrapper2 setting;
  bool isOpen;
  String fromAPI;

  SettingsModel({
    required this.title,
    required this.setting,
    required this.fromAPI,
    this.isOpen = false,
  });
}
