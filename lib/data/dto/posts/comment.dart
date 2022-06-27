import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/user/user.dart';
import 'package:sphere/domain/city/city.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/country/country.dart';
import 'package:sphere/domain/post/comment.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';
import 'package:sphere/ui/shared/all_shared.dart';

part 'comment.g.dart';

@JsonSerializable()
class CommentDto {
  CommentDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  CommentDataDto? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDtoToJson(this);
}

@JsonSerializable()
class CommentDataDto {
  int? id;
  String? body;
  String? createdAt;
  String? updatedAt;
  UserDataDto? user;
  List<CommentDataDto>? replies;

  CommentDataDto({
    this.id,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.replies,
  });

  factory CommentDataDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDataDtoToJson(this);
}

@JsonSerializable()
class CommentBody with EquatableMixin {
  CommentBody({
    required this.body,
    this.goalId,
    this.reportId,
    this.parentId,
  });

  final String body;
  final int? goalId;
  final int? reportId;
  final int? parentId;

  factory CommentBody.fromJson(Map<String, dynamic> json) =>
      _$CommentBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CommentBodyToJson(this);

  @override
  List<Object?> get props => [body, goalId, reportId, parentId];
}

extension CommentDtoX on CommentDto {
  Either<ExtendedErrors, Comment> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('AchievementDto: data is null'));
      }
      final domain = Comment(
          id: data!.id ?? 0,
          body: NonEmptyString(data!.body ?? ''),
          createdAt: data!.createdAt?.dateTimeFromBackend ?? DateTime.now(),
          updatedAt: data!.updatedAt?.dateTimeFromBackend ?? DateTime.now(),
          user: some(UserInfo(
              isBanned: false,
              phone: NonEmptyString(data!.user?.phone ?? ''),
              email: Email(data!.user?.email ?? ''),
              firstName: NonEmptyString(data!.user?.firstName ?? ''),
              joinedAt: NonEmptyString(data!.user?.joinedAt ?? ''),
              uuid: NonEmptyString(data!.user?.uuid ?? ''),
              lastName: NonEmptyString(data!.user?.lastName ?? ''),
              birthday: NonEmptyString(''),
              isMentor: data!.user?.isMentor ?? false,
              age: data!.user?.age ?? 0,
              city: City(
                id: data!.user?.city?.id ?? 0,
                name: NonEmptyString(data!.user?.city?.name ?? ''),
              ),
              photo: NonEmptyString(data!.user?.photo ?? ''),
              country: Country(
                  id: data!.user?.country?.id ?? 0,
                  name: NonEmptyString(data!.user?.country?.name ?? '')),
              gender: NonEmptyString(''))),
          replies: some(data!.replies
                  ?.map((z) => Comment(
                      id: z.id ?? 0,
                      body: NonEmptyString(z.body ?? ''),
                      createdAt:
                          z.createdAt?.dateTimeFromBackend ?? DateTime.now(),
                      updatedAt:
                          z.updatedAt?.dateTimeFromBackend ?? DateTime.now(),
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
                            name: NonEmptyString(z.user?.city?.name ?? ''),
                          ),
                          photo: NonEmptyString(z.user?.photo ?? ''),
                          country: Country(
                              id: z.user?.country?.id ?? 0,
                              name:
                                  NonEmptyString(z.user?.country?.name ?? '')),
                          gender: NonEmptyString(''))),
                      replies: none()))
                  .toList() ??
              <Comment>[]));
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
