import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sphere/data/dto/question/question.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/domain/question/question.dart';
import 'package:sphere/domain/test/test.dart';
import 'package:sphere/ui/test/test_service.dart';
import 'package:vfx_flutter_common/get_rx_decorator.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

class TestScreenController extends StatexController {
  TestScreenController({
    TestService? service
}) : _service = service ?? Get.find();

   final TestService _service;

   GetRxDecorator<List<Test>> get tests => _service.tests;


   final testNameController = TextEditingController();

   var isCreateQuestion = false.obsDeco();

   var questionName = TextEditingController();

   var questionAnswer = TextEditingController();

   var isOpenAnswer = false.obsDeco();

   void addTest() {
      _service.addTest(AddTestBody(name: testNameController.text));
   }

   void addQuestion(Test test) {
      _service.addQuestions(test.id, [AddQuestionBody(question: questionName.text, answer: questionAnswer.text, open: isOpenAnswer.value)]);
      List<Question> questions = [];
      questions.addAll(test.questions);
      questions.add(Question(id: 0, question: questionName.text, answer: questionAnswer.text, open: isOpenAnswer.value));
      isOpenAnswer.value = false;
      questionName.clear();
      questionAnswer.clear();
      isCreateQuestion.value = false;
      var actualTest = Test(id: test.id, name: test.name, questions: questions);
      for (int i = 0; i < _service.tests.value.length; i++) {
         if (actualTest.id == _service.tests.value[i].id) {
            _service.tests.value[i] = actualTest;
            _service.tests.refresh();
         }
      }
   }
}