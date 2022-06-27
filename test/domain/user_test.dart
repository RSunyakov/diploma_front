import 'package:flutter_test/flutter_test.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/user/user.dart';

import '../shared/common.dart';

void main() {
  group('User tests', () {
    myTest('User.empty test', () async {
      final u = User.empty();
      final u2 = User.fromJson(u.toJson());
      expect(u2, equals(u));
    });

    myTest('User.initial test', () async {
      final u = User(
          name: NonEmptyString('name'),
          // ignore: deprecated_member_use_from_same_package
          deprecatedToken: Token.tagged('TOKEN'));
      final u2 = User.fromJson(u.toJson());
      expect(u2, equals(u));
    });
  });
}
