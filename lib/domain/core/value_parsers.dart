import 'package:sphere/core/safe_coding/safe_coding.dart';

import 'failures.dart';

/// Проверка на то, что строка непустая
Either<ValueFailure<String>, String> parseIsNotEmpty(String input,
    {String? failureTag}) {
  if (input.isNotEmpty) {
    return right(input);
  }
  return left(ValueFailure.empty(failedValue: input, failureTag: failureTag));
}
