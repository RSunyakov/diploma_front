import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';

import 'package:sphere/domain/core/value_objects.dart';

import 'package:sphere/domain/post/comment.dart';
import 'package:sphere/domain/post/skill.dart';
import 'package:sphere/domain/post/task.dart';
import 'package:sphere/domain/reports/report.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';

part 'goal.freezed.dart';

@freezed
class Goal with _$Goal {
  const factory Goal({
    required int id,
    required NonEmptyString title,
    required NonEmptyString type,
    required NonEmptyString status,
    required num progress,
    required DateTime startAt,
    required DateTime deadlineAt,
    DateTime? pausedAt,
    required Option<UserInfo> mentor,
    required Skill skill,
    required List<String> tags,
    required List<Task> tasks,
    required List<Comment> comments,
    required Option<List<Report>> reports,
  }) = _Goal;
}
