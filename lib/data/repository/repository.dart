import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/core/safe_coding/src/unit.dart';
import 'package:sphere/data/dto/achievements/achievement.dart';
import 'package:sphere/data/dto/admin/admin.dart';
import 'package:sphere/data/dto/posts/comment.dart';
import 'package:sphere/data/dto/posts/goal.dart';
import 'package:sphere/data/dto/posts/task.dart';
import 'package:sphere/data/dto/question/question.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/domain/achievement/achievement.dart';
import 'package:sphere/domain/admin/admin.dart';
import 'package:sphere/domain/auth_data/auth_data.dart';
import 'package:sphere/domain/balance/balance.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/simple_message.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/followers_follows/followers_follows.dart';
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
import 'package:sphere/logic/repository/repository.dart';
import '../../domain/city/city.dart';
import '../../domain/country/country.dart';
import '../../domain/notification/notification.dart';
import '../../domain/user_settings/user_settings.dart';
import '../../domain/user_skills/user_skills.dart';
import '../dto/user_skills/user_skills.dart';
import 'local/local_repository.dart';
import 'remote/remote_repository.dart';

@prod
@LazySingleton(as: Repository)
class RepositoryImpl extends Repository {
  RepositoryImpl(LocalRepository? local, RemoteRepository? remote)
      : _local = local ?? GetIt.I.get(),
        _remote = remote ?? GetIt.I.get();

  final LocalRepository _local;

  // ignore: unused_field
  final RemoteRepository _remote;

  @override
  Future<Either<String, AuthMethod>> readAuthMethod() async {
    return _local.readAuthMethod();
  }

  @override
  Future<Either<String, Unit>> writeAuthMethod(AuthMethod value) async {
    return _local.writeAuthMethod(value);
  }

  @override
  Future<Either<ExtendedErrors, SimpleMessage>> fetchCode(
      {required NonEmptyString login}) async {
    return _remote.fetchCode(login: login);
  }

  @override
  Future<Either<ExtendedErrors, SignIn>> signIn(
      {required NonEmptyString login, required NonEmptyString code}) async {
    return _remote.signIn(login: login, code: code);
  }

  @override
  Future<void> logOut() {
    return _remote.logOut();
  }

  @override
  Future<Either<ExtendedErrors, UserSettings>> getUserSettings() async {
    return _remote.getUserSettings();
  }

