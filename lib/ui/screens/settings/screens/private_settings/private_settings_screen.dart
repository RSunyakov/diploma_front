import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import 'private_settings_screen_controller.dart';
import 'private_settings_screen_service.dart';

class PrivateSettingsScreen
    extends StatexWidget<PrivateSettingsScreenController> {
  PrivateSettingsScreen({Key? key})
      : super(() => PrivateSettingsScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) => const _PrivateSettingsScreen();
}

class _PrivateSettingsScreen extends GetView<PrivateSettingsScreenController> {
  const _PrivateSettingsScreen();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(
        context,
        text: 'general.settings'.tr(),
        isLeading: true,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20.kW, right: 20.kW, top: 20),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'settings.privacy_settings'.tr(),
                  style: AppStyles.text16
                      .andWeight(FontWeight.w500)
                      .andColor(AppColors.plainText),
                ),
                20.h,
                Text(
                  'general.profile'.tr(),
                  style: AppStyles.text16
                      .andWeight(FontWeight.w500)
                      .andColor(AppColors.plainText),
                ),
                10.h,
                for (var i = 0; i < controller.listSettingsProfile.length; i++)
                  PrivateSettingItem(
                    index: i,
                    list: controller.listSettingsProfile,
                    title: controller.listSettingsProfile()[i].title,
                    initialValue:
                        controller.listSettingsProfile()[i].setting.value$,
                    isOpened: controller.listSettingsProfile()[i].isOpen,
                    values: controller.privateSettingsList,
                  ),
                20.h,
                Text(
                  'general.goals'.tr(),
                  style: AppStyles.text16
                      .andWeight(FontWeight.w500)
                      .andColor(AppColors.plainText),
                ),
                10.h,
                for (var i = 0; i < controller.listSettingsGolas.length; i++)
                  PrivateSettingItem(
                    index: i,
                    list: controller.listSettingsGolas,
                    title: controller.listSettingsGolas()[i].title,
                    initialValue:
                        controller.listSettingsGolas()[i].setting.value$,
                    isOpened: controller.listSettingsGolas()[i].isOpen,
                    values: controller.privateSettingsList,
                  ),
                20.h,
                Text(
                  'settings.mentorship'.tr(),
                  style: AppStyles.text16
                      .andWeight(FontWeight.w500)
                      .andColor(AppColors.plainText),
                ),
                10.h,
                for (var i = 0; i < controller.listSettingsMentors.length; i++)
                  PrivateSettingItem(
                    index: i,
                    list: controller.listSettingsMentors,
                    title: controller.listSettingsMentors()[i].title,
                    initialValue:
                        controller.listSettingsMentors()[i].setting.value$,
                    isOpened: controller.listSettingsMentors()[i].isOpen,
                    values: controller.privateSettingsList,
                  ),
                20.h,
                Text(
                  'settings.day_report'.tr(),
                  style: AppStyles.text16
                      .andWeight(FontWeight.w500)
                      .andColor(AppColors.plainText),
                ),
                10.h,
                for (var i = 0; i < controller.listSettingsReports.length; i++)
                  PrivateSettingItem(
                    index: i,
                    list: controller.listSettingsReports,
                    title: controller.listSettingsReports()[i].title,
                    initialValue:
                        controller.listSettingsReports()[i].setting.value$,
                    isOpened: controller.listSettingsReports()[i].isOpen,
                    values: controller.privateSettingsList,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PrivateSettingItem extends GetViewSim<PrivateSettingsScreenController> {
  const PrivateSettingItem({
    Key? key,
    required this.index,
    required this.values,
    required this.title,
    required this.initialValue,
    required this.list,
    required this.isOpened,
  }) : super(key: key);

  final int index;
  final List<String> values;
  final String title;
  final bool isOpened;
  final String initialValue;
  final RxList<SettingsModel> list;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: isOpened ? 5 : 0),
      width: Get.width,
      padding: isOpened
          ? const EdgeInsets.fromLTRB(12, 5, 0, 5)
          : const EdgeInsets.symmetric(vertical: 5.0),
      decoration: isOpened
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: AppColors.boxShadow,
              color: AppColors.white,
            )
          : const BoxDecoration(),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => controller.updateSize(title: title, listSetting: list),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SimpleRichText(
                  title,
                  post: !isOpened
                      ? TextSpan(
                          text: '\n${initialValue.tr()}',
                          style: AppStyles.text12
                              .andColor(AppColors.lightGreyText)
                              .andHeight(1.3),
                        )
                      : null,
                  style: AppStyles.text12.andColor(AppColors.plainText),
                ),
                isOpened
                    ? const Icon(
                        Icons.keyboard_arrow_up,
                        color: AppColors.mainColor,
                      )
                    : const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.mainColor,
                      )
              ],
            ),
          ),
          if (isOpened)
            Column(
              children: List.generate(
                values.length,
                (i) => GestureDetector(
                  onTap: () {
                    controller.updateSize(
                      title: title,
                      listSetting: list,
                      value: values[i],
                    );
                    controller.updateUserSettings(
                      apiValue: list[index].fromAPI,
                      value: values[i],
                    );
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 18,
                    child: Text(
                      values[i].tr(),
                      style: AppStyles.text12
                          .andColor(values[i] == initialValue
                              ? AppColors.lightGreyText
                              : AppColors.plainText)
                          .andWeight(
                            FontWeight.w300,
                          ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
