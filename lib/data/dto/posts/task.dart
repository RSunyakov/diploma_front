import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/core/safe_coding/src/option.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/post/task.dart';
import 'package:sphere/ui/shared/all_shared.dart';

part 'task.g.dart';

@JsonSerializable()
class TaskDto {
  TaskDto({required this.status, this.data, this.message, this.errors});

  bool status;
  final String? message;
  final Map<String, dynamic>? errors;
  TaskDataDto? data;

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDtoToJson(this);
}

@JsonSerializable()
class TaskDataDto {
  int? id;
  String? title;
  String? comment;
  num? price;
  String? schedule;
  bool? isCompleted;
  String? startAt;
  String? deadlineAt;

  TaskDataDto({
    this.id,
    this.title,
    this.comment,
    this.price,
    this.schedule,
    this.isCompleted,
    this.startAt,
    this.deadlineAt,
  });

  factory TaskDataDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDataDtoToJson(this);
}

extension TaskDtoX on TaskDto {
  Either<ExtendedErrors, Task> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('Task: data is null'));
      }
      final domain = Task(
          id: data!.id ?? 0,
          title: NonEmptyString(data!.title ?? ''),
          comment: NonEmptyString(data!.comment ?? ''),
          schedule: NonEmptyString(data!.schedule ?? ''),
          isCompleted: data!.isCompleted ?? false,
          startAt: some(data!.startAt?.dateTimeFromBackend ?? DateTime.now()),
          deadlineAt:
              some(data!.deadlineAt?.dateTimeFromBackend ?? DateTime.now()));
      return Right(domain);
    } on Error catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on CheckedFromJsonException catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on Exception catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    }
  }
}
