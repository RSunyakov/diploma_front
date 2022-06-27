import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/followers_follows/followers_follows.dart';

import '../../../core/safe_coding/src/either.dart';
import '../../../domain/core/extended_errors.dart';

part 'followers_follows.g.dart';

@JsonSerializable()
class FollowersFollowsDto {
  FollowersFollowsDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  List<FollowersFollowsDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory FollowersFollowsDto.fromJson(Map<String, dynamic> json) =>
      _$FollowersFollowsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FollowersFollowsDtoToJson(this);
}

@JsonSerializable()
class FollowersFollowsDataDto {
  final String uuid;
  final String firstName;
  final String? lastName;
  final String? photo;
  final String? position;
  final double rating;
  final String? url;

  FollowersFollowsDataDto({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    this.photo,
    required this.position,
    required this.rating,
    this.url,
  });

  factory FollowersFollowsDataDto.fromJson(Map<String, dynamic> json) =>
      _$FollowersFollowsDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FollowersFollowsDataDtoToJson(this);
}

extension FollowersFollowsDtoX on FollowersFollowsDto {
  Either<ExtendedErrors, List<FollowersFollows>> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('FollowersFollows: data is null'));
      }

      final domain = data!
          .map((e) => FollowersFollows(
                uuid: NonEmptyString(e.uuid),
                firstName: NonEmptyString(e.firstName),
                lastName: NonEmptyString(e.lastName ?? ''),
                photo: NonEmptyString(e.photo ?? ''),
                position:
                    NonEmptyString(e.position ?? '', failureTag: 'Position'),
                rating: e.rating,
                url: NonEmptyString(e.url ?? ''),
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
