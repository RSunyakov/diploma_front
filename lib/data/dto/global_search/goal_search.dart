import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/posts/goal.dart';
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

part 'goal_search.g.dart';

@JsonSerializable()
class GoalSearchDto {
  GoalSearchDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  List<GoalDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory GoalSearchDto.fromJson(Map<String, dynamic> json) =>
      _$GoalSearchDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GoalSearchDtoToJson(this);
}

extension GoalSearchDtoX on GoalSearchDto {
  Either<ExtendedErrors, List<Goal>> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('Client Search: data is null'));
      }
      final domain = data!
          .map((e) => Goal(
              id: e.id ?? 0,
              title: NonEmptyString(e.title ?? ''),
              type: NonEmptyString(e.type ?? ''),
              status: NonEmptyString(e.status ?? ''),
              progress: e.progress ?? 0,
              startAt: e.startAt?.dateTimeFromBackend ?? DateTime.now(),
              deadlineAt: e.deadlineAt?.dateTimeFromBackend ?? DateTime.now(),
              mentor: some(UserInfo(
                  uuid: NonEmptyString(e.mentor?.uuid ?? ''),
                  photo: NonEmptyString(e.mentor?.photo ?? ''),
                  email: Email.tagged(e.mentor?.email ?? ''),
                  phone: NonEmptyString(e.mentor?.phone ?? ''),
                  age: e.mentor?.age ?? 0,
                  gender: NonEmptyString(''),
                  isBanned: false,
                  firstName: NonEmptyString(e.mentor?.firstName ?? ''),
                  lastName: NonEmptyString(e.mentor?.lastName ?? ''),
                  birthday: NonEmptyString(''),
                  joinedAt: NonEmptyString(e.mentor?.joinedAt ?? ''),
                  country: Country.empty,
                  city: City.empty,
                  isMentor: e.mentor?.isMentor ?? false)),
              skill: Skill(
                id: e.skill?.id ?? 0,
                title: NonEmptyString(e.skill?.title ?? ''),
                isAllowed: e.skill?.isAllowed ?? false,
              ),
              tags: e.tags?.map((e) => e).toList() ?? [''],
              tasks: e.tasks
                      ?.map((x) => Task(
                            id: x.id ?? 0,
                            title: NonEmptyString(x.title ?? ''),
                            comment: NonEmptyString(x.comment ?? ''),
                            schedule: NonEmptyString(x.schedule ?? ''),
                            isCompleted: x.isCompleted ?? false,
                            startAt: some(x.startAt?.dateTimeFromBackend ??
                                DateTime.now()),
                            deadlineAt: some(
                                x.deadlineAt?.dateTimeFromBackend ??
                                    DateTime.now()),
                          ))
                      .toList() ??
                  <Task>[],
              comments: e.comments
                      ?.map((x) => Comment(
                          id: x.id ?? 0,
                          body: NonEmptyString(x.body ?? ''),
                          createdAt: x.createdAt?.dateTimeFromBackend ??
                              DateTime.now(),
                          updatedAt: x.updatedAt?.dateTimeFromBackend ??
                              DateTime.now(),
                          user: some(UserInfo(
                              isBanned: false,
                              phone: NonEmptyString(x.user?.phone ?? ''),
                              email: Email(x.user?.email ?? ''),
                              firstName:
                                  NonEmptyString(x.user?.firstName ?? ''),
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
                                  name: NonEmptyString(
                                      x.user?.country?.name ?? '')),
                              gender: NonEmptyString(''))),
                          replies: some(x.replies
                                  ?.map((z) => Comment(
                                      id: z.id ?? 0,
                                      body: NonEmptyString(z.body ?? ''),
                                      createdAt: z.createdAt?.dateTimeFromBackend ??
                                          DateTime.now(),
                                      updatedAt:
                                          z.updatedAt?.dateTimeFromBackend ??
                                              DateTime.now(),
                                      user: some(UserInfo(
                                          isBanned: false,
                                          phone: NonEmptyString(
                                              z.user?.phone ?? ''),
                                          email: Email(z.user?.email ?? ''),
                                          firstName: NonEmptyString(
                                              z.user?.firstName ?? ''),
                                          joinedAt: NonEmptyString(
                                              z.user?.joinedAt ?? ''),
                                          uuid: NonEmptyString(
                                              z.user?.uuid ?? ''),
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
                                          photo: NonEmptyString(
                                              z.user?.photo ?? ''),
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
              reports: some(e.reports?.map((e) => Report(id: e.id ?? 0, description: NonEmptyString(e.description ?? ''), file: NonEmptyString(e.file ?? ''), createdAt: e.createdAt?.dateTimeFromBackend ?? DateTime.now(), commentsCount: e.commentsCount ?? 0)).toList() ?? <Report>[])))
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
