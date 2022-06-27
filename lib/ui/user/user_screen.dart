import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sphere/ui/custom_scaffold/custom_scaffold.dart';
import 'package:sphere/ui/shared/app_colors.dart';
import 'package:sphere/ui/shared/app_extensions.dart';
import 'package:sphere/ui/shared/app_icons.dart';
import 'package:sphere/ui/shared/app_styles.dart';
import 'package:sphere/ui/user/user_screen_controller.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

class UserScreen extends StatexWidget<UserScreenController> {
  UserScreen({Key? key}) : super(() => UserScreenController(), key: key);
  @override
  Widget buildWidget(BuildContext context) {
    return CustomScaffold(child: SingleChildScrollView(
      child: Center(child: Padding(
        padding: const EdgeInsets.only(left: 50, top: 50, right: 50, bottom: 50),
        child: Column(children: [
          const Text("Добро пожаловать в сервис для создания кроссплатформенного навыка", style: AppStyles.text25,),
          50.h,
          Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
              boxShadow: AppColors.boxShadow),
            width: 800,
            padding: const EdgeInsets.all(15),
            child: Column(children: [
              Align(alignment: Alignment.topRight, child: GestureDetector(onTap: () => controller.refreshUsers(), child: Text('Обновить', style: AppStyles.text14,))),
              10.h,
              const Text('Зарегистрировавшиеся пользователи: ', style: AppStyles.text18,),
              10.h,
              Obx(
                ()=> ListView.builder(shrinkWrap: true, itemCount: controller.users.value.length, itemBuilder: (context, index) {
                  final currentUser = controller.users.value[index];
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.plainText, width: 2),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        padding: const EdgeInsets.all(10),
                        child: ExpandablePanel(header: Text('${currentUser.firstName} ${currentUser.lastName}', style: AppStyles.text12,), collapsed: Text('Пользователю доступно ${currentUser.tests.length} тестирований', style: AppStyles.text12,),
                        expanded: currentUser.tests.isEmpty ? Column(
                          children: [
                            const Text('У данного пользователя не назначены тестирования', style: AppStyles.text12,),
                            10.h,
                            AddTestButton(userId: currentUser.userId,),
                          ],
                        ) : Column(
                          children: [
                            ListView.builder(itemCount: currentUser.tests.length, shrinkWrap: true, itemBuilder: (testContext, testIndex) {
                              final currentTest = currentUser.tests[testIndex];
                              return Column(
                                children: [
                                  Column(
                                    children: [Text('Тестирование: ${currentTest.name}', style: AppStyles.text12,),
                                                Text('Количество вопросов: ${currentTest.questions.length}')],
                                  ),
                                  10.h,
                                ],
                              );
                            }),
                            15.h,
                            AddTestButton(userId: currentUser.userId,),
                          ],
                        ))
                      ),
                      10.h,
                    ],
                  );
                }),
              )
            ],),
          )
        ],),
      ),),
    ));
  }
}

class AddTestButton extends GetViewSim<UserScreenController> {
  const AddTestButton({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
   return Column(children: [
     Obx(() {
       if (!controller.isAddTest.value) {
         return Container(
           width: 150,
           padding: const EdgeInsets.all(10),
           decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(50),
               color: Colors.green
           ),
           child: GestureDetector(
               onTap: () => controller.isAddTest.value = true,
               child: Text('Добавить тестирование',
                   style: AppStyles.text14.andColor(AppColors.white))),
         );
       } else {
         return Container(
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(15),
             border: Border.all(color: AppColors.plainText, width: 1)
           ),
           width: 500,
           padding: const EdgeInsets.all(10),
           child: Column(
             children: [
               Align(alignment: Alignment.topRight,
                   child: svgPicture(AppIcons.close, onTap: () => controller.isAddTest.value = false)),
               5.h,
               ListView.builder(itemCount: controller.tests.value.length, shrinkWrap: true, itemBuilder: (context, index) {
                 final currentTest = controller.tests.value[index];
                 return Column(
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                       Text('Тестирование: ${currentTest.name}'),
                       5.w,
                       GestureDetector(
                         onTap: () => controller.addTestsToUser(userId, currentTest),
                         child: Container(
                           padding: const EdgeInsets.all(10),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(50),
                             color: Colors.green
                           ),
                           child: Text('Добавить тестирование', style: AppStyles.text14.andColor(AppColors.white),),
                         ),
                       )
                     ],),
                     10.h,
                   ],
                 );
               }),
             ],
           ),
         );
       }
     })
   ],);
  }

}