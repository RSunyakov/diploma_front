import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/posts/comment.dart';
import 'package:sphere/data/dto/posts/skill.dart';
import 'package:sphere/data/dto/posts/task.dart';
import 'package:sphere/data/dto/reports/report.dart';
import 'package:sphere/data/dto/user/user.dart';
import 'package:sphere/domain/city/city.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/country/country.dart';
import 'package:sphere/domain/post/comment.dart';
import 'package:sphere/domain/post/goal.dart';
import 'package:sphere/domain/post/skill.dart';
import 'package:sphere/domain/post/task.dart';
import 'package:sphere/domain/reports/report.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';
import 'package:sphere/ui/shared/all_shared.dart';

part 'goal.g.dart';

@JsonSerializable()
class GoalDto {
  GoalDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  GoalDataDto? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory GoalDto.fromJson(Map<String, dynamic> json) =>
      _$GoalDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GoalDtoToJson(this);
}

@JsonSerializable()
class GoalListDto {
  GoalListDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  List<GoalDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory GoalListDto.fromJson(Map<String, dynamic> json) =>
      _$GoalListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GoalListDtoToJson(this);
}

@JsonSerializable()
class GoalDataDto {
  int? id;
  String? title;
  String? type;
  String? status;
  num? progress;
  String? startAt;
  String? deadlineAt;
  String? pausedAt;

  //TODO(syyunek): уточнить, возможно не [UserDataDto] здесь
  UserDataDto? mentor;
  SkillDataDto? skill;

  //TODO(syyunek): уточнить, возможно здесь не [String]
  List<String>? tags;
  List<TaskDataDto>? tasks;
  List<CommentDataDto>? comments;
  List<ReportDataDto>? reports;

  GoalDataDto({
    this.id,
    this.title,
    this.type,
    this.status,
    this.progress,
    this.startAt,
    this.deadlineAt,
    this.pausedAt,
    this.mentor,
    this.skill,
    this.tags,
    this.tasks,
    this.comments,
    this.reports,
  });

  factory GoalDataDto.fromJson(Map<String, dynamic> json) =>
      _$GoalDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GoalDataDtoToJson(this);
}

extension GoalDtoX on GoalDto {
  Either<ExtendedErrors, Goal> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('Common Posts: data is null'));
      }
      final domain = StaticGoal.goalFromData(data);
      return Right(domain);
    } on Error catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on CheckedFromJsonException catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on Exception catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    }
  }
}

@JsonSerializable()
class AddGoalBody {
  AddGoalBody(
      {required this.title,
      required this.type,
      required this.skillId,
      required this.startAt,
      required this.deadlineAt});

  final String title;
  final String type;
  final int skillId;
  final String startAt;
  final String deadlineAt;

  factory AddGoalBody.fromJson(Map<String, dynamic> json) =>
      _$AddGoalBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AddGoalBodyToJson(this);
}

@JsonSerializable()
class StoreGoalDto {
  StoreGoalDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  StoreGoalDataDto? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory StoreGoalDto.fromJson(Map<String, dynamic> json) =>
      _$StoreGoalDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StoreGoalDtoToJson(this);
}

@JsonSerializable()
class StoreGoalDataDto {
  StoreGoalDataDto({
    required this.id,
  });

  final int id;

  factory StoreGoalDataDto.fromJson(Map<String, dynamic> json) =>
      _$StoreGoalDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StoreGoalDataDtoToJson(this);
}

extension StoreGoalDtoX on StoreGoalDto {
  Either<ExtendedErrors, int> getId() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('Store Goal: data is null'));
      }
      return Right(data!.id);
    } on Error catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on CheckedFromJsonException catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on Exception catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    }
  }
}

extension GoalListDtoX on GoalListDto {
  Either<ExtendedErrors, List<Goal>> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('Store Goal: data is null'));
      }
      return Right(data!.map((e) => StaticGoal.goalFromData(e)).toList());
    } on Error catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on CheckedFromJsonException catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on Exception catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    }
  }
}

