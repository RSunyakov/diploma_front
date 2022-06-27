import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/data/dto/question/question.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/test/test.dart';
import 'package:sphere/logic/repository/repository.dart';

part 'test_bloc.freezed.dart';

@prod
@lazySingleton
class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc({Repository? repo})
    : _repo = repo ?? GetIt.I.get(),
  super(const TestState.initial()) {
    on<_GetTestListEvent>(_getTestList);
    on<_AddTestEvent>(_addTest);
    on<_AddQuestionsToTestEvent>(_addQuestions);
  }

  final Repository _repo;

  Future _getTestList(_GetTestListEvent event, Emitter<TestState> emit) async {
    emit(const TestState.gotTestList(TestStateData.loading()));
    try {
      final rez = await _repo.getTestList(event.adminId);
      emit(TestState.gotTestList(TestStateData.result(rez)));
    } on Exception catch (e) {
      emit(TestState.gotTestList(
          TestStateData.result(left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _addTest(_AddTestEvent event, Emitter<TestState> emit) async {
    emit (const TestState.addTest(TestStateData.loading()));
    final res = await _repo.addTest(event.value, event.adminId);
    emit(TestState.addTest(TestStateData.result(res)));
  }

  Future _addQuestions(_AddQuestionsToTestEvent event, Emitter<TestState> emit) async {
    emit (const TestState.addQuestionsToTest(TestStateData.loading()));
    final res = await _repo.addQuestionsToTest(event.testId, event.value);
    emit(TestState.addQuestionsToTest(TestStateData.result(res)));
  }
}

@freezed
class TestEvent with _$TestEvent {
  const factory TestEvent.addTest(AddTestBody value, int adminId) = _AddTestEvent;

  const factory TestEvent.getTestList(int adminId) = _GetTestListEvent;

  const factory TestEvent.addQuestionsToTest(int testId, List<AddQuestionBody> value) = _AddQuestionsToTestEvent;
}

@freezed
class TestState with _$TestState {
  const factory TestState.initial() = _Initial;

  const factory TestState.addTest(
      TestStateData<Either<ExtendedErrors, Test>> data) = _AddTest;

  const factory TestState.gotTestList(
      TestStateData<Either<ExtendedErrors, List<Test>>> data) = _GotTestList;

  const factory TestState.addQuestionsToTest(
      TestStateData<Either<ExtendedErrors, Test>> data) = _AddQuestionsToTest;
}

@freezed
class TestStateData<T> with _$TestStateData<T> {
  const factory TestStateData.initial() = _InitialData<T>;

  const factory TestStateData.loading() = _LoadingData<T>;

  const factory TestStateData.result(T data) = _ResultData<T>;
}
