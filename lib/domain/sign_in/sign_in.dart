import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/failures.dart';
import 'package:sphere/domain/core/value_objects.dart';

part 'sign_in.freezed.dart';

part 'sign_in.g.dart';

@freezed
class SignIn with _$SignIn {
  const factory SignIn({
    @TokenConverter() required Token token,
  }) = _SignIn;

  factory SignIn.fromJson(Map<String, dynamic> json) => _$SignInFromJson(json);
}

extension SignInX on SignIn {
  /// Проверка наличия ошибок в полях объекта.
  /// Возвращает только первую ошибку
  Option<ValueFailure<dynamic>> get failureOption {
    return token.failureOrUnit.fold((l) {
      return some(l);
    }, (r) => none());
  }
}
