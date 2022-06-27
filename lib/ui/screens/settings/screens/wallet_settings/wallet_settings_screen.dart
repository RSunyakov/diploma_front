import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sphere/ui/shared/app_colors.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import 'wallet_settings_screen_controller.dart';

class WalletSettingsScreen
    extends StatexWidget<WalletSettingsScreenController> {
  WalletSettingsScreen({Key? key})
      : super(() => WalletSettingsScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) => const _WalletSettingsScreen();
}

class _WalletSettingsScreen extends GetView<WalletSettingsScreenController> {
  const _WalletSettingsScreen();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(
        context,
        text: 'general.settings'.tr(),
        isLeading: true,
      ),
      child: Center(
        child: Text('general.under_construction'.tr()),
      ),
    );
  }
}
