import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/core/safe_coding/src/unit.dart';
import 'package:sphere/data/dto/admin/admin.dart';
import 'package:sphere/data/dto/question/question.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/domain/admin/admin.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/simple_message.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/question/question.dart';
import 'package:sphere/domain/test/test.dart';
import 'package:sphere/domain/users/user_domain.dart';
import 'package:sphere/domain/webhook/webhook.dart';
import 'package:sphere/logic/repository/repository.dart';
import 'remote/remote_repository.dart';

@prod
@LazySingleton(as: Repository)
class RepositoryImpl extends Repository {
  RepositoryImpl(RemoteRepository? remote)
      :_remote = remote ?? GetIt.I.get();


  // ignore: unused_field
  final RemoteRepository _remote;



  @override
  Future<Either<ExtendedErrors, List<Question>>> getQuestionList() {
    return _remote.getQuestionList();
  }

  @override
  Future<Either<ExtendedErrors, Test>> addTest(AddTestBody value, int adminId) {
    return _remote.addTest(value, adminId);
  }

  @override
  Future<Either<ExtendedErrors, List<Test>>> getTestList(int adminId) {
    return _remote.getTestList(adminId);
  }

  @override
  Future<Either<ExtendedErrors, Question>> addQuestion(AddQuestionBody value) {
    return _remote.addQuestion(value);
  }

  @override
  Future<Either<ExtendedErrors, Test>> addQuestionsToTest(int testId, List<AddQuestionBody> value) {
    return _remote.addQuestionsToTest(testId, value);
  }

  @override
  Future<Either<ExtendedErrors, UserDomain>> addTestsToUser(String userId, List<TestDataDto> value) {
    return _remote.addTestsToUser(userId, value);
  }

  @override
  Future<Either<ExtendedErrors, List<UserDomain>>> getAllUsers(int adminId) {
   return _remote.getAllUsers(adminId);
  }

  @override
  Future<Either<ExtendedErrors, Admin>> login(AddAdminBody value) {
    return _remote.login(value);
  }

  @override
  Future<Either<ExtendedErrors, Admin>> register(AddAdminBody value) {
    return _remote.register(value);
  }

  @override
  Future<Either<ExtendedErrors, Webhook>> getWebhooks(int adminId) {
    return _remote.getWebhooks(adminId);
  }
}
