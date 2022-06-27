import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/achievements/achievement.dart';
import 'package:sphere/data/dto/admin/admin.dart';
import 'package:sphere/data/dto/posts/comment.dart';
import 'package:sphere/data/dto/posts/goal.dart';
import 'package:sphere/data/dto/posts/task.dart';
import 'package:sphere/data/dto/question/question.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/data/dto/user_skills/user_skills.dart';
import 'package:sphere/domain/achievement/achievement.dart';
import 'package:sphere/domain/admin/admin.dart';
import 'package:sphere/domain/auth_data/auth_data.dart';
import 'package:sphere/domain/balance/balance.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/simple_message.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/followers_follows/followers_follows.dart';
import 'package:sphere/domain/notification/notification.dart';
import 'package:sphere/domain/occupation/occupation.dart';
import 'package:sphere/domain/post/comment.dart';
import 'package:sphere/domain/post/goal.dart';
import 'package:sphere/domain/post/post.dart';
import 'package:sphere/domain/post/skill.dart';
import 'package:sphere/domain/post/task.dart';
import 'package:sphere/domain/question/question.dart';
import 'package:sphere/domain/reports/report.dart';
import 'package:sphere/domain/sign_in/sign_in.dart';
import 'package:sphere/domain/test/test.dart';
import 'package:sphere/domain/users/user_domain.dart';
import 'package:sphere/domain/webhook/webhook.dart';
import 'package:sphere/logic/profile/occupation_bloc/occupation_bloc.dart';

import '../../domain/city/city.dart';
import '../../domain/country/country.dart';
import '../../domain/user_settings/user_settings.dart';
import '../../domain/user_skills/user_skills.dart';

abstract class Repository extends ChangeNotifier {
  Future<Either<ExtendedErrors, SimpleMessage>> fetchCode({
    required NonEmptyString login,
  });

  Future<Either<ExtendedErrors, SignIn>> signIn(
      {required NonEmptyString login, required NonEmptyString code});

  Future<void> logOut();

  Future<Either<ExtendedErrors, UserSettings>> getUserSettings();

  Future<Either<ExtendedErrors, UserSettings>> updateUserSettings({
    String? firstName,
    String? lastName,
    String? gender,
    String? birthday,
    File? photo,
    int? countryId,
    int? cityId,
    String? isMentor,
    String? notifications,
    String? mainInfoVisible,
    String? statisticsVisible,
    String? searchVisible,
    String? goalsInProgressVisible,
    String? achievementsVisible,
    String? goalsCompleteVisible,
    String? goalsOverdueVisible,
    String? goalsPausedVisible,
    String? goalsDetailsOpen,
    String? goalsFavoritesAdd,
    String? goalsCopy,
    String? goalsCommentsVisible,
    String? goalsCommentsWrite,
    String? mentoringOffer,
    String? mentoringBecome,
    String? reportsVisible,
    String? reportsComments,
  });

  Future<Either<String, Unit>> writeAuthMethod(AuthMethod value);

  Future<Either<String, AuthMethod>> readAuthMethod();

  Future<Either<ExtendedErrors, List<Country>>> getCountries();

  Future<Either<ExtendedErrors, List<City>>> getCities(int countryId);

  Future<OrOccupations> fetchOccupations(Type tag);

  Future<Either<ExtendedErrors, Occupation>> addOccupation(
      Occupation value, Type tag);

  Future<Either<ExtendedErrors, Occupation>> editOccupation(
      Occupation value, Type tag);

  Future<Either<ExtendedErrors, Unit>> deleteOccupation(int id, Type tag);

  Future<Either<ExtendedErrors, UserSettings>> updateUserLogin({
    required String login,
    required String oldCode,
    required String newCode,
  });

  Future<Either<ExtendedErrors, List<Post>>> getFollowsPosts();

  Future<Either<ExtendedErrors, List<Notification>>> getNotifications();

  Future<Either<ExtendedErrors, List<UserSkills>>> getUserSkills();

  Future<Either<ExtendedErrors, SimpleMessage>> deleteUserSkill(int id);

  Future<Either<ExtendedErrors, Unit>> storeUserSkill(AddUserSkillBody value);

  Future<Either<ExtendedErrors, Occupation>> saveOccupation(
      Occupation value, Type tag);

  Future<Either<ExtendedErrors, List<Post>>> getCommonPosts();

  Future<Either<ExtendedErrors, List<Achievement>>> getAchievementsList();

  Future<Either<ExtendedErrors, Unit>> deleteAchievement(int id);

  Future<Either<ExtendedErrors, Achievement>> storeAchievement(
      AddAchievementBody value);

  Future<Either<ExtendedErrors, List<Skill>>> getSkillsList();

  Future<Either<ExtendedErrors, List<UserInfo>>> getUsersFromSearch(
      String? searchText);

  Future<Either<ExtendedErrors, SimpleMessage>> followUser(NonEmptyString uuid);

  Future<Either<ExtendedErrors, Balance>> getBalance();

  Future<Either<ExtendedErrors, List<FollowersFollows>>> getFollowers();
  Future<Either<ExtendedErrors, SimpleMessage>> removeFollowers(String uuid);
  Future<Either<ExtendedErrors, List<FollowersFollows>>> getFollows();
  Future<Either<ExtendedErrors, SimpleMessage>> removeFollows(String uuid);

  Future<Either<ExtendedErrors, Goal>> showGoal(int goalId);

  Future<Either<ExtendedErrors, Comment>> storeComment(CommentBody value);

  Future<Either<ExtendedErrors, List<Goal>>> searchGoals(String? searchText);

  Future<Either<ExtendedErrors, List<Post>>> searchPost(String? searchText);

  Future<Either<ExtendedErrors, List<Post>>> searchUserPosts(
      String? searchText);

  Future<Either<ExtendedErrors, List<Report>>> getReports();
  Future<Either<ExtendedErrors, Report>> getReportDetail(int id);
  Future<Either<ExtendedErrors, SimpleMessage>> storeReport(
      {required String title, File? file});
  Future<Either<ExtendedErrors, SimpleMessage>> deleteReport(int id);

  Future<Either<ExtendedErrors, Task>> storeTask(
      {required int goalId, required TaskDataDto body});

  Future<Either<ExtendedErrors, int>> storeGoal(AddGoalBody value);

  Future<Either<ExtendedErrors, List<Goal>>> getGoalList(int? perPage);

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
