import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/router/router.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:sphere/ui/shared/widgets/app_bottom_sheet/app_bottom_sheet_controller.dart';
import 'package:vfx_flutter_common/utils.dart';

class AppCameraGalleryBottomSheet extends StatelessWidget {
  const AppCameraGalleryBottomSheet({
    Key? key,
    required this.onTapPhoto,
    required this.onTapGallery,
  }) : super(key: key);

  final Function() onTapPhoto;
  final Function() onTapGallery;

  @override
  Widget build(BuildContext context) {
    delayMilli(AppConsts.delayForEscapeVisualConflict).then((_) {
      final bottomCtrl = Get.find<AppBottomSheetController>();
      bottomCtrl.height.value = 80;
    });
    return AppBottomSheet(
      onTapMainButton: () => AppRouter.pop(),
      buttonMainText: 'general.cancel'.tr(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                svgPicture(AppIcons.camera, height: 16),
                17.w,
                GestureDetector(
                  onTap: () {
                    onTapPhoto();
                    AppRouter.pop();
                  },
                  child: Text(
                    'general.camera'.tr(),
                    style: AppStyles.text14
                        .andColor(AppColors.plainText)
                        .andWeight(FontWeight.w600),
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1, color: AppColors.dividerColor),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                svgPicture(AppIcons.gallery, height: 20),
                17.w,
                GestureDetector(
                  onTap: () {
                    onTapGallery();
                    AppRouter.pop();
                  },
                  child: Text(
                    'general.gallery'.tr(),
                    style: AppStyles.text14
                        .andColor(AppColors.plainText)
                        .andWeight(FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
