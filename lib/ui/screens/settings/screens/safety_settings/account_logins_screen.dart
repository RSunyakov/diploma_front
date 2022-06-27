import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'account_logins_screen_controller.dart';

class AccountLoginsScreen extends StatexWidget<AccountLoginsScreenController> {
  AccountLoginsScreen({Key? key})
      : super(() => AccountLoginsScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) => const _AccountLoginsScreen();
}

class _AccountLoginsScreen extends GetView<AccountLoginsScreenController> {
  const _AccountLoginsScreen();

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
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          20.h,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'settings.sign_in_source',
              style: AppStyles.text16
                  .andWeight(FontWeight.w500)
                  .andColor(AppColors.plainText),
            ),
          ),
          10.h,
          AccountLoginItem(
              location: 'Moscow',
              lastLoginDate: '1 апреля',
              deviceName: 'IPhone 6',
              onTap: () => null),
          8.h,
          AccountLoginItem(
              location: 'Moscow',
              lastLoginDate: '30 марта',
              deviceName: 'IPhone 6',
              onTap: () => null),
          8.h,
          AccountLoginItem(
              location: 'Moscow',
              lastLoginDate: '11 марта',
              deviceName: 'IPhone 6',
              onTap: () => null),
          8.h,
        ]),
      ),
    );
  }
}

class AccountLoginItem extends StatelessWidget {
  const AccountLoginItem({
    Key? key,
    required this.location,
    required this.lastLoginDate,
    required this.deviceName,
    required this.onTap,
  }) : super(key: key);

  final String location;
  final String lastLoginDate;
  final String deviceName;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Image(image: AppIcons.location),
            8.w,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: AppStyles.text14
                      .andColor(AppColors.plainText)
                      .andWeight(FontWeight.w500),
                ),
                1.h,
                Row(
                  children: [
                    Text(
                      lastLoginDate,
                      style: AppStyles.text12.andColor(AppColors.lightGrey2),
                    ),
                    6.w,
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.lightGrey2),
                    ),
                    6.w,
                    Text(
                      deviceName,
                      style: AppStyles.text12.andColor(AppColors.lightGrey),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: onTap,
          child: svgPicture(AppIcons.arrowDown),
        )
      ],
    );
  }
}
