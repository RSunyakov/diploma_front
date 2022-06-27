import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/admin/admin.dart';
import 'package:sphere/data/dto/balance/balance.dart';
import 'package:sphere/data/dto/achievements/achievement.dart';
import 'package:sphere/data/dto/achievements/single_achievement.dart';
import 'package:sphere/data/dto/achievements/skills_list.dart';
import 'package:sphere/data/dto/cities/cities.dart';
import 'package:sphere/data/dto/countries/countries.dart';
import 'package:sphere/data/dto/fetch_code.dart';
import 'package:sphere/data/dto/followers_follows/followers_follows.dart';
import 'package:sphere/data/dto/global_search/goal_search.dart';
import 'package:sphere/data/dto/global_search/post_search.dart';
import 'package:sphere/data/dto/posts/task.dart';
import 'package:sphere/data/dto/question/question.dart';
import 'package:sphere/data/dto/reports/report_detail.dart';
import 'package:sphere/data/dto/reports/reports.dart';
import 'package:sphere/data/dto/global_search/user_search.dart';
import 'package:sphere/data/dto/occupation/occupation_study.dart';
import 'package:sphere/data/dto/occupation/occupation_hobby.dart';
import 'package:sphere/data/dto/posts/comment.dart';
import 'package:sphere/data/dto/posts/goal.dart';
import 'package:sphere/data/dto/posts/post.dart';
import 'package:sphere/data/dto/occupation/occupation_work.dart';
import 'package:sphere/data/dto/sign_in/sign_in.dart';
import 'package:sphere/data/dto/simple_message.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/data/dto/user/user.dart';
import 'package:sphere/data/dto/user_settings/user_settings.dart';
import 'package:sphere/data/dto/notifications/notifications.dart';
import 'package:sphere/data/dto/user_skills/user_skills.dart';
import 'package:sphere/data/dto/users/user.dart';
import 'package:sphere/data/dto/webhook/webhook.dart';
import 'package:sphere/data/repository/remote/src/http/api_client.dart';
import 'package:sphere/domain/admin/admin.dart';
import 'package:sphere/domain/balance/balance.dart';
import 'package:sphere/domain/achievement/achievement.dart';
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
import 'package:sphere/domain/country/country.dart';
import 'package:sphere/domain/test/test.dart';
import 'package:sphere/domain/users/user_domain.dart';
import 'package:sphere/domain/webhook/webhook.dart';
import 'package:sphere/logic/profile/occupation_bloc/occupation_bloc.dart';
import 'package:vfx_flutter_common/utils.dart';

