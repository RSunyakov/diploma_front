import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../shared/widgets/app_discolored_button.dart';
import '../../../../shared/widgets/app_pin_code_text_field.dart';
import 'change_email_screen_controller.dart';

class ChangeEmailScreen extends StatexWidget<ChangeEmailScreenController> {
  ChangeEmailScreen(
      {required this.isBindEmail, required this.oldEmail, Key? key})
      : super(() => ChangeEmailScreenController(isBindEmail), key: key);

  final bool isBindEmail;
  final String oldEmail;

  @override
  Widget buildWidget(BuildContext context) =>
      _ChangeEmailScreen(isBindEmail, oldEmail);
}

class _ChangeEmailScreen extends GetView<ChangeEmailScreenController> {
  const _ChangeEmailScreen(this.isBindEmail, this.oldEmail);

  final bool isBindEmail;
  final String oldEmail;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(
        context,
        text: 'settings.common'.tr(),
        isLeading: true,
      ),
      child: SizedBox(
        height: Get.height,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          children: [
            if (isBindEmail)
              _VerifyPin(isForOldEmail: true, oldEmail: oldEmail),
            _EnterEmailForChange(isBindEmail, oldEmail),
            _VerifyPin(isForOldEmail: false, oldEmail: oldEmail),
            _Success(isBindEmail)
          ],
        ),
      ),
    );
  }
}

class _VerifyPin extends GetView<ChangeEmailScreenController> {
  const _VerifyPin(
      {required this.isForOldEmail, required this.oldEmail, Key? key})
      : super(key: key);

  final bool isForOldEmail;
  final String oldEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 144.kH,
        ),
        Text(
          'settings.change_mail'.tr(),
          style: AppStyles.text16.andColor(AppColors.plainText).andWeight(
                FontWeight.w500,
              ),
        ),
        10.h,
        Text(
          isForOldEmail
              ? 'settings.approve_current_mail'.tr()
              : 'settings.approve_new_mail'.tr(),
        ),
        5.h,
        Text(
          isForOldEmail
              ? oldEmail
              : controller.newEmailTextEditingController.text,
          style: AppStyles.text14.andColor(AppColors.mainColor),
        ),
        26.h,
        AppPinCodeTextField(
          onCompleted: (v) => controller.complete(v, isForOldEmail),
          padding: EdgeInsets.symmetric(horizontal: 55.kW),
        ),
        23.h,
        Obx(() => controller.allowCodeFetch.value$
            ? const _FetchCodeAgain()
            : const _WaitForFetchCodeAgain()),
      ],
    );
  }
}

class _WaitForFetchCodeAgain extends GetViewSim<ChangeEmailScreenController> {
  const _WaitForFetchCodeAgain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: c.fetchCodeAgain,
      child: Obx(
        () => RichText(
          text: TextSpan(
              text: 'general.fetch_code_again_in'.tr(),
              style: const TextStyle(
                color: Color(0xffB7B6B6),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                    text: 'general.passed_seconds'
                        .tr(args: [c.countdownValue.value$.toString()]),
                    style: const TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )),
              ]),
        ),
      ),
    );
  }
}

class _FetchCodeAgain extends GetViewSim<ChangeEmailScreenController> {
  const _FetchCodeAgain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: c.fetchCodeAgain,
      child: Text(
        'general.fetch_code_again'.tr(),
        style: const TextStyle(
          color: AppColors.mainColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _EnterEmailForChange extends GetViewSim<ChangeEmailScreenController> {
  const _EnterEmailForChange(this.isBindEmail, this.oldEmail, {Key? key})
      : super(key: key);

  final bool isBindEmail;
  final String oldEmail;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 144.kH,
      ),
      Text(
        isBindEmail ? 'settings.change_mail'.tr() : 'settings.bind_mail'.tr(),
        style: AppStyles.text16.andColor(AppColors.plainText).andWeight(
              FontWeight.w500,
            ),
      ),
      10.h,
      AppInput(
        controller: controller.newEmailTextEditingController,
        hintText: isBindEmail
            ? 'settings.enter_new_mail'.tr()
            : 'settings.enter_mail'.tr(),
      ),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppDiscoloredButton(
              onPressed: () => isBindEmail
                  ? controller.fetchCode(true, oldEmail)
                  : controller.back(),
              text: 'general.cancel'.tr(),
              width: 120,
            ),
            AppTextButton(
              onPressed: () => controller.fetchCode(false, oldEmail),
              text: 'general.ok'.tr(),
              width: 120,
            ),
          ],
        ),
      ),
      SizedBox(
        height: 53.kH,
      ),
    ]);
  }
}

class _Success extends GetViewSim<ChangeEmailScreenController> {
  const _Success(this.isBindEmail, {Key? key}) : super(key: key);

  final bool isBindEmail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 70.kW),
      child: Column(children: [
        SizedBox(
          height: 144.kH,
        ),
        Text(
          isBindEmail
              ? 'settings.mail_changed'.tr()
              : 'settings.mail_bound'.tr(),
          textAlign: TextAlign.center,
          style: AppStyles.text16.andColor(AppColors.plainText).andWeight(
                FontWeight.w500,
              ),
        ),
        10.h,
        Text(
          controller.newEmailTextEditingController.text,
          style: AppStyles.text14.andColor(AppColors.mainColor),
        ),
      ]),
    );
  }
}
