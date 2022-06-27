import 'package:flutter_test/flutter_test.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/occupation/occupation.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

import '../shared/common.dart';

void main() {
  group('Occupation tests', () {
    late Occupation data;

    setUp(() {
      data = Occupation.study(
        id: 10,
        title: NonEmptyString('place'),
        speciality: NonEmptyString('occupation'),
        beginDateTime: beginDateTime(2020.asYear),
        isUnderEdit: false,
      );
    });

    myTest('Occupation test', () async {
      // Изначально все в порядке
      data.asStudy.fold(
        () => fail('FAIL'),
        (a) {
          a = a.copyWith(
            title: NonEmptyString('place'),
            speciality: NonEmptyString('speciality'),
            beginDateTime:
                beginDateTime(1995.asYear, min: 1990.asYear, max: 2012.asYear),
          );

          expect(a.beginDateTime.getOrElse(), equals(1995.asYear));
          expect(a.beginDateTime.isValid(), isTrue);
          expect(a.isTillNow, isTrue);

          // Двигаем дату начала, чтобы проверить, что она двигается
          a = a.copyWith(
              beginDateTime: a.beginDateTime.copyWith(value: 1996.asYear));
          expect(a.beginDateTime.getOrElse(), equals(1996.asYear));
          expect(a.beginDateTime.isValid(), isTrue);

          // Двигаем минимальный порог даты, чтобы сломать
          a = a.copyWith(
              beginDateTime: a.beginDateTime.copyWith(min: 1997.asYear));
          expect(a.beginDateTime.isValid(), isFalse);

          a = a.copyWith(
              endDateTime: some(endDateTime(DateTime(now.year, now.month))));
          expect(a.isTillNow, isTrue);

          a = a.copyWith(endDateTime: some(endDateTime(2021.asYear)));
          expect(a.isTillNow, isFalse);

          // Установим флаг, чтобы двинуть дату завершения
          a = a.withTillNow(true);
          expect(a.isTillNow, isTrue);
        },
      );
    });

    // myTest('Occupation JSON test', () async {
    //   data.asStudy.fold(
    //     () => fail('FAIL'),
    //     (a) {
    //       a = a.copyWith(
    //         title: NonEmptyString('place'),
    //         speciality: NonEmptyString('speciality'),
    //         beginDateTime: beginDateTime(1995.asYear),
    //         endDateTime: some(endDateTime(2000.asYear)),
    //       );
    //
    //       final json = data.toJson();
    //       final data2 = Occupation.fromJson(json);
    //       expect(data2, equals(data));
    //     },
    //   );
    // });
  });
}