  @override
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
  }) async {
    return _remote.updateUserSettings(
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      birthday: birthday,
      photo: photo,
      countryId: countryId,
      cityId: cityId,
      isMentor: isMentor,
      notifications: notifications,
      mainInfoVisible: mainInfoVisible,
      statisticsVisible: statisticsVisible,
      searchVisible: searchVisible,
      goalsInProgressVisible: goalsInProgressVisible,
      achievementsVisible: achievementsVisible,
      goalsCompleteVisible: goalsCompleteVisible,
      goalsOverdueVisible: goalsOverdueVisible,
      goalsPausedVisible: goalsPausedVisible,
      goalsDetailsOpen: goalsDetailsOpen,
      goalsFavoritesAdd: goalsFavoritesAdd,
      goalsCopy: goalsCopy,
      goalsCommentsVisible: goalsCommentsVisible,
      goalsCommentsWrite: goalsCommentsWrite,
      mentoringOffer: mentoringOffer,
      mentoringBecome: mentoringBecome,
      reportsVisible: reportsVisible,
      reportsComments: reportsComments,
    );
  }

  @override
  Future<Either<ExtendedErrors, List<Country>>> getCountries() async {
    return _remote.getCountries();
  }

  @override
  Future<Either<ExtendedErrors, List<City>>> getCities(int countryId) async {
    return _remote.getCities(countryId);
  }

  @override
  Future<OrOccupations> fetchOccupations(Type tag) async {
    return _remote.getOccupations(tag);
    // return _local.fetchOccupations(tag);
  }

  @override
  Future<Either<ExtendedErrors, Occupation>> addOccupation(
      Occupation value, Type tag) async {
    return _remote.storeOccupation(value, tag);
    // return _local.saveOccupations(value, tag);
  }

  @override
  Future<Either<ExtendedErrors, Unit>> deleteOccupation(
      int id, Type tag) async {
    return _remote.deleteOccupation(id, tag);
  }

  @override
  Future<Either<ExtendedErrors, Occupation>> editOccupation(
      Occupation value, Type tag) async {
    return _remote.editOccupation(value, tag);
  }

  @override
  Future<Either<ExtendedErrors, UserSettings>> updateUserLogin({
    required String login,
    required String oldCode,
    required String newCode,
  }) async {
    return _remote.updateUserLogin(
        login: login, oldCode: oldCode, newCode: newCode);
  }

  @override
  Future<Either<ExtendedErrors, List<Post>>> getCommonPosts() {
    return _remote.getCommonPosts();
  }

  @override
  Future<Either<ExtendedErrors, List<Achievement>>> getAchievementsList() {
    return _remote.getAchievementsList();
  }

  @override
  Future<Either<ExtendedErrors, Unit>> deleteAchievement(int id) {
    return _remote.deleteAchievement(id);
  }

  @override
  Future<Either<ExtendedErrors, Achievement>> storeAchievement(
      AddAchievementBody value) async {
    return _remote.storeAchievement(value);
  }

  @override
  Future<Either<ExtendedErrors, List<Skill>>> getSkillsList() {
    return _remote.getSkillsList();
  }

  @override
  Future<Either<ExtendedErrors, Occupation>> saveOccupation(
      Occupation value, Type tag) {
    // TODO: implement saveOccupation
    throw UnimplementedError();
  }

  @override
  Future<Either<ExtendedErrors, List<Post>>> getFollowsPosts() async {
    return _remote.getFollowsPosts();
  }


  @override
  Future<Either<ExtendedErrors, List<Notification>>> getNotifications() async {
    return _remote.getNotifications();
  }

  @override
  Future<Either<ExtendedErrors, List<UserSkills>>> getUserSkills() async {
    return _remote.getUserSkills();
  }

  @override
  Future<Either<ExtendedErrors, SimpleMessage>> deleteUserSkill(int id) {
    return _remote.deleteUserSkill(id);
  }

  @override
  Future<Either<ExtendedErrors, Unit>> storeUserSkill(
      AddUserSkillBody value) async {
    return _remote.storeUserSkill(value);
  }

  @override
  Future<Either<ExtendedErrors, List<FollowersFollows>>> getFollowers() async {
    return _remote.getFollowers();
  }

  @override
  Future<Either<ExtendedErrors, SimpleMessage>> removeFollowers(
      String uuid) async {
    return _remote.removeFollowers(uuid);
  }

  @override
  Future<Either<ExtendedErrors, List<FollowersFollows>>> getFollows() async {
    return _remote.getFollows();
  }

  @override
  Future<Either<ExtendedErrors, SimpleMessage>> removeFollows(
      String uuid) async {
    return _remote.removeFollows(uuid);
  }

  @override
  Future<Either<ExtendedErrors, SimpleMessage>> followUser(
      NonEmptyString uuid) async {
    return _remote.followUser(uuid);
  }

  @override
  Future<Either<ExtendedErrors, Balance>> getBalance() async {
    return _remote.getBalance();
  }

  @override
  Future<Either<ExtendedErrors, List<UserInfo>>> getUsersFromSearch(
      String? searchText) {
    return _remote.getUsersFromSearch(searchText);
  }

  @override
  Future<Either<ExtendedErrors, Goal>> showGoal(int goalId) async {
    return _remote.showGoal(goalId);
  }

  @override
  Future<Either<ExtendedErrors, Comment>> storeComment(
      CommentBody value) async {
    return _remote.storeComment(value);
  }

  @override
  Future<Either<ExtendedErrors, List<Goal>>> searchGoals(
      String? searchText) async {
    return _remote.searchGoals(searchText);
  }

  @override
  Future<Either<ExtendedErrors, List<Post>>> searchPost(
      String? searchText) async {
    return _remote.searchPosts(searchText);
  }

  @override
  Future<Either<ExtendedErrors, List<Post>>> searchUserPosts(
      String? searchText) async {
    return _remote.searchUserPosts(searchText);
  }

  @override
  Future<Either<ExtendedErrors, List<Report>>> getReports() async {
    return _remote.getReports();
  }

  @override
  Future<Either<ExtendedErrors, Report>> getReportDetail(int id) async {
    return _remote.getReportDetail(id);
  }

  @override
  Future<Either<ExtendedErrors, SimpleMessage>> storeReport(
      {required String title, File? file}) async {
    return _remote.storeReport(title: title, file: file);
  }

  @override
  Future<Either<ExtendedErrors, SimpleMessage>> deleteReport(int id) async {
    return _remote.deleteReport(id);
  }

  @override
  Future<Either<ExtendedErrors, Task>> storeTask(
      {required int goalId, required TaskDataDto body}) {
    return _remote.storeTask(goalId: goalId, body: body);
  }

  @override
  Future<Either<ExtendedErrors, int>> storeGoal(AddGoalBody value) {
    return _remote.storeGoal(value);
  }

  @override
  Future<Either<ExtendedErrors, List<Goal>>> getGoalList(int? perPage) {
    return _remote.getGoalList(perPage);
  }

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
