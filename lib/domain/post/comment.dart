import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';

import '../../core/safe_coding/src/option.dart';

part 'comment.freezed.dart';

@freezed
class Comment with _$Comment {
  const factory Comment({
    required int id,
    required NonEmptyString body,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Option<UserInfo> user,
    required Option<List<Comment>> replies,
  }) = _Comment;

  static Comment empty = Comment(
    id: 0,
    body: NonEmptyString(''),
    createdAt: DateTime(0),
    updatedAt: DateTime(0),
    user: none(),
    replies: none(),
  );

  const Comment._();
}

//Конвертер для [Option<Comment>]
// class OptionalCommentConverter
//     implements JsonConverter<Option<List<Comment>>, String> {
//   const OptionalCommentConverter();
//
//   @override
//   fromJson(String json) {
//     try {
//       final map = jsonDecode(json);
//       return some((map as List<dynamic>)
//           .map((item) => Comment.fromJson(item))
//           .toList());
//     } on Error catch (_) {
//       // Сработает в случае, если обломается JsonSerialization
//       return none();
//     } on Exception catch (_) {
//       return none();
//     }
//   }
//
//   @override
//   String toJson(Option<List<Comment>> object) {
//     return object.fold(
//         () => '{}', (a) => jsonEncode(a.map((e) => e.toJson()).toList()));
//   }
// }
