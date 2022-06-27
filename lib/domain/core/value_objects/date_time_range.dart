import 'dart:convert';

import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/failures.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:vfx_flutter_common/utils.dart';

/// Промежуток между двумя датами.
class DateTimeRange extends ValueObject<DateTime> {
  factory DateTimeRange(DateTime input,
      {required DateTime min,
      required DateTime max,
      required String failureTag}) {
    return DateTimeRange._(
        _parse(input, min, max, failureTag: failureTag), min, max, failureTag);
  }

  final DateTime min;

  final DateTime max;

  @override
  final Either<ValueFailure<DateTime>, DateTime> value;

  @override
  DateTimeRange copyWith(
      {DateTime? value, DateTime? min, DateTime? max, String? failureTag}) {
    return DateTimeRange(
      value ?? this.value.fold((l) => l.failedValue, (r) => r),
      min: min ?? this.min,
      max: max ?? this.max,
      failureTag: '',
    );
  }

  static Either<ValueFailure<DateTime>, DateTime> _parse(
      DateTime input, DateTime min, DateTime max,
      {required String failureTag}) {
    // Пришлось сделать `input.isAfter(max.add(const Duration(days: 31))))`
    // потому что когда месяца совпадают - начинают играть роль дни данного
    // месяца.
    if ((min.isAfter(max)) ||
        (input.isBefore(min) ||
            input.isAfter(max.add(const Duration(days: 31))))) {
      return left(ValueFailure.notInRange(
        failedValue: input,
        failureTag: failureTag,
        min: min,
        max: max,
      ));
    }
    return right(input);
  }

  const DateTimeRange._(this.value, this.min, this.max, String failureTag)
      : super(failureTag);
}

/// Сокращатель для диапазона дат
DateTimeRange dtRange(DateTime value, {DateTime? min, DateTime? max}) =>
    DateTimeRange(value, min: min ?? value, max: max ?? now, failureTag: 'dt');

/// JSON конвертер [DateTimeRange]
class DateTimeRangeConverter
    extends TaggableValueObjectConverter<DateTimeRange, String> {
  const DateTimeRangeConverter();

  @override
  DateTimeRange fromJson(String value) {
    final list = jsonDecode(value) as List;
    final v = DateTime.fromMicrosecondsSinceEpoch(list.elementAt(0) as int);
    final min = DateTime.fromMicrosecondsSinceEpoch(list.elementAt(1) as int);
    final max = DateTime.fromMicrosecondsSinceEpoch(list.elementAt(2) as int);
    final failureTag =
        list.length > 3 ? list[3] : TaggableValueObjectConverter.noTag;
    return DateTimeRange(v, min: min, max: max, failureTag: failureTag);
  }

  @override
  String toJson(DateTimeRange e) {
    return jsonEncode(e.value.fold((l) {
      final f = l as ValueFailureNotInRange<DateTime>;
      return [
        f.failedValue.microsecondsSinceEpoch,
        f.min.microsecondsSinceEpoch,
        f.max.microsecondsSinceEpoch,
        l.failureTag
      ];
    }, (r) {
      return [
        r.microsecondsSinceEpoch,
        e.min.microsecondsSinceEpoch,
        e.max.microsecondsSinceEpoch
      ];
    }));
  }
}

/// JSON конвертер [Option<DateTimeRange>]
class OptionDateTimeRangeConverter
    extends TaggableValueObjectConverter<Option<DateTimeRange>, String> {
  const OptionDateTimeRangeConverter();

  @override
  Option<DateTimeRange> fromJson(String value) {
    try {
      final list = jsonDecode(value) as List;
      final v = DateTime.fromMicrosecondsSinceEpoch(list.elementAt(0) as int);
      final min = DateTime.fromMicrosecondsSinceEpoch(list.elementAt(1) as int);
      final max = DateTime.fromMicrosecondsSinceEpoch(list.elementAt(2) as int);
      final failureTag =
          list.length > 3 ? list[3] : TaggableValueObjectConverter.noTag;
      return Some(DateTimeRange(v, min: min, max: max, failureTag: failureTag));
    } catch (_) {
      return none();
    }
  }

  @override
  String toJson(Option<DateTimeRange> value) {
    return value.fold(() => '', (a) {
      return jsonEncode(a.value.fold((l) {
        final f = l as ValueFailureNotInRange<DateTime>;
        return [
          f.failedValue.microsecondsSinceEpoch,
          f.min.microsecondsSinceEpoch,
          f.max.microsecondsSinceEpoch,
          l.failureTag
        ];
      }, (r) {
        return [
          r.microsecondsSinceEpoch,
          a.min.microsecondsSinceEpoch,
          a.max.microsecondsSinceEpoch
        ];
      }));
    });
  }
}
