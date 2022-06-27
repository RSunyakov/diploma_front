import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sphere/data/dto/achievements/achievement.dart';
import 'package:sphere/data/dto/admin/admin.dart';
import 'package:sphere/data/dto/followers_follows/followers_follows.dart';
import 'package:sphere/data/dto/balance/balance.dart';
import 'package:sphere/data/dto/fetch_code.dart';
import 'package:sphere/data/dto/global_search/goal_search.dart';
import 'package:sphere/data/dto/global_search/post_search.dart';
import 'package:sphere/data/dto/global_search/user_search.dart';
import 'package:sphere/data/dto/occupation/occupation_hobby.dart';
import 'package:sphere/data/dto/occupation/occupation_study.dart';
import 'package:sphere/data/dto/posts/comment.dart';
import 'package:sphere/data/dto/posts/goal.dart';
import 'package:sphere/data/dto/posts/post.dart';
import 'package:sphere/data/dto/occupation/occupation_work.dart';
import 'package:sphere/data/dto/posts/task.dart';
import 'package:sphere/data/dto/question/question.dart';
import 'package:sphere/data/dto/reports/report_detail.dart';
import 'package:sphere/data/dto/reports/reports.dart';
import 'package:sphere/data/dto/sign_in/sign_in.dart';
import 'package:sphere/data/dto/simple_message.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/data/dto/user/user.dart' as tt;
import 'package:sphere/data/dto/achievements/skills_list.dart';
import 'package:sphere/data/dto/achievements/single_achievement.dart';
import 'package:sphere/data/dto/users/user.dart';
import 'package:sphere/data/dto/webhook/webhook.dart';

