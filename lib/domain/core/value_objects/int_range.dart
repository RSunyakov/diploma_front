import 'dart:convert';

import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/failures.dart';
import 'package:sphere/domain/core/value_objects.dart';

///
class IntRange extends ValueObject<int> {
  factory IntRange(int input,
      {required int min, required int max, required String failureTag}) {
    return IntRange._(
        _parse(input, min, max, failureTag: failureTag), min, max, failureTag);
  }

  final int min;

  final int max;

  @override
  final Either<ValueFailure<int>, int> value;

  /// Используя такой подход, можно просто сделать так
  /// ```dart
  /// myTest('IntRange copyWith test', () async {
  ///   var data = IntRange(31, min: 20, max: 30, failureTag: 'int');
  ///   expect(data.isValid(), isFalse);
  ///   data = data.copyWith(max: 31);
  ///   expect(data.isValid(), isTrue);
  ///   data = data.copyWith(value: 19);
  ///   expect(data.isValid(), isFalse);
  ///   data = data.copyWith(min: 19);
  ///   expect(data.isValid(), isTrue);
  /// });
  /// ```
  @override
  IntRange copyWith({int? value, int? min, int? max, String? failureTag}) {
    return IntRange(
      value ?? this.value.fold((l) => l.failedValue, (r) => r),
      min: min ?? this.min,
      max: max ?? this.max,
      failureTag: '',
    );
  }

  const IntRange._(this.value, this.min, this.max, String failureTag)
      : super(failureTag);

  static Either<ValueFailure<int>, int> _parse(int input, int min, int max,
      {required String failureTag}) {
    if ((min >= max) ||
        (input == min && input == max) ||
        (input < min || input > max)) {
      return left(ValueFailure.notInRange(
        failedValue: input,
        failureTag: failureTag,
        min: min,
        max: max,
      ));
    }
    return right(input);
  }
}

class IntRangeConverter extends TaggableValueObjectConverter<IntRange, String> {
  const IntRangeConverter();

  @override
  IntRange fromJson(String value) {
    final list = jsonDecode(value) as List;
    final v = list.elementAt(0) as int;
    final min = list.elementAt(1) as int;
    final max = list.elementAt(2) as int;
    final failureTag =
        list.length > 3 ? list[3] : TaggableValueObjectConverter.noTag;
    return IntRange(v, min: min, max: max, failureTag: failureTag);
  }

  @override
  String toJson(IntRange e) {
    return jsonEncode(e.value.fold((l) {
      final f = l as ValueFailureNotInRange;
      return [f.failedValue, f.min, f.max, l.failureTag];
    }, (r) => [r, e.min, e.max]));
  }
}

class OptionIntRangeConverter
    extends TaggableValueObjectConverter<Option<IntRange>, String> {
  const OptionIntRangeConverter();

  @override
  Option<IntRange> fromJson(String value) {
    try {
      final list = jsonDecode(value) as List;
      final v = list.elementAt(0) as int;
      final min = list.elementAt(1) as int;
      final max = list.elementAt(2) as int;
      final failureTag =
          list.length > 3 ? list[3] : TaggableValueObjectConverter.noTag;
      return Some(IntRange(v, min: min, max: max, failureTag: failureTag));
    } catch (_) {
      return none();
    }
  }

  @override
  String toJson(Option<IntRange> e) {
    return e.fold(() => '', (a) {
      return jsonEncode(a.value.fold((l) {
        final f = l as ValueFailureNotInRange;
        return [f.failedValue, f.min, f.max, l.failureTag];
      }, (r) => [r, a.min, a.max]));
    });
  }
}
