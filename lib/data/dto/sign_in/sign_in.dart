import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/sign_in/sign_in.dart';

part 'sign_in.g.dart';

@JsonSerializable()
class SignInBody {
  SignInBody({
    required this.login,
    required this.code,
  });

  factory SignInBody.fromJson(Map<String, dynamic> json) =>
      _$SignInBodyFromJson(json);
  Map<String, dynamic> toJson() => _$SignInBodyToJson(this);

  final String login;
  final String code;
}

@JsonSerializable()
class SignInDto {
  SignInDto({
    this.data,
    this.message,
    required this.status,
    this.errors,
  });

  final bool status;
  final SignInDataDto? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory SignInDto.fromJson(Map<String, dynamic> json) =>
      _$SignInDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignInDtoToJson(this);
}

@JsonSerializable()
class SignInDataDto {
  SignInDataDto({required this.token});

  final String token;

  factory SignInDataDto.fromJson(Map<String, dynamic> json) =>
      _$SignInDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignInDataDtoToJson(this);
}

extension SignInDtoX on SignInDto {
  Either<ExtendedErrors, SignIn> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('SignIn: data is null'));
      }

      final domain = SignIn(
        token: Token.tagged(data!.token),
      );

      if (domain.failureOption.isSome()) {
        return left(ExtendedErrors.simple(domain.toString()));
      }

      return Right(domain);
    } on Exception catch (e) {
      // Возвращаем исключение
      return left(ExtendedErrors.simple(e.toString()));
    }
  }
}
