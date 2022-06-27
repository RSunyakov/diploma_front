import 'package:flutter_test/flutter_test.dart';
import 'package:sphere/domain/auth_data/auth_data.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/user/user.dart';

import '../shared/common.dart';

void main() {
  group('AuthData tests', () {
    final namedUser = User(
        name: NonEmptyString('user'),
        // ignore: deprecated_member_use_from_same_package
        deprecatedToken: const Token.invalid());

    myTest('AuthData.initial test', () async {
      final data = AuthData.initial();
      expect(data.authMethod, isA<AuthMethodInitial>());
      expect(data.user.name, equals(NonEmptyString('')));
    });

    myTest('AuthData.phoneOrEmail test', () async {
      final method = AuthMethod.phoneOrEmail(
          login: NonEmptyString('login'), token: Token.tagged('token'));
      final data = AuthData(authMethod: method, user: namedUser);
      expect(data.authMethod, isA<AuthMethodPhoneOrEmail>());
      expect(data.authMethod, equals(method));
      expect(data.user, equals(namedUser));
    });

    myTest('AuthData.google test', () async {
      const method = AuthMethod.google(token: Token.invalid());
      final data = AuthData(authMethod: method, user: namedUser);
      expect(data.authMethod, isA<AuthMethodGoogle>());
      expect(data.authMethod, equals(method));
    });

    myTest('AuthData JSON test', () async {
      var data = AuthData(
          authMethod: const AuthMethod.google(token: Token.invalid()),
          user: namedUser);
      var back = AuthData.fromJson(data.toJson());
      expect(back, equals(data));
      data = AuthData(
          authMethod: AuthMethod.phoneOrEmail(
              login: NonEmptyString('login'), token: Token.tagged('token')),
          user: namedUser);
      back = AuthData.fromJson(data.toJson());
      expect(back, equals(data));
      data = AuthData(
          authMethod: AuthMethod.phoneOrEmail(
              login: NonEmptyString('login'), token: Token.tagged('token')),
          user: namedUser);
      back = AuthData.fromJson(data.toJson());
      expect(back, equals(data));
    });
  });
}
