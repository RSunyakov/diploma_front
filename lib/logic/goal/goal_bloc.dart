import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/data/dto/posts/goal.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/post/goal.dart';
import 'package:sphere/logic/repository/repository.dart';

part 'goal_bloc.freezed.dart';

@prod
@lazySingleton
class GoalBloc extends Bloc<GoalEvent, GoalState> {
  GoalBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const GoalState.initial()) {
    on<_GetGoalEvent>(_getGoal);
    on<_StoreGoalEvent>(_storeGoal);
    on<_GetGoalListEvent>(_getGoalList);
  }
  final Repository _repo;

  Future _getGoal(_GetGoalEvent event, Emitter<GoalState> emit) async {
    emit(const GoalState.gotGoal(
      GoalStateData.loading(),
    ));
    try {
      final rez = await _repo.showGoal(event.goalId);
      emit(GoalState.gotGoal(GoalStateData.result(rez)));
    } on Exception catch (e) {
      emit(GoalState.gotGoal(
          GoalStateData.result(left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _getGoalList(_GetGoalListEvent event, Emitter<GoalState> emit) async {
    emit(const GoalState.gotGoalList(GoalStateData.loading()));
    try {
      final rez = await _repo.getGoalList(event.perPage);
      emit(GoalState.gotGoalList(GoalStateData.result(rez)));
    } on Exception catch (e) {
      emit(GoalState.gotGoalList(
          GoalStateData.result(left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _storeGoal(_StoreGoalEvent event, Emitter<GoalState> emit) async {
    emit(const GoalState.storeGoal(GoalStateData.loading()));
    final res = await _repo.storeGoal(event.value);
    emit(GoalState.storeGoal(GoalStateData.result(res)));
    emit(const GoalState.storedGoal());
  }
}

@freezed
class GoalEvent with _$GoalEvent {
  const factory GoalEvent.getGoal(int goalId) = _GetGoalEvent;

  const factory GoalEvent.storeGoal(AddGoalBody value) = _StoreGoalEvent;

  const factory GoalEvent.getGoalList(int? perPage) = _GetGoalListEvent;
}

@freezed
class GoalState with _$GoalState {
  const factory GoalState.initial() = _Initial;

  const factory GoalState.gotGoal(
      GoalStateData<Either<ExtendedErrors, Goal>> data) = _GotGoal;

  const factory GoalState.storeGoal(
      GoalStateData<Either<ExtendedErrors, int>> data) = _StoreGoal;

  const factory GoalState.storedGoal() = _StoredGoal;

  const factory GoalState.gotGoalList(
      GoalStateData<Either<ExtendedErrors, List<Goal>>> data) = _GotGoalList;
}

@freezed
class GoalStateData<T> with _$GoalStateData<T> {
  const factory GoalStateData.initial() = _InitialData<T>;

  const factory GoalStateData.loading() = _LoadingData<T>;

  const factory GoalStateData.result(T data) = _ResultData<T>;
}
