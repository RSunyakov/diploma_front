import 'package:flutter_test/flutter_test.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/failures.dart';
import 'package:sphere/domain/core/value_objects.dart';

void main() {
  group('NonEmptyList<T> tests', () {
    ///

    test('NonEmptyList<T>: test', () async {
      final v = NonEmptyList<int>(const []);
      expect(v, isA<NonEmptyList<int>>());
    });

    test('NonEmptyList<T>: extension test', () async {
      final v = <int>[].ne;
      expect(v, isA<NonEmptyList<int>>());
    });

    test('NonEmptyList<T>: left value test', () async {
      final v = <int>[].ne;
      expect(v.value, isA<Left<ValueFailure<List<int>>, List<int>>>());
    });

    test('NonEmptyList<T>: right value test', () async {
      final v = [10].ne;
      expect(v.value, isA<Right<ValueFailure<List<int>>, List<int>>>());
    });

    test('NonEmptyList<T>: right value getOrElse  test', () async {
      final v = [10].ne;
      expect(v.getOrElse(), equals([10]));
    });

    test('NonEmptyList<T>: left value getOrElse  test', () async {
      final v = <int>[].ne;
      expect(v.getOrElse(), equals([]));
    });

    test('NonEmptyList<T>: left value getOrElse with dflt  test', () async {
      final v = <int>[].ne;
      expect(v.getOrElse(dflt: [20]), equals([20]));
    });

    test('NonEmptyList<T>: full value test', () async {
      [1].ne().fold(
            (l) => fail('FAIL'),
            (r) => expect(r, equals([1])),
          );
    });
  });

  group('NonEmptyMap<K, V> tests', () {
    ///

    test('NonEmptyMap<K, V>: test', () async {
      final v = NonEmptyMap<int, bool>(const {});
      expect(v, isA<NonEmptyMap<int, bool>>());
    });

    test('NonEmptyMap<K, V>: extension test', () async {
      final v = <int, bool>{}.ne;
      expect(v, isA<NonEmptyMap<int, bool>>());
    });

    test('NonEmptyMap<K, V>: left value test', () async {
      final v = <int, bool>{}.ne;
      expect(
          v.value, isA<Left<ValueFailure<Map<int, bool>>, Map<int, bool>>>());
    });

    test('NonEmptyMap<K, V>: right value test', () async {
      final v = {10: true}.ne;
      expect(
          v.value, isA<Right<ValueFailure<Map<int, bool>>, Map<int, bool>>>());
    });

    test('NonEmptyMap<K, V>: right value getOrElse  test', () async {
      final v = {10: true}.ne;
      expect(v.getOrElse(), equals({10: true}));
    });

    test('NonEmptyMap<K, V>: left value getOrElse  test', () async {
      final v = <int, bool>{}.ne;
      expect(v.getOrElse(), equals({}));
    });

    test('NonEmptyMap<K, V>: left value getOrElse with dflt  test', () async {
      final v = <int, bool>{}.ne;
      expect(v.getOrElse(dflt: {20: false}), equals({20: false}));
    });

    test('NonEmptyMap<K, V>: full value test', () async {
      <int, bool>{20: false}.ne().fold(
            (l) => fail('FAIL'),
            (r) => expect(r, equals({20: false})),
          );
    });
  });
}
