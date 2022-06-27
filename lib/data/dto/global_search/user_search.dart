import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/user/user.dart';
import 'package:sphere/domain/city/city.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/country/country.dart';
import 'package:sphere/domain/occupation/occupation.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:vfx_flutter_common/utils.dart';

part 'user_search.g.dart';

@JsonSerializable()
class UserSearchDto {
  UserSearchDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  List<UserDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory UserSearchDto.fromJson(Map<String, dynamic> json) =>
      _$UserSearchDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserSearchDtoToJson(this);
}

extension UserSearchDtoX on UserSearchDto {
  Either<ExtendedErrors, List<UserInfo>> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('Client Search: data is null'));
      }
      final domain = data!
          .map((e) => UserInfo(
              uuid: NonEmptyString(e.uuid ?? ''),
              photo: NonEmptyString(e.photo ?? ''),
              email: Email.tagged(e.email ?? ''),
              phone: NonEmptyString(e.phone ?? ''),
              age: e.age ?? 0,
              gender: NonEmptyString(''),
              isBanned: false,
              firstName: NonEmptyString(e.firstName ?? ''),
              lastName: NonEmptyString(e.lastName ?? ''),
              birthday: NonEmptyString(''),
              joinedAt: NonEmptyString(e.joinedAt ?? ''),
              country: Country(
                  id: e.country?.id ?? 0,
                  name: NonEmptyString(e.country?.name ?? '')),
              city: City(
                  id: e.city?.id ?? 0,
                  name: NonEmptyString(e.city?.name ?? '')),
              isMentor: e.isMentor ?? false,
              position: e.position ?? '',
              rating: e.rating?.toDouble() ?? 0,
              career: e.career
                      ?.map((e) => WorkOccupation(
                          title: NonEmptyString(e.companyName),
                          occupation: NonEmptyString(e.positionName),
                          beginDateTime:
                              beginDateTime(e.dateStart.dateTimeFromBackend),
                          endDateTime: some(endDateTime(e.dateEnd == null
                              ? now
                              : e.dateEnd!.dateTimeFromBackend))))
                      .toList() ??
                  <WorkOccupation>[]))
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
