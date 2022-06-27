import 'package:flutter_test/flutter_test.dart';
import 'package:sphere/core/utils/types.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/occupation/occupation.dart';

import '../shared/common.dart';

void main() {
  group('New Occupation types tests', () {
    late Occupation study;
    late Occupation work;
    late Occupation hobby;

    setUp(() {
      study = Occupation.study(
        id: createUidFromNow(),
        title: ''.nonEmpty,
        speciality: ''.nonEmpty,
        beginDateTime: beginDateTime(2000.asYear),
      );
      work = Occupation.work(
        id: createUidFromNow(),
        title: ''.nonEmpty,
        occupation: ''.nonEmpty,
        beginDateTime: beginDateTime(1999.asYear),
      );
      hobby = Occupation.hobby(
        id: createUidFromNow(),
        title: ''.nonEmpty,
      );
    });

    myTest('Type & typeOf test', () async {
      expect(typeOf<StudyOccupation>() == StudyOccupation, isTrue);
    });

    myTest('NewOccupation base test', () async {
      expect(study.isSameAs(hobby), isFalse);
      expect(study.isSameAs(work), isFalse);
      expect(hobby.isSameAs(work), isFalse);

      expect(hobby.isHobby, isTrue);
      expect(hobby.isWork, isFalse);
      expect(hobby.isStudy, isFalse);

      expect(work.isWork, isTrue);
      expect(work.isHobby, isFalse);
      expect(work.isStudy, isFalse);

      expect(study.isStudy, isTrue);
      expect(study.isWork, isFalse);
      expect(study.isHobby, isFalse);

      hobby.asHobby.fold(() => fail('FAIL'), (a) => null);
      hobby.asWork.fold(() => null, (a) => fail('FAIL'));
      hobby.asStudy.fold(() => null, (a) => fail('FAIL'));

      work.asWork.fold(() => fail('FAIL'), (a) => null);
      work.asHobby.fold(() => null, (a) => fail('FAIL'));
      work.asStudy.fold(() => null, (a) => fail('FAIL'));

      study.asStudy.fold(() => fail('FAIL'), (a) => null);
      study.asWork.fold(() => null, (a) => fail('FAIL'));
      study.asHobby.fold(() => null, (a) => fail('FAIL'));
    });
  });
}
