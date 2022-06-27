import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/post/goal.dart';
import 'package:sphere/domain/post/skill.dart';

part 'achievement.freezed.dart';

@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required int id,
    required NonEmptyString title,
    required NonEmptyString description,
    required DateTime date,
    bool? auto,
    required Option<Goal> goal,
    required NonEmptyString goalUrl,
    required Option<Skill> skill,
  }) = _Achievement;
}
