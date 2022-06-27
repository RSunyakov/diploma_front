import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';

part 'followers_follows.freezed.dart';

@freezed
class FollowersFollows with _$FollowersFollows {
  const factory FollowersFollows({
    required NonEmptyString uuid,
    required NonEmptyString firstName,
    required NonEmptyString lastName,
    required NonEmptyString photo,
    required NonEmptyString position,
    required double rating,
    required NonEmptyString url,
  }) = _FollowersFollows;
}
