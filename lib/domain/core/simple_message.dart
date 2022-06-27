import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/failures.dart';
import 'package:sphere/domain/core/value_objects.dart';

part 'simple_message.freezed.dart';

@freezed
class SimpleMessage with _$SimpleMessage {
  const factory SimpleMessage({
    required bool status,
    @NonEmptyStringConverter() required NonEmptyString message,
  }) = _SimpleMessage;
}

extension SimpleMessageX on SimpleMessage {
  /// Проверка наличия ошибок в полях объекта.
  /// Возвращает только первую ошибку
  Option<ValueFailure<dynamic>> get failureOption {
    return message.failureOrUnit.fold((l) {
      return some(l);
    }, (r) => none());
  }

  List<String> get readFailure {
    return failureOption.fold(
      () => [],
      (a) => ['${a.runtimeType}/${a.failureTag}: ${a.failedValue}'],
    );
  }
}
