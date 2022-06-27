import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/app_bar.dart';
import 'package:sphere/ui/shared/widgets/app_scaffold/app_scaffold.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';

import 'language_controller.dart';

class LanguageScreen extends StatexWidget<LanguageScreenController> {
  LanguageScreen({Key? key})
      : super(() => LanguageScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(
        context,
        text: 'general.changeLanguage'.tr(),
        isLeading: true,
      ),
      child: Obx(
        () {
          final locale = controller.mapLang.keys.toList();
          final language = controller.mapLang.values.toList();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < controller.mapLang.length; i++)
                  GestureDetector(
                    onTap: () => controller.changeLanguage(locale[i], context),
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          svgPicture(language[i].path),
                          10.w,
                          Text(
                            language[i].lang,
                            style: controller.selectedLang(locale[i])
                                ? AppStyles.text16.andWeight(FontWeight.bold)
                                : AppStyles.text14.andWeight(FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
