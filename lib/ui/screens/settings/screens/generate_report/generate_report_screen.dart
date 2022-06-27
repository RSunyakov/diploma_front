import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/app_colors.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'generate_report_screen_controller.dart';

class GenerateReportScreen
    extends StatexWidget<GenerateReportScreenController> {
  GenerateReportScreen({Key? key})
      : super(() => GenerateReportScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) => const _GenerateReportScreen();
}

class _GenerateReportScreen extends GetView<GenerateReportScreenController> {
  const _GenerateReportScreen();

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
