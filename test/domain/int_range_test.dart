import 'package:flutter_test/flutter_test.dart';
import 'package:sphere/domain/core/value_objects/int_range.dart';

import '../shared/common.dart';

void main() {
  group('IntRange tests', () {
    myTest('IntRange bad min test', () async {
      final data = IntRange(19, min: 20, max: 30, failureTag: 'int');
      expect(data.isValid(), isFalse);
      data.value.fold(
          (l) => expect(l.failedValue, equals(19)), (r) => fail('BAD test'));
    });

    myTest('IntRange bad max test', () async {
      final data = IntRange(31, min: 20, max: 30, failureTag: 'int');
      expect(data.isValid(), isFalse);
      data.value.fold(
          (l) => expect(l.failedValue, equals(31)), (r) => fail('BAD test'));
    });

    myTest('IntRange good test', () async {
      final data = IntRange(20, min: 20, max: 30, failureTag: 'int');
      expect(data.isValid(), isTrue);
      data.value.fold((l) => fail('BAD test'), (r) => expect(r, equals(20)));
    });

    myTest('IntRange good test', () async {
      final data = IntRange(30, min: 20, max: 30, failureTag: 'int');
      expect(data.isValid(), isTrue);
      data.value.fold((l) => fail('BAD test'), (r) => expect(r, equals(30)));
    });

    myTest('IntRange copyWith test', () async {
      var data = IntRange(31, min: 20, max: 30, failureTag: 'int');
      expect(data.isValid(), isFalse);
      data = data.copyWith(max: 31);
      expect(data.isValid(), isTrue);
      data = data.copyWith(value: 19);
      expect(data.isValid(), isFalse);
      data = data.copyWith(min: 19);
      expect(data.isValid(), isTrue);
    });

    myTest('IntRange good JSON test', () async {
      final data = IntRange(25, min: 20, max: 30, failureTag: 'int');
      final json = const IntRangeConverter().toJson(data);
      final data2 = const IntRangeConverter().fromJson(json);
      expect(data2, equals(data));
    });

    myTest('IntRange bad JSON test', () async {
      final data = IntRange(15, min: 20, max: 30, failureTag: 'int');
      final json = const IntRangeConverter().toJson(data);
      final data2 = const IntRangeConverter().fromJson(json);
      expect(data2, equals(data));
    });
  });
}