class StaticGoal {
  static Goal goalFromData(GoalDataDto? data) {
    return Goal(
        id: data!.id ?? 0,
        title: NonEmptyString(data.title ?? ''),
        type: NonEmptyString(data.type ?? ''),
        status: NonEmptyString(data.status ?? ''),
        progress: data.progress ?? 0,
        startAt: data.startAt?.dateTimeFromBackend ?? DateTime.now(),
        deadlineAt: data.deadlineAt?.dateTimeFromBackend ?? DateTime.now(),
        mentor: some(UserInfo(
            uuid: NonEmptyString(data.mentor?.uuid ?? ''),
            photo: NonEmptyString(data.mentor?.photo ?? ''),
            email: Email.tagged(data.mentor?.email ?? ''),
            phone: NonEmptyString(data.mentor?.phone ?? ''),
            age: data.mentor?.age ?? 0,
            gender: NonEmptyString(''),
            isBanned: false,
            firstName: NonEmptyString(data.mentor?.firstName ?? ''),
            lastName: NonEmptyString(data.mentor?.lastName ?? ''),
            birthday: NonEmptyString(''),
            joinedAt: NonEmptyString(data.mentor?.joinedAt ?? ''),
            country: Country.empty,
            city: City.empty,
            isMentor: data.mentor?.isMentor ?? false)),
        skill: Skill(
          id: data.skill?.id ?? 0,
          title: NonEmptyString(data.skill?.title ?? ''),
          isAllowed: data.skill?.isAllowed ?? false,
        ),
        tags: data.tags?.map((e) => e).toList() ?? [''],
        tasks: data.tasks
                ?.map((x) => Task(
                      id: x.id ?? 0,
                      title: NonEmptyString(x.title ?? ''),
                      comment: NonEmptyString(x.comment ?? ''),
                      schedule: NonEmptyString(x.schedule ?? ''),
                      isCompleted: x.isCompleted ?? false,
                      startAt: some(
                          x.startAt?.dateTimeFromBackend ?? DateTime.now()),
                      deadlineAt: some(
                          x.deadlineAt?.dateTimeFromBackend ?? DateTime.now()),
                    ))
                .toList() ??
            <Task>[],
        comments: data.comments
                ?.map((x) => Comment(
                    id: x.id ?? 0,
                    body: NonEmptyString(x.body ?? ''),
                    createdAt:
                        x.createdAt?.dateTimeFromBackend ?? DateTime.now(),
                    updatedAt:
                        x.updatedAt?.dateTimeFromBackend ?? DateTime.now(),
                    user: some(UserInfo(
                        isBanned: false,
                        phone: NonEmptyString(x.user?.phone ?? ''),
                        email: Email(x.user?.email ?? ''),
                        firstName: NonEmptyString(x.user?.firstName ?? ''),
                        joinedAt: NonEmptyString(x.user?.joinedAt ?? ''),
                        uuid: NonEmptyString(x.user?.uuid ?? ''),
                        lastName: NonEmptyString(x.user?.lastName ?? ''),
                        birthday: NonEmptyString(''),
                        isMentor: x.user?.isMentor ?? false,
                        age: x.user?.age ?? 0,
                        city: City(
                          id: x.user?.city?.id ?? 0,
                          name: NonEmptyString(x.user?.city?.name ?? ''),
                        ),
                        photo: NonEmptyString(x.user?.photo ?? ''),
                        country: Country(
                            id: x.user?.country?.id ?? 0,
                            name: NonEmptyString(x.user?.country?.name ?? '')),
                        gender: NonEmptyString(''))),
                    replies: some(x.replies
                            ?.map((z) => Comment(
                                id: z.id ?? 0,
                                body: NonEmptyString(z.body ?? ''),
                                createdAt: z.createdAt?.dateTimeFromBackend ??
                                    DateTime.now(),
                                updatedAt: z.updatedAt?.dateTimeFromBackend ??
                                    DateTime.now(),
                                user: some(UserInfo(
                                    isBanned: false,
                                    phone: NonEmptyString(z.user?.phone ?? ''),
                                    email: Email(z.user?.email ?? ''),
                                    firstName:
                                        NonEmptyString(z.user?.firstName ?? ''),
                                    joinedAt:
                                        NonEmptyString(z.user?.joinedAt ?? ''),
                                    uuid: NonEmptyString(z.user?.uuid ?? ''),
                                    lastName:
                                        NonEmptyString(z.user?.lastName ?? ''),
                                    birthday: NonEmptyString(''),
                                    isMentor: z.user?.isMentor ?? false,
                                    age: z.user?.age ?? 0,
                                    city: City(
                                      id: z.user?.city?.id ?? 0,
                                      name: NonEmptyString(
                                          z.user?.city?.name ?? ''),
                                    ),
                                    photo: NonEmptyString(z.user?.photo ?? ''),
                                    country: Country(
                                        id: z.user?.country?.id ?? 0,
                                        name: NonEmptyString(
                                            z.user?.country?.name ?? '')),
                                    gender: NonEmptyString(''))),
                                replies: none()))
                            .toList() ??
                        <Comment>[])))
                .toList() ??
            <Comment>[],
        reports: some(data.reports
                ?.map((e) => Report(
                    id: e.id ?? 0,
                    description: NonEmptyString(e.description ?? ''),
                    file: NonEmptyString(e.file ?? ''),
                    createdAt:
                        e.createdAt?.dateTimeFromBackend ?? DateTime.now(),
                    commentsCount: e.commentsCount ?? 0))
                .toList() ??
            <Report>[]));
  }
}
