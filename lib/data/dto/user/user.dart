import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/src/option.dart';
import 'package:sphere/data/dto/achievements/achievement.dart';
import 'package:sphere/data/dto/cities/cities.dart';
import 'package:sphere/data/dto/countries/countries.dart';
import 'package:sphere/data/dto/occupation/occupation_hobby.dart';
import 'package:sphere/data/dto/occupation/occupation_study.dart';
import 'package:sphere/data/dto/occupation/occupation_work.dart';
import 'package:sphere/data/dto/posts/goal.dart';
import 'package:sphere/data/dto/posts/skill.dart';
import 'package:sphere/domain/achievement/achievement.dart';
import 'package:sphere/domain/occupation/occupation.dart';
import 'package:sphere/domain/post/comment.dart';
import 'package:sphere/domain/post/goal.dart';
import 'package:sphere/domain/post/skill.dart';
import 'package:sphere/domain/post/task.dart';
import 'package:sphere/domain/students/students.dart';
import 'package:sphere/ui/shared/app_extensions.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

import '../../../core/safe_coding/src/either.dart';
import '../../../domain/city/city.dart';
import '../../../domain/core/extended_errors.dart';
import '../../../domain/core/value_objects.dart';
import '../../../domain/country/country.dart';
import '../../../domain/user_settings/user_settings.dart';

part 'user.g.dart';

@JsonSerializable()
class UserDto {
  UserDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  UserDataDto? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

@JsonSerializable()
class UserDataDto {
  String? uuid;
  String? email;
  String? phone;
  int? age;
  String? firstName;
  String? lastName;
  String? middleName;
  CountryDataDto? country;
  CityDataDto? city;
  String? geo;
  String? photo;
  String? joinedAt;
  String? position;
  List<GoalDataDto>? goals;
  bool? isMentor;
  num? rating;
  String? url;
  List<OccupationWorkDataDto>? career;
  List<OccupationStudyDataDto>? education;
  List<OccupationHobbyDataDto>? skillsHobby;
  List<AchievementDataDto>? achievements;
  StudentsDataDto? students;
  bool? alreadyFollow;
  bool? alreadyMentor;
  List<SkillDto>? skillsMentor;

  UserDataDto({
    this.uuid,
    this.email,
    this.phone,
    this.age,
    this.firstName,
    this.lastName,
    this.middleName,
    this.country,
    this.city,
    this.geo,
    this.photo,
    this.joinedAt,
    this.position,
    this.goals,
    this.career,
    this.education,
    this.skillsHobby,
    this.isMentor,
    this.rating,
    this.url,
    this.achievements,
    this.students,
    this.alreadyFollow,
    this.alreadyMentor,
    this.skillsMentor,
  });

  factory UserDataDto.fromJson(Map<String, dynamic> json) =>
      _$UserDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataDtoToJson(this);
}

@JsonSerializable()
class StudentsDataDto {
  num? count;
  List<UserDataDto>? data;

  StudentsDataDto({
    this.count,
    this.data,
  });

