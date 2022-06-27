import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/post/goal.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';

part 'post.freezed.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required int id,
    required NonEmptyString title,
    required num amount,
    required UserInfo user,
    required Goal goal,
    required List<String> tags,
  }) = _Post;

  // static Post empty = Post(
  //     id: 0,
  //     title: NonEmptyString(''),
  //     amount: 0,
  //     user: UserInfo.empty,
  //     goal: Goal.empty,
  //     tags: ['']);
  //
  // const Post._();

}