import '../../../../domain/city/city.dart';
import '../../../../domain/country/country.dart';
import '../../../../domain/notification/notification.dart';
import '../../../../domain/user_settings/user_settings.dart';
import '../../../../domain/user_skills/user_skills.dart';
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
  Future<Either<ExtendedErrors, SimpleMessage>> fetchCode(
      {required NonEmptyString login}) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final body = FetchCodeBody(login: login.getOrElse());
      final dto = await client.sendCode(body);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, SignIn>> signIn(
      {required NonEmptyString login, required NonEmptyString code}) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final body = SignInBody(login: login.getOrElse(), code: code.getOrElse());
      final dto = await client.signIn(body);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<void> logOut() async {
    final client = _client.getClient();
    await client.logOut();
  }

  @override
  Future<Either<ExtendedErrors, UserSettings>> getUserSettings() async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getUserSettings();
      final domain = dto.toDomain();
      return domain;
    });
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
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.updateUserSettings(
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
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<Country>>> getCountries() async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getCountries();
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<City>>> getCities(int countryId) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getCities(countryId);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<OrOccupations> getOccupations(Type tag) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      OrOccupations domain = left(ExtendedErrors.simple('Not initialized'));
      if (tag == StudyOccupation) {
        final dto = await client.getEducationList();
        domain = dto.toDomain();
      } else if (tag == WorkOccupation) {
        final dto = await client.getCareerList();
        domain = dto.toDomain();
      } else if (tag == HobbyOccupation) {
        final dto = await client.getHobbyList();
        domain = dto.toDomain();
      }
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Occupation>> storeOccupation(
      Occupation value, Type tag) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      if (value.isStudy) {
        final o = value.asStudy;
        o.fold(
          () => null,
          (a) {
            final dto = AddOccupationStudyBody(
              university: a.title.getOrElse(),
              speciality: a.speciality.getOrElse(),
              dateStart: a.beginDateTime.value
                  .fold((l) => now, (r) => r)
                  .formatForBackend,
              dateEnd: o.fold(
                () => null,
                (a) => a.endDateTime.fold(
                  () => null,
                  (a) => a.value.fold(
                    (l) => null,
                    (r) => r.formatForBackend,
                  ),
                ),
              ),
            );
            client.storeEducation(dto);
          },
        );
      } else if (value.isWork) {
        final o = value.asWork;
        final dto = AddOccupationWorkBody(
          companyName: o.fold(() => '', (a) => a.title.getOrElse()),
          positionName: o.fold(() => '', (a) => a.occupation.getOrElse()),
          dateStart: o.fold(
              () => '',
              (a) =>
                  a.beginDateTime.value.getOrElse(() => now).formatForBackend),
          dateEnd: o.fold(
            () => '',
            (a) => a.endDateTime
                .fold(() => now, (a) => a.value.getOrElse(() => now))
                .formatForBackend,
          ),
        );
        await client.storeCareer(dto);
      } else if (value.isHobby) {
        final o = value.asHobby;
        final dto = AddOccupationHobbyBody(
          title: o.fold(() => '', (a) => a.title.getOrElse()),
        );
        await client.storeHobby(dto);
      }

      return right(value);
    });
  }

  @override
  Future<Either<ExtendedErrors, Unit>> deleteOccupation(
      int id, Type tag) async {
    return _safeFunc(() async {
      final client = _client.getClient();

      if (tag == StudyOccupation) {
        await client.deleteEducation(id);
      } else if (tag == WorkOccupation) {
        await client.deleteCareer(id);
      } else if (tag == HobbyOccupation) {
        await client.deleteHobby(id);
      } else {
        return left(ExtendedErrors.simple('Not realized $tag'));
      }
      return right(unit);
    });
  }

  @override
  Future<Either<ExtendedErrors, Occupation>> editOccupation(
      Occupation value, Type tag) {
    return _safeFunc(() async {
      final client = _client.getClient();

      if (value.isStudy) {
        final o = value.asStudy;
        o.fold(
          () => null,
          (a) {
            final dto = AddOccupationStudyBody(
              university: a.title.getOrElse(),
              speciality: a.speciality.getOrElse(),
              dateStart: a.beginDateTime.value
                  .fold((l) => now, (r) => r)
                  .formatForBackend,
              dateEnd: o.fold(
                () => null,
                (a) => a.endDateTime.fold(
                  () => null,
                  (a) => a.value.fold(
                    (l) => null,
                    (r) => r.formatForBackend,
                  ),
                ),
              ),
            );
            client.updateEducation(id: o.fold(() => 0, (a) => a.id), body: dto);
          },
        );
      } else if (value.isWork) {
        final o = value.asWork;
        await client.editCareer(
            id: o.fold(() => 0, (a) => a.id),
            companyName: o.fold(() => '', (a) => a.title.getOrElse()),
            positionName: o.fold(() => '', (a) => a.occupation.getOrElse()),
            dateStart: o.fold(
              () => '',
              (a) =>
                  a.beginDateTime.value.getOrElse(() => now).formatForBackend,
            ),
            dateEnd: o.fold(
              () => '',
              (a) => a.endDateTime
                  .fold(() => now, (a) => a.value.getOrElse(() => now))
                  .formatForBackend,
            ));
      } else if (value.isHobby) {}

      return right(value);
    });
  }

  @override
  Future<Either<ExtendedErrors, List<Post>>> getCommonPosts() async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getCommonPosts();
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<Post>>> getFollowsPosts() async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getFollowsPosts();
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<Achievement>>>
      getAchievementsList() async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getAchievementsList();
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Unit>> deleteAchievement(int id) {
    return _safeFunc(() async {
      final client = _client.getClient();
      await client.deleteAchievement(id);
      return right(unit);
    });
  }

  @override
  Future<Either<ExtendedErrors, Achievement>> storeAchievement(
      AddAchievementBody value) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.storeAchievement(value);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<Skill>>> getSkillsList() async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getSkillsList();
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, UserSettings>> updateUserLogin({
    required String login,
    required String oldCode,
    required String newCode,
  }) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.updateUserLogin(
          login: login, oldCode: oldCode, newCode: newCode);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<Notification>>> getNotifications() async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getNotifications();
      final domain = dto.toDomain();
      return domain;
    });
  }


  @override
  Future<Either<ExtendedErrors, List<UserSkills>>> getUserSkills() async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getUserSkills();
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, SimpleMessage>> deleteUserSkill(int id) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.deleteUserSkill(id);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Unit>> storeUserSkill(AddUserSkillBody value) {
    return _safeFunc(() async {
      final client = _client.getClient();
      await client.storeUserSkill(value);
      return right(unit);
    });
  }

  @override
  Future<Either<ExtendedErrors, List<UserInfo>>> getUsersFromSearch(
      String? searchText) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getUsersFromSearch(text: searchText);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, SimpleMessage>> followUser(
      NonEmptyString uuid) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final path = uuid.getOrElse();
      final dto = await client.followUser(path);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Balance>> getBalance() async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getBalance();
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<FollowersFollows>>> getFollowers() async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getFollowers();
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, SimpleMessage>> removeFollowers(
      String uuid) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.removeFollowers(uuid);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<FollowersFollows>>> getFollows() async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getFollows();
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, SimpleMessage>> removeFollows(
      String uuid) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.removeFollows(uuid);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Goal>> showGoal(int goalId) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.showGoal(goalId);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Comment>> storeComment(
      CommentBody value) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.storeComment(value);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<Goal>>> searchGoals(
      String? searchText) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.searchGoals(text: searchText);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<Post>>> searchPosts(
      String? searchText) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.searchPosts(text: searchText);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<Post>>> searchUserPosts(
      String? searchText) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.searchUserPosts(text: searchText);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, List<Report>>> getReports() async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getReports();
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Report>> getReportDetail(int id) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getReportDetail(id);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, SimpleMessage>> storeReport(
      {required String title, File? file}) async {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.storeReport(description: title, photo: file);
      debugPrint('$now: RemoteRepositoryImpl.storeReport: $dto');
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, SimpleMessage>> deleteReport(int id) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.deleteReport(id);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, Task>> storeTask(
      {required int goalId, required TaskDataDto body}) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.storeTask(id: goalId, body: body);
      final domain = dto.toDomain();
      return domain;
    });
  }

  @override
  Future<Either<ExtendedErrors, int>> storeGoal(AddGoalBody value) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.storeGoal(body: value);
      return dto.getId();
    });
  }

  @override
  Future<Either<ExtendedErrors, List<Goal>>> getGoalList(int? perPage) {
    return _safeFunc(() async {
      final client = _client.getClient();
      final dto = await client.getGoalList(perPage);
      final domain = dto.toDomain();
      return domain;
    });
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
