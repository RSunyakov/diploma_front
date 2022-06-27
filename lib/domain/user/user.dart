import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';

part 'user.freezed.dart';

part 'user.g.dart';

/// Внутренний юзер.
/// Он может строиться как после входа по email/code, так и через
/// Firebase вход. У последнего свой специфический юзер, но мы все-таки
/// приводим все к единому.
/// --
/// Есть нюанс для определения первого входа:
/// Чтобы определить момент первого входа, надо понять, какое обязательное поле
/// пока является незаполненным.
/// Предполагалось, что [UserInfo.firstName], но оказалось, что по ТЗ
/// это поле автозаполняется.
/// Тогда надо
@freezed
class User with _$User {
  const factory User({
    @NonEmptyStringConverter() required NonEmptyString name,
    @Deprecated('use AuthMethod.token instead')
    @TokenConverter()
        required Token deprecatedToken,
  }) = _User;

  static User empty() {
    return User(
      name: NonEmptyString(''),
      // ignore: deprecated_member_use_from_same_package
      deprecatedToken: const Token.invalid(),
    );
  }

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
