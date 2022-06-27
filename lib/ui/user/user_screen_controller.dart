import 'package:get/get.dart';
import 'package:sphere/data/dto/question/question.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/domain/test/test.dart';
import 'package:sphere/domain/users/user_domain.dart';
import 'package:sphere/ui/test/test_service.dart';
import 'package:sphere/ui/user/user_screen_service.dart';
import 'package:vfx_flutter_common/get_rx_decorator.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

class UserScreenController extends StatexController {
  UserScreenController({UserScreenService? service, TestService? testService})
      : _service = service ?? Get.find(),
        _testService = testService ?? Get.find();

  final UserScreenService _service;

  final TestService _testService;

  GetRxDecorator<List<UserDomain>> get users => _service.users;

  GetRxDecorator<List<Test>> get tests => _testService.tests;

  var isAddTest = false.obsDeco();

  void addTestsToUser(String userId, Test test) {
    var testDataDto = TestDataDto(
        id: test.id,
        name: test.name,
        questions: test.questions
            .map((e) => QuestionDataDto(
                id: e.id, question: e.question, answer: e.answer, open: e.open))
            .toList());
    _service.addTestsToUser(userId, [testDataDto]);
    isAddTest.value = false;
  }

  void refreshUsers() {
    _service.getUsers();
  }
}
