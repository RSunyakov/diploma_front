import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../shared/widgets/app_discolored_button.dart';
import '../../../../shared/widgets/app_pin_code_text_field.dart';
import 'change_phone_screen_controller.dart';

class ChangePhoneScreen extends StatexWidget<ChangePhoneScreenController> {
  ChangePhoneScreen({Key? key})
      : super(() => ChangePhoneScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) => const _ChangePhoneScreen();
}

class _ChangePhoneScreen extends GetView<ChangePhoneScreenController> {
  const _ChangePhoneScreen();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(
        context,
        text: 'general.cancel'.tr(),
        isLeading: true,
      ),
      child: SizedBox(
        height: Get.height,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          children: const [
            _EnterPhoneNumberForChange(isForOldPhone: true),
            _VerifyPin(isForOldPhone: true),
            _EnterPhoneNumberForChange(isForOldPhone: false),
            _VerifyPin(isForOldPhone: false),
            _Success()
          ],
        ),
      ),
    );
  }
}

class _VerifyPin extends GetView<ChangePhoneScreenController> {
  const _VerifyPin({required this.isForOldPhone, Key? key}) : super(key: key);

  final bool isForOldPhone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120.kH,
        ),
        svgPicture(AppIcons.phone),
        15.h,
        Text(
          'settings.change_phone_number'.tr(),
          style: AppStyles.text16.andColor(AppColors.plainText).andWeight(
                FontWeight.w500,
              ),
        ),
        10.h,
        Text(
          'general.sms_sent'.tr(),
        ),
        5.h,
        Text(
          isForOldPhone
              ? controller.oldPhoneTextEditingController.text
              : controller.newPhoneTextEditingController.text,
          style: AppStyles.text14.andColor(AppColors.mainColor),
        ),
        26.h,
        AppPinCodeTextField(
          onCompleted: (v) => controller.complete(v, isForOldPhone),
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

class _WaitForFetchCodeAgain extends GetViewSim<ChangePhoneScreenController> {
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

class _FetchCodeAgain extends GetViewSim<ChangePhoneScreenController> {
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

class _EnterPhoneNumberForChange
    extends GetViewSim<ChangePhoneScreenController> {
  const _EnterPhoneNumberForChange({required this.isForOldPhone, Key? key})
      : super(key: key);

  final bool isForOldPhone;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 120.kH,
      ),
      svgPicture(AppIcons.phone),
      15.h,
      Text(
        isForOldPhone
            ? 'settings.enter_phone'.tr()
            : 'settings.enter_new_phone'.tr(),
        style: AppStyles.text16.andColor(AppColors.plainText).andWeight(
              FontWeight.w500,
            ),
      ),
      14.h,
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 43.kW),
        child: Text('settings.phone_needed_for_actions'.tr(),
            textAlign: TextAlign.center,
            style: AppStyles.text12.andColor(AppColors.lightGrey)),
      ),
      15.h,
      AppInput(
        controller: isForOldPhone
            ? controller.oldPhoneTextEditingController
            : controller.newPhoneTextEditingController,
      ),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: isForOldPhone
            ? AppTextButton(
                onPressed: () => controller.fetchCode(isForOldPhone),
                text: 'general.apply'.tr(),
                width: 160,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppDiscoloredButton(
                    onPressed: () => controller.fetchCode(!isForOldPhone),
                    text: 'general.cancel'.tr(),
                    width: 120,
                  ),
                  AppTextButton(
                    onPressed: () => controller.fetchCode(isForOldPhone),
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

class _Success extends GetViewSim<ChangePhoneScreenController> {
  const _Success({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 70.kW),
      child: Column(children: [
        SizedBox(
          height: 120.kH,
        ),
        svgPicture(AppIcons.phone),
        15.h,
        Text(
          'settings.phone_changed'.tr(),
          textAlign: TextAlign.center,
          style: AppStyles.text16.andColor(AppColors.plainText).andWeight(
                FontWeight.w500,
              ),
        ),
        10.h,
        Text(
          controller.newPhoneTextEditingController.text,
          style: AppStyles.text14.andColor(AppColors.mainColor),
        ),
      ]),
    );
  }
}
