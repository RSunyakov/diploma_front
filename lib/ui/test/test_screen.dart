import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sphere/ui/custom_scaffold/custom_scaffold.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/app_input.dart';
import 'package:sphere/ui/shared/widgets/app_switch_container.dart';
import 'package:sphere/ui/test/test_screen_controller.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

import '../../domain/test/test.dart';

class TestScreen extends StatexWidget<TestScreenController> {
  TestScreen({Key? key})
  : super(() => TestScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) {
    return CustomScaffold(
      child: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, top: 50, right: 50, bottom: 50),
          child: Column(children: [
            const Text("Добро пожаловать в сервис для создания кроссплатформенного навыка", style: AppStyles.text25,),
            10.h,
            Obx(() {
              if (controller.tests.value.isEmpty) {
                return const Text("Для начала работы необходимо создать тестирование и добавить туда вопросы", style: AppStyles.text22,);
              } else {
                return Container();
              }
            },
            ),
            50.h,
            Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                boxShadow: AppColors.boxShadow),
              width: 800,
              //height: 1000,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Text('Создание тестирования', style: AppStyles.text18,),
                  10.h,
                  SizedBox(width: 300, child: AppInput(
                    controller: controller.testNameController,
                    hintText: 'Название тестирования', )),
                  10.h,
                  GestureDetector(
                    onTap: () => controller.addTest(),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50)

                      ),
                      padding: const EdgeInsets.all(5),
                      child: Text('Создать', style: AppStyles.text14.andColor(AppColors.white)),),
                  ),
                  20.h,
                  Obx(() {
                    if (controller.tests.value.isNotEmpty) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [Text('Вам доступны следующие тестирования: ', style: AppStyles.text18.andWeight(FontWeight.w500),),
                        10.h,
                        Flexible(
                          child: ListView.builder(itemCount: controller.tests.value.length, shrinkWrap: true, itemBuilder: (context, index) {
                            final currentTest = controller.tests.value[index];
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: AppColors.plainText, width: 2)
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: ExpandablePanel(header: Text('Тестирование: ${currentTest.name}', style: AppStyles.text14,), collapsed: Text('Содержит ${currentTest.questions.length} вопросов', style: AppStyles.text12),
                                      expanded: currentTest.questions.isEmpty ? Column(
                                    children: [
                                      const Text('У данного тестирования нет вопросов', style: AppStyles.text12),
                                      10.h, CreateQuestionButton(test: currentTest,),
                                    ],
                                  ) : Column(
                                    children: [
                                      ListView.builder(shrinkWrap: true, itemCount: currentTest.questions.length,
                                          itemBuilder: (questionContext, questionIndex) {
                                            final currentQuestion = currentTest.questions[questionIndex];
                                            return Column(
                                              children: [
                                                Column(children: [
                                                  Text('Вопрос: ${currentQuestion.question}', style: AppStyles.text12),
                                                  5.h,
                                                  Text('Ответ: ${currentQuestion.answer}', style: AppStyles.text12),
                                                  5.h,
                                                  Text('Открытый? ${currentQuestion.open}', style: AppStyles.text12)
                                                ],),
                                                10.h,
                                              ],
                                            );
                                          }),
                                      10.h,
                                      CreateQuestionButton(test: currentTest,),
                                    ],
                                  )),
                                ),
                            10.h,
                              ],
                            );
                          }),
                        )],);
                    }
                    else {
                      return Container();
                    }
                  }),
                ],
              ),),
          ],),
        ),
      ),
    ),);
  }

}

class CreateQuestion extends GetViewSim<TestScreenController> {
  const CreateQuestion({Key? key, required this.test}) : super(key: key);

  final Test test;

  @override
  Widget build(BuildContext context) {
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
          child: svgPicture(AppIcons.close, onTap: () => controller.isCreateQuestion.value = false)),
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Вопрос:', style: AppStyles.text14,),
          4.w,
          SizedBox(
            width: 300,
            child: AppInput(
              controller: controller.questionName, hintText: 'Введите вопрос',),
          )
        ],
      ),
      5.h,
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        const Text('Ответ:', style: AppStyles.text14,),
        5.w,
        SizedBox(
          width: 300,
          child: AppInput(
            controller: controller.questionAnswer, hintText: 'Введите ответ',),
        )
      ],),
      10.h,

      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        const Text('С открытым ответом?', style: AppStyles.text14,),
        Obx(() => AppSwitchContainer(value: controller.isOpenAnswer.value, onChanged: (v) => controller.isOpenAnswer.value = v, title: '',)),
      ],),
        20.h,
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.green
          ),
          child: GestureDetector(onTap: () => controller.addQuestion(test), child: Text('Создать вопрос', style: AppStyles.text14.andColor(AppColors.white))),
        ),
    ],),
    );
  }

}

class CreateQuestionButton extends GetViewSim<TestScreenController> {
  const CreateQuestionButton({Key? key, required this.test}) : super(key: key);

  final Test test;

  @override
  Widget build(BuildContext context) {
   return  Column(
     children: [
       Obx(
         () {
           if (!controller.isCreateQuestion.value) {
             return Align(
               alignment: Alignment.bottomRight,
               child: Container(
                 width: 150,
                 padding: const EdgeInsets.all(10),
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(50),
                     color: Colors.green
                 ),
                 child: GestureDetector(
                     onTap: () => controller.isCreateQuestion.value = true,
                     child: Text('Добавить вопрос',
                         style: AppStyles.text14.andColor(AppColors.white))),
               ),
             );
           }
           return Container();
         },
       ),
       10.h,
       Obx(() {
         if (controller.isCreateQuestion.value) {
           return CreateQuestion(test: test,);
         } else {
           return Container();
         }
       })
     ],
   );
  }

}