import '../../../../dto/cities/cities.dart';
import '../../../../dto/countries/countries.dart';
import '../../../../dto/notifications/notifications.dart';
import '../../../../dto/user_settings/user_settings.dart';
import '../../../../dto/user_skills/user_skills.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @POST('/api/code')
  Future<SimpleMessageDto> sendCode(@Body() FetchCodeBody body);

  @POST('/api/auth')
  Future<SignInDto> signIn(@Body() SignInBody body);

  @GET('/api/logout')
  Future<void> logOut();

  @GET('/api/profile/settings')
  Future<UserSettingsDto> getUserSettings();

  @MultiPart()
  @POST('/api/profile/settings')
  Future<UserSettingsDto> updateUserSettings({
    @Part(name: 'notifications') String? notifications,
    @Part(name: 'photo', value: 'photo') File? photo,
    @Part(name: 'first_name') String? firstName,
    @Part(name: 'last_name') String? lastName,
    @Part(name: 'gender') String? gender,
    @Part(name: 'birthday') String? birthday,
    @Part(name: 'country_id') int? countryId,
    @Part(name: 'city_id') int? cityId,
    @Part(name: 'is_mentor') String? isMentor,
    @Part(name: 'main_info_visible') String? mainInfoVisible,
    @Part(name: 'statistics_visible') String? statisticsVisible,
    @Part(name: 'search_visible') String? searchVisible,
    @Part(name: 'goals_in_progress_visible') String? goalsInProgressVisible,
    @Part(name: 'achievements_visible') String? achievementsVisible,
    @Part(name: 'goals_complete_visible') String? goalsCompleteVisible,
    @Part(name: 'goals_overdue_visible') String? goalsOverdueVisible,
    @Part(name: 'goals_paused_visible') String? goalsPausedVisible,
    @Part(name: 'goals_details_open') String? goalsDetailsOpen,
    @Part(name: 'goals_favorites_add') String? goalsFavoritesAdd,
    @Part(name: 'goals_copy') String? goalsCopy,
    @Part(name: 'goals_comments_visible') String? goalsCommentsVisible,
    @Part(name: 'goals_comments_write') String? goalsCommentsWrite,
    @Part(name: 'mentoring_offer') String? mentoringOffer,
    @Part(name: 'mentoring_become') String? mentoringBecome,
    @Part(name: 'reports_visible') String? reportsVisible,
    @Part(name: 'reports_comments') String? reportsComments,
  });

  @GET('/api/countries')
  Future<CountriesDto> getCountries();

  @GET('/api/cities')
  Future<CitiesDto> getCities(
    @Query('country_id') int countryId,
  );

  @POST('/api/profile/education')
  Future<AddOccupationStudyDto> storeEducation(
      @Body() AddOccupationStudyBody body);

  @POST('/api/profile/skills/hobby')
  Future<AddOccupationHobbyDto> storeHobby(@Body() AddOccupationHobbyBody body);

  @GET('/api/profile/skills')
  Future<OccupationHobbyDto> getHobbyList();

  @DELETE('/api/profile/skills/{user_skill_id}')
  Future<OccupationHobbyDataDto> deleteHobby(@Path('user_skill_id') int id);

  @GET('/api/posts/follows')
  Future<PostDto> getFollowsPosts();


  @POST('/api/profile/education/{id}')
  Future<AddOccupationStudyDto> updateEducation({
    @Path('id') required int id,
    @Body() required AddOccupationStudyBody body,
  });

  @POST('/api/profile/settings/update_login')
  Future<UserSettingsDto> updateUserLogin({
    @Part(name: 'login') required String login,
    @Part(name: 'first_name') required String oldCode,
    @Part(name: 'last_name') required String newCode,
  });

  @GET('/api/profile/education')
  Future<OccupationStudyDto> getEducationList();

  @DELETE('/api/profile/education/{id}')
  Future<OccupationStudyDataDto> deleteEducation(@Path('id') int id);

  @GET('/api/profile/career')
  Future<OccupationWorkDto> getCareerList();

  @POST('/api/profile/career')
  Future<AddOccupationWorkDto> storeCareer(@Body() AddOccupationWorkBody body);

  @PUT('/api/profile/career/{id}')
  Future<AddOccupationWorkDto> editCareer({
    @Path('id') required int id,
    @Query('company_name') required String companyName,
    @Query('position_name') required String positionName,
    @Query('date_start') required String dateStart,
    @Query('date_end') String? dateEnd,
  });

  @DELETE('/api/profile/career/{id}')
  Future<OccupationWorkDataDto> deleteCareer(@Path('id') int id);

  @GET('/api/profile/settings/notifications')
  Future<NotificationsDto> getNotifications();

  @GET('/api/profile/skills?mentor=true')
  Future<UserSkillsDto> getUserSkills();

  @POST('/api/profile/skills/mentor')
  Future<SimpleMessageDto> storeUserSkill(@Body() AddUserSkillBody body);

  @DELETE('/api/profile/skills/{user_skill_id}')
  Future<SimpleMessageDto> deleteUserSkill(@Path('user_skill_id') int id);

  @GET('/api/search/users')
  Future<UserSearchDto> getUsersFromSearch({
    @Query('text') String? text,
  });

  @POST('/api/{user_uuid}/follow')
  Future<SimpleMessageDto> followUser(@Path('user_uuid') String uuid);

  @GET('/api/balance')
  Future<BalanceDto> getBalance();

  @GET('/api/followers?per_page=1000')
  Future<FollowersFollowsDto> getFollowers();

  @POST('/api/{user_uuid}/force_unfollow')
  Future<SimpleMessageDto> removeFollowers(@Path('user_uuid') String uuid);

  @GET('/api/follows?per_page=1000')
  Future<FollowersFollowsDto> getFollows();

  @POST('/api/{user_uuid}/unfollow')
  Future<SimpleMessageDto> removeFollows(@Path('user_uuid') String uuid);

  @GET('/api/posts/common')
  Future<PostDto> getCommonPosts();

  @GET('/api/achievements')
  Future<AchievementDto> getAchievementsList();

  @POST('/api/achievements')
  Future<SingleAchievementDto> storeAchievement(
      @Body() AddAchievementBody body);

  @GET('/api/profile/skills/list')
  Future<SkillsListDto> getSkillsList();

  @DELETE('/api/achievements/{id}')
  Future<AchievementDto> deleteAchievement(@Path('id') int id);

  @GET('/api/goals/{goal_id}')
  Future<GoalDto> showGoal(@Path('goal_id') int goalId);

  @POST('/api/comments')
  Future<CommentDto> storeComment(@Body() CommentBody body);

  @GET('/api/search/goals')
  Future<GoalSearchDto> searchGoals({@Query('text') String? text});

  @GET('/api/search/posts')
  Future<PostSearchDto> searchPosts({@Query('text') String? text});

  @GET('/api/search/my_posts')
  Future<PostSearchDto> searchUserPosts({@Query('text') String? text});

  @GET('/api/reports')
  Future<ReportsDto> getReports();

  @GET('/api/reports/{report_id}')
  Future<ReportDetailDto> getReportDetail(@Path('report_id') int id);

  @DELETE('/api/reports/{report_id}')
  Future<SimpleMessageDto> deleteReport(@Path('report_id') int id);

  @MultiPart()
  @POST('/api/reports')
  Future<SimpleMessageDto> storeReport({
    @Part(name: 'description') required String description,
    @Part(name: 'photo', value: 'photo') File? photo,
  });

  @POST('/api/goals/{goal_id}/tasks')
  Future<TaskDto> storeTask(
      {@Path('goal_id') required int id, @Body() required TaskDataDto body});

  @POST('/api/goals')
  Future<StoreGoalDto> storeGoal({@Body() required AddGoalBody body});

  @GET('/api/goals')
  Future<GoalListDto> getGoalList(@Query('per_page') int? perPage);

  @GET('/questions')
  Future<QuestionListDto> getQuestionList();

  @GET('/tests/all/{id}')
  Future<TestListDto> getTestList({@Path('id') required int id});

  @POST('/tests')
  Future<TestDto> addTest({@Body() required AddTestBody body, @Query('adminId') required int adminId});

  @POST('/questions')
  Future<QuestionDto> addQuestion({@Body() required AddQuestionBody body});

  @POST('/tests/{id}')
  Future<TestDto> addQuestionsToTest({@Path('id') required int id, @Body() required List<AddQuestionBody> body});

  @GET('/users/all/{id}')
  Future<UserListDto> getUsers({@Path('id') required int adminId});

  @POST('/users/{id}')
  Future<UserDto> addTestsToUser({@Path('id') required String id, @Body() required List<TestDataDto> body});

  @POST('/admins/register')
  Future<AdminDto> register({@Body() required AddAdminBody body});

  @POST('/admins/login')
  Future<AdminDto> login({@Body() required AddAdminBody body});

  @GET('/admins/{id}/url')
  Future<WebhookDto> getWebhooks({@Path('id') required int id});
}
