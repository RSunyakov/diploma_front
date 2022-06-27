import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'two_fa_verification_screen_controller.dart';

class TwoFAVerificationScreen
    extends StatexWidget<TwoFAVerificationScreenController> {
  TwoFAVerificationScreen({Key? key})
      : super(() => TwoFAVerificationScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) => const _TwoFAVerificationScreen();
}

class _TwoFAVerificationScreen
    extends GetView<TwoFAVerificationScreenController> {
  const _TwoFAVerificationScreen();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(
        context,
        text: 'settings.safety'.tr(),
        isLeading: true,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(children: [
          132.h,
          svgPicture(AppIcons.phone),
          12.h,
          Text(
            'settings.two_factor_authentication'.tr(),
            textAlign: TextAlign.center,
            style: AppStyles.text16
                .andWeight(FontWeight.w500)
                .andColor(AppColors.plainText),
          ),
          17.h,
          Text(
            'settings.protect_your_account'.tr(),
            textAlign: TextAlign.center,
            style: AppStyles.text11.andColor(AppColors.plainText),
          ),
          17.h,
          Text(
            'settings.use_code'.tr(),
            textAlign: TextAlign.center,
            style: AppStyles.text11.andColor(AppColors.plainText),
          ),
          const Spacer(),
          AppTextButton(
            text: 'general.ok'.tr(),
            width: 160,
            onPressed: () {},
          ),
          44.h,
        ]),
      ),
    );
  }
}
