import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'general_settings_screen_controller.dart';

class GeneralSettingsScreen
    extends StatexWidget<GeneralSettingsScreenController> {
  GeneralSettingsScreen({Key? key})
      : super(() => GeneralSettingsScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) => const _GeneralSettingsScreen();
}

class _GeneralSettingsScreen extends GetView<GeneralSettingsScreenController> {
  const _GeneralSettingsScreen();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(
        context,
        text: 'general.settings'.tr(),
        isLeading: true,
      ),
      child: Obx(
        () => Column(
          children: [
            _GeneralSettingItem(
                title: 'general.mail'.tr(),
                value: controller.email$,
                onTap: controller.changeEmail),
            _GeneralSettingItem(
                title: 'general.phone'.tr(),
                value: controller.phone$,
                onTap: controller.changePhone),
          ],
        ),
      ),
    );
  }
}

class _GeneralSettingItem extends StatelessWidget {
  const _GeneralSettingItem({
    Key? key,
    required this.title,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            title,
            style: AppStyles.text16.andColor(AppColors.plainText).andWeight(
                  FontWeight.w500,
                ),
          ),
          5.h,
          Text(value, style: AppStyles.text12.andColor(AppColors.plainText)),
        ]),
        GestureDetector(
          onTap: onTap,
          child: Text(
              value.isNotEmpty ? 'general.change'.tr() : 'general.bind'.tr(),
              style: AppStyles.text14.andColor(AppColors.link)),
        )
      ]),
    );
  }
}
