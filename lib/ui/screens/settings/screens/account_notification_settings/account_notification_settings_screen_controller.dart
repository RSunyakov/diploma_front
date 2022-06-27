import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/safe_coding/src/either.dart';
import '../../../../../core/utils/stream_subscriber.dart';
import '../../../../../domain/core/extended_errors.dart';
import '../../../../../domain/notification/notification.dart';
import '../../src/settings_service.dart';

class AccountNotificationSettingModel {
  AccountNotificationSettingModel({
    this.pathAvatar,
    required this.title,
    required this.description,
    this.isUnread = true,
    // this.rate,
  });

  String? pathAvatar;
  String title;
  String description;
  bool isUnread;
}

class AccountNotificationSettingsScreenController extends StatexController
    with StreamSubscriberMixin {
  AccountNotificationSettingsScreenController({SettingsService? service})
      : _service = service ?? Get.find();

  final SettingsService _service;

  final _notificationsList = <AccountNotificationSettingModel>[
    AccountNotificationSettingModel(
        title: 'settings.goal_expired'.tr(), description: 'Освоить медитацию'),
    AccountNotificationSettingModel(
        title: 'settings.mark_progress'.tr(), description: 'Бегать'),
    AccountNotificationSettingModel(
        title: 'settings.new_comment_for_goal'.tr(), description: 'Бегать'),
    AccountNotificationSettingModel(
        title: 'settings.new_comment_for_report'.tr(), description: '+5'),
  ].obs;

  List<AccountNotificationSettingModel> get notificationsList$ =>
      _notificationsList;

  final _notifications = <Notification>[].obs;

  final _isNotificationRemindGoal = true.obs;

  get isNotificationRemindGoal$ => _isNotificationRemindGoal();

  void setIsNotificationRemindGoal(bool v) => _isNotificationRemindGoal(v);

  final _isNotificationNewCommentReports = true.obs;

  get isNotificationNewCommentReports$ => _isNotificationNewCommentReports();

  void setIsNotificationNewCommentReports(bool v) =>
      _isNotificationNewCommentReports(v);

  final _isNotificationMentor = true.obs;

  get isNotificationMentor$ => _isNotificationMentor();

  void setIsNotificationMentor(bool v) => _isNotificationMentor(v);

  final _isNotificationNewSubscriber = true.obs;

  get isNotificationNewSubscriber$ => _isNotificationNewSubscriber();

  void setIsNotificationNewSubscriber(bool v) =>
      _isNotificationNewSubscriber(v);

  final _isNotificationNewWallet = true.obs;

  get isNotificationNewWallet$ => _isNotificationNewWallet();

  void setIsNotificationNewWallet(bool v) => _isNotificationNewWallet(v);

  @override
  void onInit() {
    super.onInit();
    subscribeIt(_service.notifications.stream.listen(_processNotifications));
  }

  @override
  void onWidgetInitState() {
    super.onWidgetInitState();
    _service.fetchNotifications();
  }

  void _processNotifications(Either<ExtendedErrors, List<Notification>> info) {
    info.fold((l) {
      appAlert(value: l.error, color: AppColors.red);
    }, (r) {
      _notifications.addAll(r);
    });
  }
}