  factory StudentsDataDto.fromJson(Map<String, dynamic> json) =>
      _$StudentsDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StudentsDataDtoToJson(this);
}

extension UserDtoX on UserDto {
  Either<ExtendedErrors, UserInfo> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('Show User Profile: data is null'));
      }

      final domain = UserInfo(
          uuid: NonEmptyString(data!.uuid ?? ''),
          photo: NonEmptyString(data!.photo ?? ''),
          email: Email.tagged(data!.email ?? ''),
          phone: NonEmptyString(data!.phone ?? ''),
          age: data!.age ?? 0,
          gender: NonEmptyString(''),
          isBanned: false,
          firstName: NonEmptyString(data!.firstName ?? ''),
          lastName: NonEmptyString(data!.lastName ?? ''),
          birthday: NonEmptyString(''),
          skillsMentor: data!.skillsMentor
                  ?.map((e) => MentorSkill(
                      id: e.id ?? 0,
                      baseSkill: Skill(
                        id: e.baseSkill?.id ?? 0,
                        title: NonEmptyString(e.baseSkill?.title ?? ''),
                        isAllowed: e.baseSkill?.isAllowed ?? false,
                      ),
                      nestedSkills:
                          e.nestedSkills?.map((e) => Skill(id: e.id ?? 0, title: NonEmptyString(e.title ?? ''), isAllowed: e.isAllowed ?? false)).toList() ??
                              <Skill>[]))
                  .toList() ??
              <MentorSkill>[],
          career: data!.career
              ?.map((e) => Occupation.work(
                  id: e.id ?? 0,
                  title: e.companyName.nonEmpty,
                  occupation: e.positionName.nonEmpty,
                  beginDateTime: beginDateTime(e.dateStart.dateTimeFromBackend),
                  endDateTime: some(endDateTime(e.dateEnd == null
                      ? now
                      : e.dateEnd!.dateTimeFromBackend))))
              .toList()
              .cast<WorkOccupation>(),
          education: data!.education
              ?.map((e) => Occupation.study(
                  id: e.id ?? 0,
                  title: e.university.nonEmpty,
                  speciality: ''.nonEmpty,
                  beginDateTime: beginDateTime(e.dateStart.dateTimeFromBackend),
                  endDateTime:
                      some(endDateTime(e.dateEnd == null ? now : e.dateEnd!.dateTimeFromBackend))))
              .toList()
              .cast<StudyOccupation>(),
          skillsHobby: data!.skillsHobby?.map((e) => Occupation.hobby(id: e.id ?? 0, title: e.title.nonEmpty)).toList().cast<HobbyOccupation>(),
          achievements: data!.achievements
                  ?.map((e) => Achievement(
                        id: e.id ?? 0,
                        title: (e.title ?? '').nonEmpty,
                        description: (e.description ?? '').nonEmpty,
                        date: e.date?.dateTimeFromBackend ?? DateTime.now(),
                        auto: e.auto ?? false,
                        goalUrl: NonEmptyString(e.goalUrl ?? ''),
                        goal: none(),
                        skill: none(),
                      ))
                  .toList() ??
              <Achievement>[],
          joinedAt: NonEmptyString(data!.joinedAt ?? '', failureTag: 'joinedAt'),
          country: Country(id: data!.country?.id ?? 0, name: NonEmptyString(data!.country?.name ?? '')),
          city: City(
            id: data!.city?.id ?? 0,
            name: NonEmptyString(data!.city?.name ?? ''),
          ),
          isMentor: data!.isMentor ?? false,
          rating: data!.rating?.toDouble() ?? 0,
          position: data!.position ?? '',
          url: data!.url ?? '',
          students: Students(
            count: data!.students?.count?.toInt() ?? 0,
            data: data!.students?.data
                    ?.map((e) => UserInfo(
                          uuid: NonEmptyString(e.uuid ?? ''),
                          firstName: NonEmptyString(e.firstName ?? ''),
                          lastName: NonEmptyString(e.lastName ?? ''),
                          photo: NonEmptyString(e.photo ?? ''),
                          position: e.position ?? '',
                          rating: e.rating?.toDouble() ?? 0,
                          url: e.url ?? '',
                          email: Email.tagged(''),
                          isBanned: false,
                          phone: NonEmptyString(''),
                          country: Country.empty,
                          joinedAt: NonEmptyString(''),
                          isMentor: false,
                          age: 0,
                          city: City.empty,
                          birthday: NonEmptyString(''),
                          gender: NonEmptyString(''),
                        ))
                    .toList() ??
                [],
          ),
          goals: data!.goals
                  ?.map((e) => Goal(
                      id: e.id ?? 0,
                      title: NonEmptyString(e.title ?? ''),
                      type: NonEmptyString(e.type ?? ''),
                      status: NonEmptyString(e.status ?? ''),
                      progress: e.progress ?? 0,
                      startAt: e.startAt?.dateTimeFromBackend ?? DateTime.now(),
                      deadlineAt: e.deadlineAt?.dateTimeFromBackend ?? DateTime.now(),
                      pausedAt: e.pausedAt?.dateTimeFromBackend ?? DateTime.now(),
                      mentor: none(),
                      skill: Skill(
                        id: e.skill?.id ?? 0,
                        title: NonEmptyString(e.skill?.title ?? ''),
                        isAllowed: e.skill?.isAllowed ?? false,
                      ),
                      tags: e.tags?.map((e) => e).toList() ?? <String>[],
                      tasks: <Task>[],
                      comments: <Comment>[],
                      reports: none()))
                  .toList() ??
              <Goal>[],
          alreadyFollow: data!.alreadyFollow ?? false,
          alreadyMentor: data!.alreadyMentor ?? false);
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
