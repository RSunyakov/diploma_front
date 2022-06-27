import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere/ui/question/question_screen_controller.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

class QuestionScreen extends StatexWidget<QuestionScreenController> {
  QuestionScreen({Key? key})
    : super(() => QuestionScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) {
   return Scaffold(body: SingleChildScrollView(
     child: Center(
       child: Padding(
         padding: const EdgeInsets.only(left: 50, top: 50, right: 50, bottom: 50),
         child: Column(children: [
           const Text("Добро пожаловать в сервис для создания кроссплатформенного навыка", style: AppStyles.text25,),
           10.h,
           const Text("Для начала работы необходимо создать тестирование и добавить туда вопросы", style: AppStyles.text22,),
           50.h,
           Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
           boxShadow: AppColors.boxShadow),
           width: 400,
           height: 400,
             padding: const EdgeInsets.all(15),
             child: Column(
               children: [
                 const Text('Создание тестирования', style: AppStyles.text18,),
                 10.h,
                 SizedBox(width: 300, child: AppInput(hintText: 'Название тестирования', )),
                 10.h,
                 Container(
                   decoration: BoxDecoration(
                     color: Colors.green,
                     borderRadius: BorderRadius.circular(50)

                   ),
                   padding: const EdgeInsets.all(5),
                   child: Text('Создать', style: AppStyles.text14.andColor(AppColors.white)),),
                 10.h,
                 Obx(() => ListView.builder(itemCount: controller.questions.value.length, shrinkWrap: true, itemBuilder: (context, index) {
                   final question = controller.questions.value[index];
                   return Column(
                     children: [
                       Text(question.question),
                       Text(question.answer),
                       Text('${question.open}'),
                     ],
                   );
                 },))
               ],
             ),),
         ],),
       ),
     ),
   ),);
  }

}