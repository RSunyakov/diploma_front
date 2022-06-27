import 'package:get/get.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import '../../../../../core/safe_coding/src/either.dart';
import '../../../../../core/utils/stream_subscriber.dart';
import '../../../../../domain/user_settings/user_settings.dart';
import '../../src/settings_service.dart';

class NotificationSettingsScreenController extends StatexController
    with StreamSubscriberMixin {
  NotificationSettingsScreenController({SettingsService? service})
      : _service = service ?? Get.find();

  final SettingsService _service;

  final _currentNotificationsIds = <int>[].obs;

  List<int> get currentNotificationsIds$ => _currentNotificationsIds();

  final _isNotificationProgressGoal = true.obs;

  get isNotificationProgressGoal$ => _isNotificationProgressGoal();

  void setIsNotificationProgressGoal(bool v) {
    _updateCurrentNotificationsIds(v, 21);
    _isNotificationProgressGoal(v);
  }

  final _isNotificationRemindGoal = true.obs;

  get isNotificationRemindGoal$ => _isNotificationRemindGoal();

  void setIsNotificationRemindGoal(bool v) {
    _updateCurrentNotificationsIds(v, 10);
    _isNotificationRemindGoal(v);
  }

  final _isNotificationNewCommentReports = true.obs;

  get isNotificationNewCommentReports$ => _isNotificationNewCommentReports();

  void setIsNotificationNewCommentReports(bool v) {
    _updateCurrentNotificationsIds(v, 23);
    _isNotificationNewCommentReports(v);
  }

  final _isNotificationMentor = true.obs;

  get isNotificationMentor$ => _isNotificationMentor();

  void setIsNotificationMentor(bool v) {
    _updateCurrentNotificationsIds(v, 13);
    _isNotificationMentor(v);
  }

  final _isNotificationNewSubscriber = true.obs;

  get isNotificationNewSubscriber$ => _isNotificationNewSubscriber();

  void setIsNotificationNewSubscriber(bool v) {
    _updateCurrentNotificationsIds(v, 14);
    _isNotificationNewSubscriber(v);
  }

  final _isNotificationNewCommentGoals = true.obs;

  get isNotificationNewCommentGoals$ => _isNotificationNewCommentGoals();

  void setIsNotificationNewCommentGoals(bool v) {
    _updateCurrentNotificationsIds(v, 22);
    _isNotificationNewCommentGoals(v);
  }

  @override
  void onInit() {
    super.onInit();
    subscribeIt(_service.userSettingsData.stream.listen(_processUserSettings));
  }

  @override
  void onWidgetInitState() {
    super.onWidgetInitState();
    _service.fetchUserSettings();
    _currentNotificationsIds.addAll([21, 10, 23, 13, 14, 22]);
  }

  void _processUserSettings(Either<ExtendedErrors, UserSettings> info) {
    info.fold((l) {
      appAlert(value: l.error, color: AppColors.red);
    }, (r) {
      if (r.notifications
              .getOrElse(() => [])
              .firstWhereOrNull((e) => e.id.getOrElse() == '21') ==
          null) {
        setIsNotificationProgressGoal(false);
      }

      if (r.notifications
              .getOrElse(() => [])
              .firstWhereOrNull((e) => e.id.getOrElse() == '10') ==
          null) {
        setIsNotificationRemindGoal(false);
      }

      if (r.notifications
              .getOrElse(() => [])
              .firstWhereOrNull((e) => e.id.getOrElse() == '23') ==
          null) {
        setIsNotificationNewCommentReports(false);
      }

      if (r.notifications
              .getOrElse(() => [])
              .firstWhereOrNull((e) => e.id.getOrElse() == '13') ==
          null) {
        setIsNotificationMentor(false);
      }

      if (r.notifications
              .getOrElse(() => [])
              .firstWhereOrNull((e) => e.id.getOrElse() == '14') ==
          null) {
        setIsNotificationNewSubscriber(false);
      }

      if (r.notifications
              .getOrElse(() => [])
              .firstWhereOrNull((e) => e.id.getOrElse() == '22') ==
          null) {
        setIsNotificationNewCommentGoals(false);
      }
    });
  }

  void updateUserSettings() {
    _service.updateUserSettings(
        notifications: currentNotificationsIds$.join(','));
  }

  void _updateCurrentNotificationsIds(bool v, int id) {
    if (v) {
      _currentNotificationsIds.add(id);
    } else {
      _currentNotificationsIds.remove(id);
    }
  }
}
