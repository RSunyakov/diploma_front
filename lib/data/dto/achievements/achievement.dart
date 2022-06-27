import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/posts/goal.dart';
import 'package:sphere/data/dto/posts/skill.dart';
import 'package:sphere/domain/achievement/achievement.dart';
import 'package:sphere/domain/city/city.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/country/country.dart';
import 'package:sphere/domain/post/comment.dart';
import 'package:sphere/domain/post/goal.dart';
import 'package:sphere/domain/post/skill.dart';
import 'package:sphere/domain/post/task.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';

part 'achievement.g.dart';

@JsonSerializable()
class AchievementDto {
  AchievementDto({
    required this.status,
    this.countAuto,
    this.countManual,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  int? countAuto;
  int? countManual;
  List<AchievementDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory AchievementDto.fromJson(Map<String, dynamic> json) =>
      _$AchievementDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AchievementDtoToJson(this);
}

@JsonSerializable()
class AchievementDataDto {
  AchievementDataDto({
    this.id,
    this.title,
    this.description,
    this.date,
    this.auto,
    this.goal,
    this.goalUrl,
    this.skill,
  });

  int? id;
  String? title;
  String? description;
  String? date;
  bool? auto;
  GoalDataDto? goal;
  String? goalUrl;
  SkillDataDto? skill;

  factory AchievementDataDto.fromJson(Map<String, dynamic> json) =>
      _$AchievementDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AchievementDataDtoToJson(this);
}

extension AchievemenDtoX on AchievementDto {
  Either<ExtendedErrors, List<Achievement>> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('AchievementDto: data is null'));
      }
      final domain = data!
          .map((e) => Achievement(
                id: e.id ?? 0,
                title: NonEmptyString(e.title ?? ''),
                description: NonEmptyString(e.description ?? ''),
                date: DateFormat('dd-MM-yyyy').parse(e.date ?? ''),
                goal: e.goal != null
                    ? some(Goal(
                        id: e.goal?.id ?? 0,
                        title: NonEmptyString(e.goal?.title ?? ''),
                        type: NonEmptyString(e.goal?.type ?? ''),
                        status: NonEmptyString(e.goal?.status ?? ''),
                        progress: e.goal?.progress ?? 0,
                        startAt: DateFormat('dd-MM-yyyy')
                            .parse(e.goal?.startAt ?? ''),
                        deadlineAt: DateFormat('dd-MM-yyyy')
                            .parse(e.goal?.deadlineAt ?? ''),
                        pausedAt: DateFormat('dd-MM-yyyy')
                            .parse(e.goal?.pausedAt ?? ''),
                        mentor: some(UserInfo(
                          uuid: NonEmptyString(e.goal?.mentor?.uuid ?? ''),
                          photo: NonEmptyString(e.goal?.mentor?.photo ?? ''),
                          email: Email.tagged(e.goal?.mentor?.email ?? ''),
                          phone: NonEmptyString(e.goal?.mentor?.phone ?? ''),
                          age: e.goal?.mentor?.age ?? 0,
                          gender: NonEmptyString(''),
                          isBanned: false,
                          firstName:
                              NonEmptyString(e.goal?.mentor?.firstName ?? ''),
                          middleName: e.goal?.mentor?.middleName ?? '',
                          lastName:
                              NonEmptyString(e.goal?.mentor?.lastName ?? ''),
                          geo: e.goal?.mentor?.geo ?? '',
                          birthday: NonEmptyString(''),
                          joinedAt:
                              NonEmptyString(e.goal?.mentor?.joinedAt ?? ''),
                          position: e.goal?.mentor?.position ?? '',
                          country: Country.empty,
                          city: City.empty,
                          isMentor: e.goal?.mentor?.isMentor ?? false,
                        )),
                        skill: Skill(
                          id: e.goal?.skill?.id ?? 0,
                          title: NonEmptyString(e.goal?.skill?.title ?? ''),
                          isAllowed: e.goal?.skill?.isAllowed ?? false,
                        ),
                        tags: e.goal?.tags?.map((e) => e).toList() ?? [''],
                        tasks: e.goal?.tasks
                                ?.map((x) => Task(
                                      id: x.id ?? 0,
                                      title: NonEmptyString(x.title ?? ''),
                                      comment: NonEmptyString(x.comment ?? ''),
                                      schedule:
                                          NonEmptyString(x.schedule ?? ''),
                                      isCompleted: x.isCompleted ?? false,
                                      startAt: some(DateFormat('dd-MM-yyyy')
                                          .parse(x.startAt ?? '')),
                                      deadlineAt: some(DateFormat('dd-MM-yyyy')
                                          .parse(x.deadlineAt ?? '')),
                                    ))
                                .toList() ??
                            [Task.empty()],
                        comments: e.goal?.comments
                                ?.map((x) => Comment(
                                    id: x.id ?? 0,
                                    body: NonEmptyString(x.body ?? ''),
                                    createdAt: DateFormat('dd-MM-yyyy')
                                        .parse(x.createdAt ?? ''),
                                    updatedAt: DateFormat('dd-MM-yyyy')
                                        .parse(x.updatedAt ?? ''),
                                    user: some(UserInfo(
                                        isBanned: false,
                                        phone:
                                            NonEmptyString(x.user?.phone ?? ''),
                                        email: Email(x.user?.email ?? ''),
                                        firstName: NonEmptyString(
                                            x.user?.firstName ?? ''),
                                        joinedAt: NonEmptyString(
                                            x.user?.joinedAt ?? ''),
                                        uuid:
                                            NonEmptyString(x.user?.uuid ?? ''),
                                        lastName: NonEmptyString(
                                            x.user?.lastName ?? ''),
                                        birthday: NonEmptyString(''),
                                        isMentor: x.user?.isMentor ?? false,
                                        age: x.user?.age ?? 0,
                                        city: City(
                                          id: x.user?.city?.id ?? 0,
                                          name: NonEmptyString(
                                              x.user?.city?.name ?? ''),
                                        ),
                                        photo:
                                            NonEmptyString(x.user?.photo ?? ''),
                                        country: Country(
                                            id: x.user?.country?.id ?? 0,
                                            name:
                                                NonEmptyString(x.user?.country?.name ?? '')),
                                        gender: NonEmptyString(''))),
                                    replies: some(x.replies!
                                        .map((z) => Comment(
                                            id: z.id ?? 0,
                                            body: NonEmptyString(z.body ?? ''),
                                            createdAt: DateFormat('dd-MM-yyyy').parse(z.createdAt ?? ''),
                                            updatedAt: DateFormat('dd-MM-yyyy').parse(z.updatedAt ?? ''),
                                            user: some(UserInfo(
                                                isBanned: false,
                                                phone: NonEmptyString(z.user?.phone ?? ''),
                                                email: Email(z.user?.email ?? ''),
                                                firstName: NonEmptyString(z.user?.firstName ?? ''),
                                                joinedAt: NonEmptyString(z.user?.joinedAt ?? ''),
                                                uuid: NonEmptyString(z.user?.uuid ?? ''),
                                                lastName: NonEmptyString(z.user?.lastName ?? ''),
                                                birthday: NonEmptyString(''),
                                                isMentor: z.user?.isMentor ?? false,
                                                age: z.user?.age ?? 0,
                                                city: City(
                                                  id: z.user?.city?.id ?? 0,
                                                  name: NonEmptyString(
                                                      z.user?.city?.name ?? ''),
                                                ),
                                                photo: NonEmptyString(z.user?.photo ?? ''),
                                                country: Country(id: z.user?.country?.id ?? 0, name: NonEmptyString(z.user?.country?.name ?? '')),
                                                gender: NonEmptyString(''))),
                                            replies: none()))
                                        .toList())))
                                .toList() ??
                            [Comment.empty],
                        reports: none()))
                    : none(),
                goalUrl: (e.goalUrl ?? '').nonEmpty,
                skill: some(Skill(
                  id: e.skill?.id ?? 0,
                  title: (e.skill?.title ?? '').nonEmpty,
                  isAllowed: e.skill?.isAllowed ?? false,
                )),
              ))
          .toList();
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
class AddAchievementBody with EquatableMixin {
  AddAchievementBody({
    required this.title,
    required this.skillId,
    required this.date,
    this.description,
  });

  final String title;
  final int skillId;
  String date;
  String? description;

  factory AddAchievementBody.fromJson(Map<String, dynamic> json) =>
      _$AddAchievementBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AddAchievementBodyToJson(this);

  @override
  List<Object?> get props => [title, skillId, date, description];
}
