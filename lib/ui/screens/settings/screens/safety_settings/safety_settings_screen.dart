import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'safety_settings_screen_controller.dart';

class SafetySettingsScreen
    extends StatexWidget<SafetySettingsScreenController> {
  SafetySettingsScreen({Key? key})
      : super(() => SafetySettingsScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) => const _SafetySettingsScreen();
}

class _SafetySettingsScreen extends GetView<SafetySettingsScreenController> {
  const _SafetySettingsScreen();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(
        context,
        text: 'general.settings'.tr(),
        isLeading: true,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          20.h,
          InkWell(
            onTap: controller.toAccountLogins,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'settings.sign_in_history'.tr(),
                  style: AppStyles.text16
                      .andWeight(FontWeight.w500)
                      .andColor(AppColors.plainText),
                ),
                svgPicture(AppIcons.rightArrow, color: AppColors.mainColor),
              ],
            ),
          ),
          // 20.h,
          // InkWell(
          //   onTap: controller.to2FAVerification,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'Двухфакторная аутентификация',
          //         style: AppStyles.text16
          //             .andWeight(FontWeight.w500)
          //             .andColor(AppColors.plainText),
          //       ),
          //       svgPicture(AppIcons.rightArrow, color: AppColors.mainColor),
          //     ],
          //   ),
          // ),
          10.h,
        ]),
      ),
    );
  }
}
