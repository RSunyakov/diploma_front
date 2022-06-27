import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:bloc/bloc.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/post/skill.dart';
import 'package:sphere/logic/repository/repository.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

part 'skills_list_bloc.freezed.dart';

@prod
@lazySingleton
class SkillsListBloc extends Bloc<SkillsListEvent, SkillsListState> {
  SkillsListBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const SkillsListState.initial()) {
    on<_GetSkillsListEvent>(_getSkillsList);
  }

  final Repository _repo;

  Future _getSkillsList(
      _GetSkillsListEvent event, Emitter<SkillsListState> emit) async {
    emit(
      const SkillsListState.gotSkillsList(
        SkillsListStateData.loading(),
      ),
    );
    try {
      final rez = await _repo.getSkillsList();
      emit(SkillsListState.gotSkillsList(SkillsListStateData.result(rez)));
    } on Exception catch (e) {
      emit(SkillsListState.gotSkillsList(SkillsListStateData.result(
          left(ExtendedErrors.simple(e.toString())))));
    }
  }
}

@freezed
class SkillsListEvent with _$SkillsListEvent {
  const factory SkillsListEvent.getSkillsList() = _GetSkillsListEvent;
}

@freezed
class SkillsListState with _$SkillsListState {
  const factory SkillsListState.initial() = _Initial;

  const factory SkillsListState.gotSkillsList(
          SkillsListStateData<Either<ExtendedErrors, List<Skill>>> data) =
      _GotSkillsList;
}

@freezed
class SkillsListStateData<T> with _$SkillsListStateData<T> {
  const factory SkillsListStateData.initial() = _InitialData<T>;

  const factory SkillsListStateData.loading() = _LoadingData<T>;

  const factory SkillsListStateData.result(T data) = _ResultData<T>;
}
