import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/post/comment.dart';
import 'package:sphere/domain/post/goal.dart';
import 'package:sphere/domain/reaction/reaction.dart';

part 'report.freezed.dart';

@freezed
class Report with _$Report {
  const factory Report({
    required int id,
    required NonEmptyString description,
    required NonEmptyString file,
    required DateTime createdAt,
    required int commentsCount,
    @Default(<Comment>[]) List<Comment> comments,
    @Default(<Reaction>[]) List<Reaction> reactions,
    Goal? goal,
  }) = _Report;
}
