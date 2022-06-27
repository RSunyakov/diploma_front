import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/data/dto/cities/cities.dart';
import 'package:sphere/domain/core/value_objects.dart';

import '../../../core/safe_coding/src/either.dart';
import '../../../core/safe_coding/src/option.dart';
import '../../../domain/city/city.dart';
import '../../../domain/core/extended_errors.dart';
import '../../../domain/country/country.dart';
import '../../../domain/user_settings/user_settings.dart';
import '../countries/countries.dart';
import 'notification.dart';
import 'setting.dart';

part 'user_settings.g.dart';

@JsonSerializable()
class UserSettingsDto {
  UserSettingsDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  UserSettingsDataDto? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory UserSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingsDtoToJson(this);

  @override
  String toString() {
    return 'UserSettingsDto{status: $status, data: $data, message: $message, errors: $errors}';
  }
}

@JsonSerializable()
class UserSettingsDataDto {
  String uuid;
  String? photo;
  String? email;
  String? phone;
  int? age;
  String? gender;
  bool? isBanned;
  String? firstName;
  String? lastName;
  String? birthday;
  String? joinedAt;
  CountryDataDto? country;
  CityDataDto? city;
  bool? isMentor;
  List<SettingDto>? settings;
  List<NotificationDto>? notifications;

  UserSettingsDataDto(
      {required this.uuid,
      this.photo,
      this.email,
      this.phone,
      this.age,
      this.gender,
      this.isBanned,
      this.firstName,
      this.lastName,
      this.birthday,
      this.joinedAt,
      this.country,
      this.city,
      this.isMentor,
      this.settings,
      this.notifications});

  factory UserSettingsDataDto.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingsDataDtoToJson(this);
}

extension UserSettingsDtoX on UserSettingsDto {
  Either<ExtendedErrors, UserSettings> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('ClientInfo: data is null'));
      }

      final domain = UserSettings(
        userInfo: UserInfo(
            uuid: NonEmptyString(data!.uuid),
            photo: NonEmptyString(data!.photo ?? ''),
            email: Email.tagged(data!.email ?? ''),
            phone: NonEmptyString(data!.phone ?? ''),
            age: data!.age ?? 0,
            gender: NonEmptyString(data!.gender ?? ''),
            isBanned: data!.isBanned ?? false,
            firstName: NonEmptyString(data!.firstName ?? ''),
            lastName: NonEmptyString(data!.lastName ?? ''),
            birthday: NonEmptyString(data!.birthday ?? ''),
            joinedAt:
                NonEmptyString(data!.joinedAt ?? '', failureTag: 'joinedAt'),
            country: Country(
              id: data!.country?.id ?? 0,
              name: NonEmptyString(data!.country?.name ?? ''),
            ),
            city: City(
              id: data!.city?.id ?? 0,
              name: NonEmptyString(data!.city?.name ?? ''),
            ),
            isMentor: data!.isMentor ?? false),
        settings: data!.settings == null
            ? none()
            : some(
                data!.settings!
                    .map(
                      (e) => Setting(
                        name: NonEmptyString(e.name ?? ''),
                        value: NonEmptyString(e.value ?? ''),
                      ),
                    )
                    .toList(),
              ),
        notifications: data!.notifications == null
            ? none()
            : some(
                data!.notifications!
                    .map(
                      (e) => NotificationSetting(
                        id: NonEmptyString(e.id ?? ''),
                        name: NonEmptyString(e.name ?? ''),
                      ),
                    )
                    .toList(),
              ),
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
