import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/src/option.dart';
import 'package:sphere/domain/core/value_objects.dart';

part 'task.freezed.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required int id,
    required NonEmptyString title,
    required NonEmptyString comment,
    required NonEmptyString schedule,
    required bool isCompleted,
    required Option<DateTime> startAt,
    required Option<DateTime> deadlineAt,
  }) = _Task;

  static Task empty() {
    return Task(
      id: 0,
      title: NonEmptyString(''),
      comment: NonEmptyString(''),
      schedule: NonEmptyString(''),
      isCompleted: false,
      startAt: none(),
      deadlineAt: none(),
    );
  }

  const Task._();
}
