import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

import 'app_bottom_sheet_controller.dart';

/// Чтобы содержимое экрана могло отправлять динамические данные по высоте,
/// пришлось задействовать реактивный контроллер.
class AppBottomSheet extends StatexWidget<AppBottomSheetController> {
  AppBottomSheet({
    Key? key,
    required this.child,
    this.buttonMainText,
    this.buttonSecondText,
    this.onTapMainButton,
    this.onTapSecondButton,
    this.padding,
  }) : super(() => AppBottomSheetController(), key: key);

  final Widget child;
  final String? buttonMainText;
  final String? buttonSecondText;
  final Function()? onTapMainButton;
  final Function()? onTapSecondButton;
  final EdgeInsetsGeometry? padding;

  @override
  Widget buildWidget(BuildContext context) {
    /// высота "палочки-ручки над панелькой"
    final handlerHeight = 4.kH;

    final isMainButton = onTapMainButton != null;
    final isSecondButton = onTapSecondButton != null;
    return LayoutBuilder(
      builder: (ctx, ctr) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: const Offset(0, -10),
              child: Container(
                width: 47.kW,
                height: handlerHeight,
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
              ),
            ),
            //
            Obx(
              () => Container(
                width: Get.width,
                padding: const EdgeInsets.all(15),
                margin: EdgeInsets.only(
                  left: 5,
                  right: 5,
                  bottom: isMainButton ? 0 : 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                height: controller.height.value$ + handlerHeight,
                child: child,
              ),
            ),

            if (isSecondButton && isMainButton) ...[
              10.h,
              GestureDetector(
                onTap: onTapSecondButton,
                child: Container(
                  width: Get.width,
                  alignment: Alignment.center,
                  padding: padding ?? const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    buttonSecondText ?? 'general.cancel'.tr(),
                    style: AppStyles.text14,
                  ),
                ),
              ),
              10.h,
            ],
            if (isMainButton) ...[
              isSecondButton ? 0.h : 10.h,
              GestureDetector(
                onTap: onTapMainButton,
                child: Container(
                  width: Get.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    gradient: isSecondButton ? AppColors.stdVGradient : null,
                  ),
                  child: Text(
                    buttonMainText?.tr() ?? 'general.ok'.tr(),
                    style: AppStyles.text14.andColor(
                      isSecondButton ? AppColors.white : AppColors.plainText,
                    ),
                  ),
                ),
              ),
              10.h,
            ]
          ],
        );
      },
    );
  }
}

void chooseBottomSheet(BuildContext context, {required Widget child}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    // [isScrollControlled] + padding (or AnimatedPadding)
    // нужно для того, чтобы подымать панель при появлении клавы.
    isScrollControlled: true,
    builder: (_) {
      return AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AppBottomSheet(child: child),
      );
    },
  );
}
