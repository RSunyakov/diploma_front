import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/core/utils/stream_subscriber.dart';
import 'package:sphere/data/dto/question/question.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/test/test.dart';
import 'package:sphere/logic/test/test_bloc.dart';
import 'package:sphere/ui/login/login_service.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:vfx_flutter_common/get_rx_decorator.dart';

class TestService extends GetxService with StreamSubscriberMixin {
  TestService({
    TestBloc? testBloc,
    LoginService? loginService
}) :  _testBloc = testBloc ?? GetIt.I.get(),
      _loginService = loginService ?? Get.find();

  final TestBloc _testBloc;

  final LoginService _loginService;

  final tests = <Test>[].obsDeco();


  @override
  void onInit() {
    super.onInit();
    subscribeIt(_testBloc.stream.listen(_processTest));
    getTests();
  }

  void _processTest(TestState state) {
    state.maybeWhen(orElse: () => left(ExtendedErrors.empty),
    gotTestList: (d) => d.maybeWhen(orElse: () => left(ExtendedErrors.empty()),
    result: (r) {
      r.fold((l) => appAlert(value: l.error, color: AppColors.red), (r) => tests.value = r);
    }),
    addTest: (d) => d.maybeWhen( orElse: () => left(ExtendedErrors.empty()),
        result: (r) => r.fold(
                (l) => appAlert(value: l.error, color: AppColors.red),
                (r) {
                  tests.value.add(r);
                  tests.refresh();
                })),
    addQuestionsToTest: (d) => d.maybeWhen(orElse: () => left(ExtendedErrors.empty()),
    result: (r) => r.fold((l) => appAlert(value: l.error, color: AppColors.red), (r) {
      for (int i = 0; i < tests.value.length; i++) {
        if (tests.value[i].id == r.id) {
          tests.value[i] = r;
      }
    }})));
  }

  void addTest(AddTestBody value) {
    _testBloc.add(TestEvent.addTest(value, _loginService.admin.value.id));
  }

  void getTests() {
    _testBloc.add(TestEvent.getTestList(_loginService.admin.value.id));
  }

  void addQuestions(int testId, List<AddQuestionBody> value) {
    _testBloc.add(TestEvent.addQuestionsToTest(testId, value));
  }

}