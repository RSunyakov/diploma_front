import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/posts/comment.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/post/comment.dart';
import 'package:sphere/domain/reports/report.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/domain/city/city.dart';
import 'package:sphere/domain/country/country.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';

part 'report_detail.g.dart';

@JsonSerializable()
class ReportDetailDto {
  ReportDetailDto({
    required this.status,
    this.message,
    this.errors,
    this.data,
  });

  bool status;
  ReportDetailDataDto? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory ReportDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ReportDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportDetailDtoToJson(this);

  @override
  String toString() {
    return 'ReportDetailDto{status: $status, data: $data, message: $message, errors: $errors}';
  }
}

@JsonSerializable()
class ReportDetailDataDto {
  int? id;
  String? description;
  String? date;
  String? file;
  String? createdAt;
  List<CommentDataDto>? comments;
  int? commentsCount;

  ReportDetailDataDto(
      {this.id,
      this.description,
      this.date,
      this.file,
      this.comments,
      this.createdAt,
      this.commentsCount});

  factory ReportDetailDataDto.fromJson(Map<String, dynamic> json) =>
      _$ReportDetailDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportDetailDataDtoToJson(this);

  @override
  String toString() {
    return 'ReportDetailDataDto{id: $id, description: $description, date: $date, file: $file, createdAt: $createdAt, comments: $comments, commentsCount: $commentsCount}';
  }
}

extension ReportDetailDtoX on ReportDetailDto {
  Either<ExtendedErrors, Report> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('Reports: data is null'));
      }
      return Right(Report(
          id: data!.id ?? 0,
          description: (data!.description ?? '').nonEmpty,
          file: (data!.file ?? '').nonEmpty,
          createdAt: data!.createdAt?.dateTimeFromBackend ?? now,
          comments: data!.comments
                  ?.map((x) => Comment(
                      id: x.id ?? 0,
                      body: NonEmptyString(x.body ?? ''),
                      createdAt: x.createdAt?.dateTimeFromBackend ?? now,
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
                              name:
                                  NonEmptyString(x.user?.country?.name ?? '')),
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
                                      phone:
                                          NonEmptyString(z.user?.phone ?? ''),
                                      email: Email(z.user?.email ?? ''),
                                      firstName: NonEmptyString(
                                          z.user?.firstName ?? ''),
                                      joinedAt: NonEmptyString(
                                          z.user?.joinedAt ?? ''),
                                      uuid: NonEmptyString(z.user?.uuid ?? ''),
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
                                      country: Country(
                                          id: z.user?.country?.id ?? 0,
                                          name: NonEmptyString(
                                              z.user?.country?.name ?? '')),
                                      gender: NonEmptyString(''))),
                                  replies: none()))
                              .toList() ??
                          <Comment>[])))
                  .toList() ??
              [],
          commentsCount: data!.commentsCount ?? 0));
    } on Error catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on CheckedFromJsonException catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on Exception catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    }
  }
}
