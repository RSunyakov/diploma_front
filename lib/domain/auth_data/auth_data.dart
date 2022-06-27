import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/user/user.dart';

part 'auth_data.freezed.dart';

part 'auth_data.g.dart';

/// Тип хранения метода входа и данных юзера
@freezed
class AuthData with _$AuthData {
  const factory AuthData({
    required AuthMethod authMethod,
    required User user,
  }) = _AuthData;

  factory AuthData.fromJson(Map<String, dynamic> json) =>
      _$AuthDataFromJson(json);

  static AuthData initial() => AuthData(
        authMethod: const AuthMethod.initial(),
        user: User.empty(),
      );

  const AuthData._();
}

/// Метод входа в приложение
@freezed
class AuthMethod with _$AuthMethod {
  const factory AuthMethod.initial(
          {@TokenConverter() @Default(Token.invalid()) Token token}) =
      AuthMethodInitial;

  const factory AuthMethod.phoneOrEmail({
    @NonEmptyStringConverter() required NonEmptyString login,
    @TokenConverter() required Token token,
  }) = AuthMethodPhoneOrEmail;

  const factory AuthMethod.google({
    @TokenConverter() required Token token,
  }) = AuthMethodGoogle;

  const factory AuthMethod.faceId({
    @TokenConverter() required Token token,
  }) = AuthMethodFaceId;

  factory AuthMethod.fromJson(Map<String, dynamic> json) =>
      _$AuthMethodFromJson(json);

  const AuthMethod._();
}

// enum AuthMethod {email, phone, google}
