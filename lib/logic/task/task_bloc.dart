import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/data/dto/posts/task.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/post/task.dart';
import 'package:sphere/logic/repository/repository.dart';

part 'task_bloc.freezed.dart';

@prod
@lazySingleton
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const TaskState.initial()) {
    on<_StoreTaskEvent>(_storeTask);
  }

  final Repository _repo;

  Future _storeTask(_StoreTaskEvent event, Emitter<TaskState> emit) async {
    emit(const TaskState.storeTask(TaskStateData.loading()));
    await _repo.storeTask(goalId: event.goalId, body: event.value);
  }
}

@freezed
class TaskEvent with _$TaskEvent {
  const factory TaskEvent.storeTask(
      {required int goalId, required TaskDataDto value}) = _StoreTaskEvent;
}

@freezed
class TaskState with _$TaskState {
  const factory TaskState.initial() = _Initial;

  const factory TaskState.storeTask(
      TaskStateData<Either<ExtendedErrors, Task>> data) = _StoreTask;
}

@freezed
class TaskStateData<T> with _$TaskStateData<T> {
  const factory TaskStateData.initial() = _InitialData<T>;

  const factory TaskStateData.loading() = _LoadingData<T>;

  const factory TaskStateData.result(T data) = _ResultData<T>;
}
