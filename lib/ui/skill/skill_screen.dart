import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sphere/ui/custom_scaffold/custom_scaffold.dart';
import 'package:sphere/ui/shared/app_colors.dart';
import 'package:sphere/ui/shared/app_extensions.dart';
import 'package:sphere/ui/shared/app_styles.dart';
import 'package:sphere/ui/skill/skill_screen_controller.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

class SkillScreen extends StatexWidget<SkilLScreenController> {
  SkillScreen({Key? key})
  : super(() => SkilLScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) {
    return CustomScaffold(child: SingleChildScrollView(child: Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 50, top: 50, right: 50, bottom: 50),
        child: Column(children: [
          const Text("Добро пожаловать в сервис для создания кроссплатформенного навыка", style: AppStyles.text25,),
          50.h,
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                boxShadow: AppColors.boxShadow),
            width: 800,
            //height: 1000,
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Text('Webhook URL', style: AppStyles.text18,),
                10.h,
                Obx(() {
                  if (controller.showUrl.value) {
                    return Column(children: [
                      SelectableText('URL для Яндекс.Алисы: ${controller.webhook.value.aliceUrl}', style: AppStyles.text18,),
                      10.h,
                      SelectableText('URL для Маруси: ${controller.webhook.value.marusiaUrl}', style: AppStyles.text18,),
                      10.h,
                      SelectableText('URL для Сбера: ${controller.webhook.value.sberUrl}', style: AppStyles.text18,),
                      10.h,
                    ],);
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.green,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(onTap: () => controller.showButton(), child: Text('Получить URL', style: AppStyles.text14.andColor(AppColors.white),)),
                    );
                  }
                })
              ],
            ),
          ),
        ],),
      ),
    ),));
  }
}