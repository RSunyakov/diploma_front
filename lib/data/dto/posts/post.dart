import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/posts/goal.dart';
import 'package:sphere/data/dto/user/user.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/post/goal.dart';
import 'package:sphere/domain/post/post.dart';
import 'package:sphere/domain/post/skill.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import '../../../domain/city/city.dart';
import '../../../domain/country/country.dart';
import '../../../domain/post/comment.dart';
import '../../../domain/post/task.dart';

part 'post.g.dart';

@JsonSerializable()
class PostDto {
  PostDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  List<PostDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PostDtoToJson(this);
}

@JsonSerializable()
class PostDataDto {
  int? id;
  String? title;
  num? amount;
  String? type;
  UserDataDto? user;
  GoalDataDto? goal;
  //TODO(syyunek): возможно, здесь не [String]
  List<String>? tags;

  PostDataDto({
    this.id,
    this.title,
    this.amount,
    this.type,
    this.user,
    this.goal,
    this.tags,
  });

  factory PostDataDto.fromJson(Map<String, dynamic> json) =>
      _$PostDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PostDataDtoToJson(this);
}

extension PostDtoX on PostDto {
  Either<ExtendedErrors, List<Post>> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('Common Posts: data is null'));
      }
      final domain = data!
          .map((e) => Post(
                id: e.id ?? 0,
                title: NonEmptyString(e.title ?? ''),
                amount: e.amount ?? 0,
                user: UserInfo(
                    uuid: NonEmptyString(e.user?.uuid ?? ''),
                    photo: NonEmptyString(e.user?.photo ?? ''),
                    email: Email.tagged(e.user?.email ?? ''),
                    phone: NonEmptyString(e.user?.phone ?? ''),
                    age: e.user?.age ?? 0,
                    gender: NonEmptyString(''),
                    isBanned: false,
                    firstName: NonEmptyString(e.user?.firstName ?? ''),
                    lastName: NonEmptyString(e.user?.lastName ?? ''),
                    birthday: NonEmptyString(''),
                    joinedAt: NonEmptyString(e.user!.joinedAt ?? ''),
                    position: e.user?.position ?? '',
                    country: Country(
                        id: e.user?.country?.id ?? 0,
                        name: NonEmptyString(e.user?.country?.name ?? '')),
                    city: City(
                      id: e.user?.city?.id ?? 0,
                      name: NonEmptyString(e.user?.city?.name ?? ''),
                    ),
                    isMentor: e.user?.isMentor ?? false,
                    rating: e.user?.rating?.toDouble() ?? 0),
                goal: Goal(
                  id: e.goal!.id ?? 0,
                  title: NonEmptyString(e.goal?.title ?? ''),
                  type: NonEmptyString(e.goal?.type ?? ''),
                  status: NonEmptyString(e.goal?.status ?? ''),
                  progress: e.goal?.progress ?? 0,
                  startAt:
                      e.goal?.startAt?.dateTimeFromBackend ?? DateTime.now(),
                  deadlineAt:
                      e.goal?.deadlineAt?.dateTimeFromBackend ?? DateTime.now(),
                  pausedAt:
                      e.goal?.pausedAt?.dateTimeFromBackend ?? DateTime.now(),
                  mentor: some(UserInfo(
                    uuid: NonEmptyString(e.goal?.mentor?.uuid ?? ''),
                    photo: NonEmptyString(e.goal?.mentor?.photo ?? ''),
                    email: Email.tagged(e.goal?.mentor?.email ?? ''),
                    phone: NonEmptyString(e.goal?.mentor?.phone ?? ''),
                    age: e.goal?.mentor?.age ?? 0,
                    gender: NonEmptyString(''),
                    isBanned: false,
                    firstName: NonEmptyString(e.goal?.mentor?.firstName ?? ''),
                    middleName: e.goal?.mentor?.middleName ?? '',
                    lastName: NonEmptyString(e.goal?.mentor?.lastName ?? ''),
                    geo: e.goal?.mentor?.geo,
                    birthday: NonEmptyString(''),
                    joinedAt: NonEmptyString(e.goal?.mentor?.joinedAt ?? ''),
                    position: e.goal?.mentor?.position ?? '',
                    country: Country.empty,
                    city: City.empty,
                    isMentor: e.goal?.mentor?.isMentor ?? false,
                  )),
                  skill: Skill(
                      id: e.goal!.skill!.id ?? 0,
                      title: NonEmptyString(e.goal!.skill!.title ?? ''),
                      isAllowed: e.goal?.skill?.isAllowed ?? false),
                  tags: e.goal?.tags?.map((e) => e).toList() ?? [''],
                  tasks: e.goal?.tasks
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
                      [Task.empty()],
                  comments: e.goal?.comments
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
                                    name: NonEmptyString(
                                        x.user?.city?.name ?? ''),
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
                                              photo: NonEmptyString(z.user?.photo ?? ''),
                                              country: Country(id: z.user?.country?.id ?? 0, name: NonEmptyString(z.user?.country?.name ?? '')),
                                              gender: NonEmptyString(''))),
                                          replies: none()))
                                      .toList() ??
                                  <Comment>[])))
                          .toList() ??
                      <Comment>[],
                  reports: none(),
                ),
                tags: e.tags?.map((e) => e).toList() ?? [''],
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
