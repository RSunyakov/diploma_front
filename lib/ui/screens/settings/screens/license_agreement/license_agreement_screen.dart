import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/app_colors.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'license_agreement_screen_controller.dart';

class LicenseAgreementScreen
    extends StatexWidget<LicenseAgreementScreenController> {
  LicenseAgreementScreen({Key? key})
      : super(() => LicenseAgreementScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) => const _LicenseAgreementScreen();
}

class _LicenseAgreementScreen
    extends GetView<LicenseAgreementScreenController> {
  const _LicenseAgreementScreen();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(
        context,
        text: 'Настройки',
        isLeading: true,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(27, 44, 21, 10),
        child: Text(
          'general.license_agreement'.tr(),
        ),
      ),
    );
  }
}
