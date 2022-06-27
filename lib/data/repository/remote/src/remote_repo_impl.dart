import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/admin/admin.dart';
import 'package:sphere/data/dto/fetch_code.dart';
import 'package:sphere/data/dto/question/question.dart';
import 'package:sphere/data/dto/simple_message.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/data/dto/users/user.dart';
import 'package:sphere/data/dto/webhook/webhook.dart';
import 'package:sphere/data/repository/remote/src/http/api_client.dart';
import 'package:sphere/domain/admin/admin.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/simple_message.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/question/question.dart';
import 'package:sphere/domain/test/test.dart';
import 'package:sphere/domain/users/user_domain.dart';
import 'package:sphere/domain/webhook/webhook.dart';
import 'package:vfx_flutter_common/utils.dart';

import '../remote_repository.dart';

mixin RemoteRepositoryImplMixin {
  late final ApiClient _client;

  Future<Either<ExtendedErrors, R>> _safeFunc<R>(
      Future<Either<ExtendedErrors, R>> Function() f) async {
    try {
      final r = await f.call();
      return r;
    } on Exception catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    }
  }
}

/// Имплементация
@prod
@LazySingleton(as: RemoteRepository)
class RemoteRepositoryImpl
    with RemoteRepositoryImplMixin
    implements RemoteRepository {
  RemoteRepositoryImpl({
    ApiClient? apiClient,
  }) {
    _client = apiClient ?? GetIt.I.get();
  }


  @override
  Future<Either<ExtendedErrors, List<Question>>> getQuestionList() {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getQuestionList();
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Test>> addTest(AddTestBody value, int adminId) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.addTest(body: value, adminId: adminId);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<Test>>> getTestList(int adminId) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getTestList(id: adminId);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Question>> addQuestion(AddQuestionBody value) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.addQuestion(body: value);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Test>> addQuestionsToTest(int testId, List<AddQuestionBody> value) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.addQuestionsToTest(id: testId, body: value);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, UserDomain>> addTestsToUser(String userId, List<TestDataDto> value) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.addTestsToUser(id: userId, body: value);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<UserDomain>>> getAllUsers(int adminId) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getUsers(adminId: adminId);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Admin>> login(AddAdminBody value) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.login(body: value);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Admin>> register(AddAdminBody value) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.register(body: value);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Webhook>> getWebhooks(int adminId) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getWebhooks(id: adminId);
      final domain = dto.toDomain();
      return domain;
    });
  }
}
