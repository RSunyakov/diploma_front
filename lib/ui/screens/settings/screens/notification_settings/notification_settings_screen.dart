import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import '../../../../shared/widgets/app_switch_container.dart';
import 'notification_settings_screen_controller.dart';

class NotificationSettingsScreen
    extends StatexWidget<NotificationSettingsScreenController> {
  NotificationSettingsScreen({Key? key})
      : super(() => NotificationSettingsScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) =>
      const _NotificationSettingsScreen();
}

class _NotificationSettingsScreen
    extends GetView<NotificationSettingsScreenController> {
  const _NotificationSettingsScreen();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(context,
          text: 'general.settings'.tr(),
          isLeading: true,
          funcBack: controller.updateUserSettings),
      child: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.kW),
          child: Column(
            children: [
              32.h,
              AppSwitchContainer(
                title: 'setting.goal_progress'.tr(),
                value: controller.isNotificationProgressGoal$,
                onChanged: controller.setIsNotificationProgressGoal,
              ),
              18.h,
              AppSwitchContainer(
                title: 'settings.goals_notification'.tr(),
                value: controller.isNotificationRemindGoal$,
                onChanged: controller.setIsNotificationRemindGoal,
              ),
              18.h,
              AppSwitchContainer(
                title: 'settings.new_comment_to_reports'.tr(),
                value: controller.isNotificationNewCommentReports$,
                onChanged: controller.setIsNotificationNewCommentReports,
              ),
              18.h,
              AppSwitchContainer(
                title: 'settings.mentorship',
                value: controller.isNotificationMentor$,
                onChanged: controller.setIsNotificationMentor,
              ),
              18.h,
              AppSwitchContainer(
                title: 'setting.new_follower'.tr(),
                value: controller.isNotificationNewSubscriber$,
                onChanged: controller.setIsNotificationNewSubscriber,
              ),
              18.h,
              AppSwitchContainer(
                title: 'settings.new_comment_to_goal'.tr(),
                value: controller.isNotificationNewCommentGoals$,
                onChanged: controller.setIsNotificationNewCommentGoals,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
