import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:vfx_flutter_common/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../shared/widgets/app_checkbox_container.dart';
import 'package:sphere/ui/shared/widgets/app_bottom_sheet/app_bottom_sheet_controller.dart';
import 'account_notification_settings_screen_controller.dart';

class AccountNotificationSettingsScreen
    extends StatexWidget<AccountNotificationSettingsScreenController> {
  AccountNotificationSettingsScreen({Key? key})
      : super(() => AccountNotificationSettingsScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) =>
      const _AccountNotificationSettingsScreen();
}

class _AccountNotificationSettingsScreen
    extends GetView<AccountNotificationSettingsScreenController> {
  const _AccountNotificationSettingsScreen();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(
        context,
        text: 'general.profile'.tr(),
        isLeading: true,
      ),
      child: Column(
        children: [
          16.h,
          GestureDetector(
            onTap: () => openBottomSheet(context, child: const _FiltersBox()),
            child: Container(
              padding: const EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              child: Text(
                'general.filter'.tr(),
                style: AppStyles.text16.andColor(AppColors.lightGreyText),
              ),
            ),
          ),
          16.h,
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.notificationsList$.length,
              itemBuilder: (_, index) {
                final model = controller.notificationsList$[index];
                return GestureDetector(
                  onTap: null,
                  child: AccountNotificationSettingItem(
                    model: model,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void openBottomSheet(BuildContext context, {required Widget child}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return AppBottomSheet(child: child);
      },
    );
  }
}

class AccountNotificationSettingItem extends StatelessWidget {
  const AccountNotificationSettingItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  final AccountNotificationSettingModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.kW, vertical: 5.kH),
      padding: const EdgeInsets.fromLTRB(20, 14, 28, 13),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: AppColors.boxShadow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 17.5,
                child: model.pathAvatar != null
                    ? FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: AppIcons.iconLoaderGif,
                        image: model.pathAvatar!,
                        imageErrorBuilder: (context, url, error) => const Icon(
                          Icons.image_not_supported,
                          color: AppColors.red,
                        ),
                      )
                    : Text(
                        '?',
                        style: AppStyles.text14.andColor(AppColors.white),
                      ),
              ),
              20.w,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: AppStyles.text12
                        .andColor(AppColors.plainText)
                        .andWeight(FontWeight.w500),
                  ),
                  3.h,
                  Text(
                    model.description,
                    style: AppStyles.text12.andColor(AppColors.lightGreyText),
                  ),
                ],
              ),
            ],
          ),
          if (model.isUnread)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.mainColor),
            )
        ],
      ),
    );
  }
}

class _FiltersBox extends GetView<AccountNotificationSettingsScreenController> {
  const _FiltersBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomCtrl = Get.find<AppBottomSheetController>();
    delayMilli(AppConsts.delayForEscapeVisualConflict).then((_) {
      bottomCtrl.height.value = 280;
    });
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'general.filter'.tr(),
              style: AppStyles.text16
                  .andColor(AppColors.lightGreyText)
                  .andWeight(FontWeight.w500),
            ),
            11.h,
            AppCheckboxContainer(
              title: 'settings.goals_notification'.tr(),
              value: controller.isNotificationRemindGoal$,
              onChanged: (v) => controller.setIsNotificationRemindGoal(v),
            ),
            15.h,
            AppCheckboxContainer(
              title: 'settings.comments'.tr(),
              value: controller.isNotificationNewCommentReports$,
              onChanged: (v) =>
                  controller.setIsNotificationNewCommentReports(v),
            ),
            15.h,
            AppCheckboxContainer(
              title: 'settings.new_follower'.tr(),
              value: controller.isNotificationNewSubscriber$,
              onChanged: (v) => controller.setIsNotificationNewSubscriber(v),
            ),
            15.h,
            AppCheckboxContainer(
              title: 'settings.mentorship'.tr(),
              value: controller.isNotificationMentor$,
              onChanged: (v) => controller.setIsNotificationMentor(v),
            ),
            15.h,
            AppCheckboxContainer(
              title: 'settings.wallet'.tr(),
              value: controller.isNotificationNewWallet$,
              onChanged: (v) => controller.setIsNotificationNewWallet(v),
            ),
          ],
        ),
      ),
    );
  }
}
