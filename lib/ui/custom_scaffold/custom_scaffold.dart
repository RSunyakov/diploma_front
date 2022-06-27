import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere/ui/custom_scaffold/custom_scaffold_controller.dart';
import 'package:sphere/ui/router/router.dart';
import 'package:sphere/ui/router/router.gr.dart';
import 'package:sphere/ui/shared/app_colors.dart';
import 'package:sphere/ui/shared/app_extensions.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

class CustomScaffold extends StatexWidget<CustomScaffoldController> {
  CustomScaffold({Key? key, required this.child}) : super(() => CustomScaffoldController(), key: key);

  final Widget child;

  @override
  Widget buildWidget(BuildContext context) {

    return Scaffold(body: SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            ()=> Row(children:  [
              GestureDetector(
                onTap: () {
                  controller.currentIndex.value = 0;
                  AppRouter.push(TestRoute());
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.black, width: 1),
                    color: controller.currentIndex.value == 0 ? AppColors.buttonGreen : Colors.transparent
                  ),
                    padding: const EdgeInsets.all(10),
                    child: const Text('Тестирования')),
              ),
              5.w,
              GestureDetector(
                onTap: () {
                  controller.currentIndex.value = 1;
                  AppRouter.push(UserRoute());
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.black, width: 1),
                        color: controller.currentIndex.value == 1 ? AppColors.buttonGreen : Colors.transparent
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Text('Пользователи')),
              ),
              5.w,
              GestureDetector(onTap: () {
                controller.currentIndex.value = 2;
                AppRouter.push(SkillRoute());
              },
                child: Container(decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.black, width: 1),
                    color: controller.currentIndex.value == 2 ? AppColors.buttonGreen : Colors.transparent
                ),
                  padding: const EdgeInsets.all(10),
                  child: const Text('Навык'),
                ),
              )
            ],),
          ),
          child
        ],
      ),
    ),);
  }

}