import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/data/dto/question/question.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/question/question.dart';
import 'package:sphere/logic/repository/repository.dart';

part 'question_bloc.freezed.dart';

@prod
@lazySingleton
class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc({Repository? repo})
  : _repo = repo ?? GetIt.I.get(),
    super(const QuestionState.initial()) {
    on<_GetQuestionListEvent>(_getQuestionList);
    on<_AddQuestionEvent>(_addQuestion);
  }

  final Repository _repo;

  Future _getQuestionList(_GetQuestionListEvent event, Emitter<QuestionState> emit) async {
    emit(const QuestionState.gotQuestionList(QuestionStateData.loading()));
    try {
      final rez = await _repo.getQuestionList();
      emit(QuestionState.gotQuestionList(QuestionStateData.result(rez)));
    } on Exception catch (e) {
      emit(QuestionState.gotQuestionList(QuestionStateData.result(left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _addQuestion(_AddQuestionEvent event, Emitter<QuestionState> emit) async {
    emit (const QuestionState.addQuestion(QuestionStateData.loading()));
    final res = await _repo.addQuestion(event.value);
    emit(QuestionState.addQuestion(QuestionStateData.result(res)));
  }
}

@freezed
class QuestionEvent with _$QuestionEvent {

  const factory QuestionEvent.getQuestionList() = _GetQuestionListEvent;

  const factory QuestionEvent.addQuestion(AddQuestionBody value) = _AddQuestionEvent;
}

@freezed
class QuestionState with _$QuestionState {
  const factory QuestionState.initial() = _Initial;

  const factory QuestionState.gotQuestionList(
      QuestionStateData<Either<ExtendedErrors, List<Question>>> data) = _GotQuestionList;

  const factory QuestionState.addQuestion(
      QuestionStateData<Either<ExtendedErrors, Question>> data
      ) = _AddQuestion;
}

@freezed
class QuestionStateData<T> with _$QuestionStateData<T> {
  const factory QuestionStateData.initial() = _InitialData<T>;

  const factory QuestionStateData.loading() = _LoadingData<T>;

  const factory QuestionStateData.result(T data) = _ResultData<T>;
}
