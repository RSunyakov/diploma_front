import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sphere/data/dto/admin/admin.dart';
import 'package:sphere/data/dto/fetch_code.dart';
import 'package:sphere/data/dto/question/question.dart';
import 'package:sphere/data/dto/simple_message.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/data/dto/users/user.dart';
import 'package:sphere/data/dto/webhook/webhook.dart';


part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @POST('/api/code')
  Future<SimpleMessageDto> sendCode(@Body() FetchCodeBody body);

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
