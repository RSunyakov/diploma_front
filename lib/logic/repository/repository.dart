import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
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


abstract class Repository extends ChangeNotifier {


  Future<Either<ExtendedErrors, List<Question>>> getQuestionList();

  Future<Either<ExtendedErrors, List<Test>>> getTestList(int adminId);

  Future<Either<ExtendedErrors, Test>> addTest(AddTestBody value, int adminId);

  Future<Either<ExtendedErrors, Question>> addQuestion(AddQuestionBody value);

  Future<Either<ExtendedErrors, Test>> addQuestionsToTest(int testId, List<AddQuestionBody> value);

  Future<Either<ExtendedErrors, List<UserDomain>>> getAllUsers(int adminId);

  Future<Either<ExtendedErrors, UserDomain>> addTestsToUser(String userId, List<TestDataDto> value);

  Future<Either<ExtendedErrors, Admin>> register(AddAdminBody value);

  Future<Either<ExtendedErrors, Admin>> login(AddAdminBody value);

  Future<Either<ExtendedErrors, Webhook>> getWebhooks(int adminId);
}
