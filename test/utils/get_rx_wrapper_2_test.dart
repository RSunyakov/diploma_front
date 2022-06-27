import 'package:flutter_test/flutter_test.dart';
import 'package:sphere/core/utils/get_rx_wrapper_2.dart';

void main() {
  group('GetRxWrapper2 tests', () {
    ///
    test('GetRxWrapper2: equality test', () async {
      {
        final v1 = GetRxWrapper2('a');
        final v2 = GetRxWrapper2('a');
        expect(v1, equals(v2));
      }
      {
        final v1 = GetRxWrapper2(const ['a', 'b']);
        final v2 = GetRxWrapper2(const ['a', 'b']);
        expect(v1, equals(v2));
      }
      {
        final v1 = GetRxWrapper2(const {
          1: ['a', 'b']
        });
        final v2 = GetRxWrapper2(const {
          1: ['a', 'b']
        });
        expect(v1, equals(v2));
      }
      {
        final v1 = GetRxWrapper2('a');
        final v2 = GetRxWrapper2('b');
        expect(v1, isNot(equals(v2)));
      }
      {
        final v1 = GetRxWrapper2(const ['a', 'b']);
        final v2 = GetRxWrapper2(const ['a', 'c']);
        expect(v1, isNot(equals(v2)));
      }
      {
        final v1 = GetRxWrapper2(const {
          1: ['a', 'b']
        });
        final v2 = GetRxWrapper2(const {
          1: ['d', 'b']
        });
        expect(v1, isNot(equals(v2)));
      }
      {
        final v1 = GetRxWrapper2(const {
          1: ['a', 'b']
        });
        final v2 = GetRxWrapper2(const {
          2: ['a', 'b']
        });
        expect(v1, isNot(equals(v2)));
      }
    });

    /// Here we just use auto setting.
    test('GetRxWrapper2: with default setter test (No special business logic)',
        () async {
      final v = GetRxWrapper2('a');
      expectLater(v.stream, emitsInOrder(['b', 'c']));
      v.value('b');
      v.value('c');
    });

    /// Here we can use special business logic inside custom setter.
    test('GetRxWrapper2: with custom setter test (with special business logic)',
        () async {
      final v = GetRxWrapper2<String>('a',
          setter: (_, newValue, __) =>
              // We can return as `wrong` either [oldValue] or null.
              newValue?.contains('-') ?? false ? newValue : null);
      expectLater(v.stream, emitsInOrder(['b-', '-c']));
      v.value('b-');
      v.value('b');
      v.value('c');
      v.value('-c');
    });

    /// Here we does not use forceRefresh.
    test('GetRxWrapper2: without refresh test', () async {
      final v = GetRxWrapper2<String>('a',
          setter: (_, newValue, __) =>
              // We can return as `wrong` either [oldValue] or null.
              newValue?.contains('-') ?? false ? newValue : null);
      expectLater(v.stream, emitsInOrder(['b-', '-c', 'd-d']));
      v.value('b-');
      v.value('b-');
      v.value('b-');
      v.value('b');
      v.value('c');
      v.value('c');
      v.value('-c');
      v.value('-c');
      v.value('-c');
      v.value('d-d');
    });

    /// Here we use forceRefresh.
    test('GetRxWrapper2: with refresh test', () async {
      final v = GetRxWrapper2<String>(
        'a',
        forceRefresh: true,
        // We can return as `wrong` either [oldValue] or null.
        setter: (_, newValue, __) =>
            newValue?.contains('-') ?? false ? newValue : null,
      );
      expectLater(v.stream, emitsInOrder(['b-', 'b-', '-c', '-c', 'd-d']));
      v.value('b-');
      v.value('b-');
      v.value('-c');
      v.value('-c');
      v.value('d-d');
    });

    /// Here we use [sender] as extra variable.
    test('GetRxWrapper2: with sender test', () async {
      final v = GetRxWrapper2<String>(
        'a',
        forceRefresh: true,
        setter: (_, newValue, sender) {
          if (sender is int && sender < 2) {
            return null;
          }
          // We can return as `wrong` either [oldValue] or null.
          return newValue?.contains('-') ?? false ? newValue : null;
        },
      );
      expectLater(v.stream, emitsInOrder(['b-2', '2-c', '3-d-d']));
      v.value('b-1', 1);
      v.value('b-2', 2);
      v.value('1-c', 1);
      v.value('2-c', 2);
      v.value('3-d-d', 3);
    });

    /// Here we use [sender] as extra variable - variant 2.
    test('GetRxWrapper2: with sender-2 test', () async {
      final v = GetRxWrapper2<String>(
        'a',
        forceRefresh: true,
        setter: (oldValue, newValue, sender) {
          if (sender is bool) {
            return null;
          }

          // We can return as `wrong` either [oldValue] or null.
          return newValue?.contains('-') ?? false ? newValue : oldValue;
        },
      );
      expectLater(v.stream, emitsInOrder(['b-2', '2-c', '3-d-d']));
      v.value('b-1', false);
      v.value('b-2', 2);
      v.value('1-c', true);
      v.value('2-c', 2);
      v.value('3-d-d', 4.4);
    });

    /// Test using auto calculate without outer affect ([newValue] == null).
    test('GetRxWrapper2: Collatz conjecture setter test', () async {
      final v = GetRxWrapper2<int>(
        7,
        // Here we use [oldValue] as base of next step
        // and does not use [newValue] at all.
        setter: (oldValue, _, __) {
          if (oldValue.isEven) {
            return oldValue ~/ 2;
          } else {
            return 3 * oldValue + 1;
          }
        },
      );
      expectLater(
          v.stream,
          emitsInOrder([
            22,
            11,
            34,
            17,
            52,
            26,
            13,
            40,
            20,
            10,
            5,
            16,
            8,
            4,
            2,
            1,
            4,
            2,
            1,
          ]));

      // Just call [v.value()] without outer variables.
      List.generate(19, (_) => v.value());
    });
  });
}
