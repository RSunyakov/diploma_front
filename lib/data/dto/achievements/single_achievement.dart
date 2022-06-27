import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/achievements/achievement.dart';
import 'package:sphere/data/dto/posts/goal.dart';
import 'package:sphere/data/dto/posts/skill.dart';
import 'package:sphere/domain/city/city.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/country/country.dart';
import 'package:sphere/domain/post/comment.dart';
import 'package:sphere/domain/post/goal.dart';
import 'package:sphere/domain/post/skill.dart';
import 'package:sphere/domain/post/task.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';

import '../../../domain/achievement/achievement.dart';

part 'single_achievement.g.dart';

@JsonSerializable()
class SingleAchievementDto {
  SingleAchievementDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  AchievementDataDto? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory SingleAchievementDto.fromJson(Map<String, dynamic> json) =>
      _$SingleAchievementDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SingleAchievementDtoToJson(this);
}

@JsonSerializable()
class SingleAchievementDataDto {
  SingleAchievementDataDto({
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

  factory SingleAchievementDataDto.fromJson(Map<String, dynamic> json) =>
      _$SingleAchievementDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SingleAchievementDataDtoToJson(this);
}

extension SingleAchievementDtoX on SingleAchievementDto {
  Either<ExtendedErrors, Achievement> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('AchievementDto: data is null'));
      }
      final domain = Achievement(
        id: data!.id ?? 0,
        title: NonEmptyString(data!.title ?? ''),
        description: NonEmptyString(data!.description ?? ''),
        date: DateFormat('dd-MM-yyyy').parse(data!.date ?? ''),
        goal: data!.goal != null
            ? some(Goal(
                id: data!.goal!.id ?? 0,
                title: NonEmptyString(data!.goal!.title ?? ''),
                type: NonEmptyString(data!.goal!.type ?? ''),
                status: NonEmptyString(data!.goal!.status ?? ''),
                progress: data!.goal!.progress ?? 0,
                startAt:
                    DateFormat('dd-MM-yyyy').parse(data!.goal!.startAt ?? ''),
                deadlineAt: DateFormat('dd-MM-yyyy')
                    .parse(data!.goal!.deadlineAt ?? ''),
                pausedAt:
                    DateFormat('dd-MM-yyyy').parse(data!.goal!.pausedAt ?? ''),
                mentor: some(UserInfo(
                  uuid: NonEmptyString(data!.goal!.mentor?.uuid ?? ''),
                  photo: NonEmptyString(data!.goal!.mentor?.photo ?? ''),
                  email: Email.tagged(data!.goal!.mentor?.email ?? ''),
                  phone: NonEmptyString(data!.goal!.mentor?.phone ?? ''),
                  age: data!.goal!.mentor?.age ?? 0,
                  gender: NonEmptyString(''),
                  isBanned: false,
                  firstName:
                      NonEmptyString(data!.goal!.mentor?.firstName ?? ''),
                  middleName: data!.goal!.mentor?.middleName ?? '',
                  lastName: NonEmptyString(data!.goal!.mentor?.lastName ?? ''),
                  geo: data!.goal!.mentor?.geo ?? '',
                  birthday: NonEmptyString(''),
                  joinedAt: NonEmptyString(data!.goal!.mentor?.joinedAt ?? ''),
                  position: data!.goal!.mentor?.position ?? '',
                  country: Country.empty,
                  city: City.empty,
                  isMentor: data!.goal!.mentor?.isMentor ?? false,
                )),
                skill: Skill(
                  id: data!.goal!.skill?.id ?? 0,
                  title: NonEmptyString(data!.goal!.skill?.title ?? ''),
                  isAllowed: data!.goal!.skill?.isAllowed ?? false,
                ),
                tags: data!.goal!.tags?.map((e) => e).toList() ?? [''],
                tasks: data!.goal!.tasks
                        ?.map((x) => Task(
                              id: x.id ?? 0,
                              title: NonEmptyString(x.title ?? ''),
                              comment: NonEmptyString(x.comment ?? ''),
                              schedule: NonEmptyString(x.schedule ?? ''),
                              isCompleted: x.isCompleted ?? false,
                              startAt: some(DateFormat('dd-MM-yyyy')
                                  .parse(x.startAt ?? '')),
                              deadlineAt: some(DateFormat('dd-MM-yyyy')
                                  .parse(x.deadlineAt ?? '')),
                            ))
                        .toList() ??
                    [Task.empty()],
                comments: data!.goal!.comments
                        ?.map((x) => Comment(
                            id: x.id ?? 0,
                            body: NonEmptyString(x.body ?? ''),
                            createdAt: DateFormat('dd-MM-yyyy')
                                .parse(x.createdAt ?? ''),
                            updatedAt: DateFormat('dd-MM-yyyy')
                                .parse(x.updatedAt ?? ''),
                            user: some(UserInfo(
                                isBanned: false,
                                phone: NonEmptyString(x.user?.phone ?? ''),
                                email: Email(x.user?.email ?? ''),
                                firstName:
                                    NonEmptyString(x.user?.firstName ?? ''),
                                joinedAt:
                                    NonEmptyString(x.user?.joinedAt ?? ''),
                                uuid: NonEmptyString(x.user?.uuid ?? ''),
                                lastName:
                                    NonEmptyString(x.user?.lastName ?? ''),
                                birthday: NonEmptyString(''),
                                isMentor: x.user?.isMentor ?? false,
                                age: x.user?.age ?? 0,
                                city: City(
                                  id: x.user?.city?.id ?? 0,
                                  name:
                                      NonEmptyString(x.user?.city?.name ?? ''),
                                ),
                                photo: NonEmptyString(x.user?.photo ?? ''),
                                country: Country(
                                    id: x.user?.country?.id ?? 0,
                                    name: NonEmptyString(
                                        x.user?.country?.name ?? '')),
                                gender: NonEmptyString(''))),
                            replies: some(x.replies!
                                .map((z) => Comment(
                                    id: z.id ?? 0,
                                    body: NonEmptyString(z.body ?? ''),
                                    createdAt: DateFormat('dd-MM-yyyy')
                                        .parse(z.createdAt ?? ''),
                                    updatedAt: DateFormat('dd-MM-yyyy')
                                        .parse(z.updatedAt ?? ''),
                                    user: some(UserInfo(
                                        isBanned: false,
                                        phone:
                                            NonEmptyString(z.user?.phone ?? ''),
                                        email: Email(z.user?.email ?? ''),
                                        firstName: NonEmptyString(
                                            z.user?.firstName ?? ''),
                                        joinedAt: NonEmptyString(
                                            z.user?.joinedAt ?? ''),
                                        uuid:
                                            NonEmptyString(z.user?.uuid ?? ''),
                                        lastName: NonEmptyString(
                                            z.user?.lastName ?? ''),
                                        birthday: NonEmptyString(''),
                                        isMentor: z.user?.isMentor ?? false,
                                        age: z.user?.age ?? 0,
                                        city: City(
                                          id: z.user?.city?.id ?? 0,
                                          name: NonEmptyString(
                                              z.user?.city?.name ?? ''),
                                        ),
                                        photo:
                                            NonEmptyString(z.user?.photo ?? ''),
                                        country: Country(id: z.user?.country?.id ?? 0, name: NonEmptyString(z.user?.country?.name ?? '')),
                                        gender: NonEmptyString(''))),
                                    replies: none()))
                                .toList())))
                        .toList() ??
                    [Comment.empty],
                reports: none(),
              ))
            : none(),
        goalUrl: NonEmptyString(data!.goalUrl ?? ''),
        skill: some(Skill(
          id: data!.skill?.id ?? 0,
          title: NonEmptyString(data!.skill?.title ?? ''),
          isAllowed: data!.skill?.isAllowed ?? false,
        )),
      );
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
