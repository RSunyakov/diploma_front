import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'settings_screen_controller.dart';

class SettingsScreen extends StatexWidget<SettingsScreenController> {
  SettingsScreen({Key? key})
      : super(() => SettingsScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) => const _SettingsScreen();
}

class _SettingsScreen extends GetView<SettingsScreenController> {
  const _SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(
        context,
        text: 'general.my_profile'.tr(),
        isLeading: true,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          25.h,
          for (var l in controller.listSettings)
            GestureDetector(
              onTap: l.onTap,
              child: Container(
                margin: EdgeInsets.only(bottom: 20.kH),
                padding: EdgeInsets.symmetric(horizontal: 23.kW),
                child: Text(
                  l.title.tr(),
                  style: AppStyles.text16,
                ),
              ),
            ),
          const Spacer(),
          Container(
            margin: EdgeInsets.only(bottom: 35.kH),
            padding: EdgeInsets.symmetric(horizontal: 23.kW),
            child: GestureDetector(
              onTap: controller.logout,
              child: Text(
                'general.logout'.tr(),
                style: AppStyles.text16.andColor(AppColors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
