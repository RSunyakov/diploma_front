import 'package:flutter_test/flutter_test.dart';
import 'package:sphere/domain/core/value_objects/date_time_range.dart';
import 'package:vfx_flutter_common/utils.dart';

import '../shared/common.dart';

void main() {
  group('DateTimeRange tests', () {
    final input = now;
    final badMin = now.add(const Duration(seconds: 1));

    myTest('DateTimeRange: using Shortcut test', () async {
      final data = dtRange(input);
      expect(data.isValid(), isTrue);
    });

    myTest('DateTimeRange bad min test', () async {
      final data = dtRange(input, min: badMin);
      expect(data.isValid(), isFalse);
      data.value.fold(
          (l) => expect(l.failedValue, equals(input)), (r) => fail('BAD test'));
    });

    final badMax = now.subtract(const Duration(seconds: 1));

    myTest('DateTimeRange bad max test', () async {
      final data = dtRange(input, min: input, max: badMax);
      expect(data.isValid(), isFalse);
      data.value.fold(
          (l) => expect(l.failedValue, equals(input)), (r) => fail('BAD test'));
    });

    final min = input.subtract(const Duration(days: 365 * 10));
    final max = input.add(const Duration(days: 365 * 10));

    myTest('DateTimeRange good test', () async {
      final data = dtRange(min, min: min, max: max);
      expect(data.isValid(), isTrue);
      data.value.fold((l) => fail('BAD test'), (r) => expect(r, equals(min)));
    });

    myTest('DateTimeRange good test', () async {
      final data = dtRange(max, min: min, max: max);
      expect(data.isValid(), isTrue);
      data.value.fold((l) => fail('BAD test'), (r) => expect(r, equals(max)));
    });

    // согласно новых правил, значение должно превышать максимальное
    // больше чем на месяц
    final badInput = max.add(const Duration(days: 32));

    myTest('DateTimeRange copyWith test', () async {
      var data = dtRange(badInput, min: min, max: max);
      expect(data.isValid(), isFalse);
      data = data.copyWith(max: max.add(const Duration(days: 1)));
      expect(data.isValid(), isTrue);
      data = data.copyWith(value: min.subtract(const Duration(days: 1)));
      expect(data.isValid(), isFalse);
      data = data.copyWith(min: min.subtract(const Duration(days: 1)));
      expect(data.isValid(), isTrue);
    });

    myTest('DateTimeRange good JSON test', () async {
      final data = dtRange(input, min: min, max: max);
      final json = const DateTimeRangeConverter().toJson(data);
      final data2 = const DateTimeRangeConverter().fromJson(json);
      expect(data2, equals(data));
    });

    myTest('DateTimeRange bad JSON test', () async {
      final data = dtRange(badInput, min: min, max: max);
      final json = const DateTimeRangeConverter().toJson(data);
      final data2 = const DateTimeRangeConverter().fromJson(json);
      expect(data2, equals(data));
    });
  });
}
